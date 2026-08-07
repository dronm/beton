<?php

declare(strict_types=1);

require_once("vehicle_track_osrm_conf.php");

final class VehicleTrackOsrmException extends RuntimeException
{
	public function __construct(
		public readonly string $osrmCode,
		string $message,
		int $httpStatus = 0,
		?Throwable $previous = null,
	) {
		parent::__construct($message, $httpStatus, $previous);
	}
}

function vehicleTrackConfig(string $name, mixed $default = null): mixed
{
	if (defined($name)) {
		return constant($name);
	}

	if (array_key_exists($name, $GLOBALS)) {
		return $GLOBALS[$name];
	}

	return $default;
}

function vehicleTrackFormatFloat(float $value, int $precision = 7): string
{
	$result = number_format($value, $precision, '.', '');
	$result = rtrim($result, '0');
	$result = rtrim($result, '.');

	return $result === '' || $result === '-0' ? '0' : $result;
}

function vehicleTrackDecodePosDataPoint(mixed $posData): array
{
	if (is_string($posData)) {
		try {
			$point = json_decode(
				$posData,
				true,
				512,
				JSON_THROW_ON_ERROR,
			);
		} catch (JsonException $e) {
			throw new RuntimeException(
				'pos_data contains invalid JSON: '.$e->getMessage(),
				0,
				$e,
			);
		}
	} elseif (is_array($posData)) {
		$point = $posData;
	} else {
		throw new RuntimeException(
			sprintf(
				'pos_data must be JSON text or an array; received %s.',
				get_debug_type($posData),
			),
		);
	}

	if (!is_array($point) || array_is_list($point)) {
		throw new RuntimeException(
			'pos_data must contain one JSON track point object.',
		);
	}

	return $point;
}

function vehicleTrackPointTimestamp(array $point): ?int
{
	if (isset($point['timestamp']) && is_numeric($point['timestamp'])) {
		return (int) $point['timestamp'];
	}

	$period = $point['period'] ?? null;

	if (!is_string($period) || trim($period) === '') {
		return null;
	}

	try {
		$dateTime = new DateTimeImmutable(
			$period,
			new DateTimeZone('UTC'),
		);
	} catch (Exception) {
		return null;
	}

	return $dateTime->getTimestamp();
}

function vehicleTrackBuildInputPoints(array $points): array
{
	$inputPoints = [];

	foreach ($points as $sourceIndex => $point) {
		if (!is_array($point)) {
			continue;
		}

		$lon = $point['lon'] ?? null;
		$lat = $point['lat'] ?? null;

		if (!is_numeric($lon) || !is_numeric($lat)) {
			continue;
		}

		$lon = (float) $lon;
		$lat = (float) $lat;

		if (
			$lon < -180.0
			|| $lon > 180.0
			|| $lat < -90.0
			|| $lat > 90.0
		) {
			continue;
		}

		$inputPoints[] = [
			'source_index' => (int) $sourceIndex,
			'lon' => $lon,
			'lat' => $lat,
			'timestamp' => vehicleTrackPointTimestamp($point),
		];
	}

	return $inputPoints;
}

function vehicleTrackSplitTrips(array $inputPoints): array
{
	if ($inputPoints === []) {
		return [];
	}

	$gapSeconds = max(
		0,
		(int) vehicleTrackConfig('OSRM_TRACK_SPLIT_GAP_SECONDS', 600),
	);

	if ($gapSeconds === 0) {
		return [$inputPoints];
	}

	$trips = [];
	$currentTrip = [];
	$previousTimestamp = null;

	foreach ($inputPoints as $point) {
		$currentTimestamp = $point['timestamp'];

		if (
			$currentTrip !== []
			&& $previousTimestamp !== null
			&& $currentTimestamp !== null
			&& $currentTimestamp - $previousTimestamp >= $gapSeconds
		) {
			$trips[] = $currentTrip;
			$currentTrip = [];
		}

		$currentTrip[] = $point;
		$previousTimestamp = $currentTimestamp;
	}

	if ($currentTrip !== []) {
		$trips[] = $currentTrip;
	}

	return $trips;
}

function vehicleTrackBuildOsrmUrl(array $batch): string
{
	$protocol = strtolower(
		trim(
			(string) vehicleTrackConfig(
				'OSRM_PROTOCOL',
				vehicleTrackConfig('OSRM_PROTOCOLE', 'http'),
			),
		),
	);
	$host = trim(
		(string) vehicleTrackConfig('OSRM_HOST', '127.0.0.1'),
		"/ \t\n\r\0\x0B",
	);
	$port = (int) vehicleTrackConfig('OSRM_PORT', 5000);

	if (!in_array($protocol, ['http', 'https'], true)) {
		throw new RuntimeException(
			'OSRM_PROTOCOL must be either "http" or "https".',
		);
	}

	if ($host === '') {
		throw new RuntimeException('OSRM_HOST is empty.');
	}

	if ($port < 1 || $port > 65535) {
		throw new RuntimeException('OSRM_PORT is invalid.');
	}

	$radiusMeters = max(
		1.0,
		(float) vehicleTrackConfig('OSRM_TRACK_RADIUS_METERS', 30.0),
	);

	$coordinates = [];
	$radiuses = [];
	$timestamps = [];
	$useTimestamps = true;
	$previousTimestamp = null;

	foreach ($batch as $point) {
		$coordinates[] = sprintf(
			'%s,%s',
			vehicleTrackFormatFloat((float) $point['lon']),
			vehicleTrackFormatFloat((float) $point['lat']),
		);
		$radiuses[] = vehicleTrackFormatFloat($radiusMeters, 1);

		$timestamp = $point['timestamp'];

		if (
			$timestamp === null
			|| ($previousTimestamp !== null && $timestamp <= $previousTimestamp)
		) {
			$useTimestamps = false;
		} else {
			$timestamps[] = (string) $timestamp;
			$previousTimestamp = $timestamp;
		}
	}

	$query = [
		'radiuses='.implode(';', $radiuses),
		'gaps=split',
		'tidy=false',
		'steps=false',
		'overview=false',
		'annotations=false',
	];

	if ($useTimestamps) {
		array_unshift(
			$query,
			'timestamps='.implode(';', $timestamps),
		);
	}

	return sprintf(
		'%s://%s:%d/match/v1/driving/%s?%s',
		$protocol,
		$host,
		$port,
		implode(';', $coordinates),
		implode('&', $query),
	);
}

function vehicleTrackCallOsrm(array $batch): array
{
	if (!function_exists('curl_init')) {
		throw new RuntimeException(
			'The PHP cURL extension is not installed.',
		);
	}

	$curl = curl_init();

	if ($curl === false) {
		throw new RuntimeException('Could not initialize cURL.');
	}

	curl_setopt_array(
		$curl,
		[
			CURLOPT_URL => vehicleTrackBuildOsrmUrl($batch),
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_CONNECTTIMEOUT => max(
				1,
				(int) vehicleTrackConfig(
					'OSRM_TRACK_CONNECT_TIMEOUT_SECONDS',
					5,
				),
			),
			CURLOPT_TIMEOUT => max(
				1,
				(int) vehicleTrackConfig(
					'OSRM_TRACK_TIMEOUT_SECONDS',
					60,
				),
			),
			CURLOPT_FAILONERROR => false,
			CURLOPT_HTTPHEADER => [
				'Accept: application/json',
			],
		],
	);

	$responseBody = curl_exec($curl);
	$curlError = curl_error($curl);
	$httpStatus = (int) curl_getinfo($curl, CURLINFO_HTTP_CODE);

	curl_close($curl);

	if ($responseBody === false) {
		throw new RuntimeException(
			sprintf('OSRM request failed: %s', $curlError),
		);
	}

	try {
		$response = json_decode(
			(string) $responseBody,
			true,
			512,
			JSON_THROW_ON_ERROR,
		);
	} catch (JsonException $e) {
		throw new RuntimeException(
			sprintf(
				'OSRM returned invalid JSON. HTTP status: %d.',
				$httpStatus,
			),
			0,
			$e,
		);
	}

	if (!is_array($response)) {
		throw new RuntimeException('OSRM returned an invalid response.');
	}

	$osrmCode = (string) ($response['code'] ?? 'Unknown');

	if ($httpStatus !== 200 || $osrmCode !== 'Ok') {
		throw new VehicleTrackOsrmException(
			$osrmCode,
			sprintf(
				'OSRM match failed. HTTP status: %d, code: %s, message: %s',
				$httpStatus,
				$osrmCode,
				(string) ($response['message'] ?? 'no message'),
			),
			$httpStatus,
		);
	}

	return $response;
}

function vehicleTrackApplyOsrmResponse(
	array &$points,
	array $batch,
	array $response,
): void {
	$tracepoints = $response['tracepoints'] ?? null;

	if (!is_array($tracepoints)) {
		return;
	}

	$maxSnapDistance = vehicleTrackConfig(
		'OSRM_TRACK_MAX_SNAP_DISTANCE_METERS',
		null,
	);
	$keepRawCoordinates = (bool) vehicleTrackConfig(
		'OSRM_TRACK_KEEP_RAW_COORDINATES',
		false,
	);
	$addMatchInfo = (bool) vehicleTrackConfig(
		'OSRM_TRACK_ADD_MATCH_INFO',
		false,
	);

	foreach ($batch as $localIndex => $inputPoint) {
		$tracepoint = $tracepoints[$localIndex] ?? null;

		if (!is_array($tracepoint)) {
			continue;
		}

		$location = $tracepoint['location'] ?? null;

		if (
			!is_array($location)
			|| count($location) < 2
			|| !is_numeric($location[0])
			|| !is_numeric($location[1])
		) {
			continue;
		}

		$snapDistance = isset($tracepoint['distance'])
			&& is_numeric($tracepoint['distance'])
			? (float) $tracepoint['distance']
			: null;

		if (
			$maxSnapDistance !== null
			&& $snapDistance !== null
			&& $snapDistance > (float) $maxSnapDistance
		) {
			continue;
		}

		$sourceIndex = (int) $inputPoint['source_index'];

		if (!isset($points[$sourceIndex]) || !is_array($points[$sourceIndex])) {
			continue;
		}

		if ($keepRawCoordinates) {
			$points[$sourceIndex]['raw_lon'] = (float) $inputPoint['lon'];
			$points[$sourceIndex]['raw_lat'] = (float) $inputPoint['lat'];
		}

		$points[$sourceIndex]['lon'] = (float) $location[0];
		$points[$sourceIndex]['lat'] = (float) $location[1];

		if ($addMatchInfo) {
			$points[$sourceIndex]['osrm_matched'] = true;
			$points[$sourceIndex]['osrm_distance'] = $snapDistance;
			$points[$sourceIndex]['osrm_name'] = (string) (
				$tracepoint['name'] ?? ''
			);
		}
	}
}

function vehicleTrackProcessBatch(
	array &$points,
	array $batch,
): void {
	if (count($batch) < 2) {
		return;
	}

	try {
		$response = vehicleTrackCallOsrm($batch);
		vehicleTrackApplyOsrmResponse($points, $batch, $response);
	} catch (VehicleTrackOsrmException $e) {
		if ($e->osrmCode === 'TooBig' && count($batch) > 2) {
			$middle = intdiv(count($batch), 2);
			$left = array_slice($batch, 0, $middle + 1);
			$right = array_slice($batch, $middle);

			vehicleTrackProcessBatch($points, $left);
			vehicleTrackProcessBatch($points, $right);

			return;
		}

		if (!(bool) vehicleTrackConfig('OSRM_TRACK_FALLBACK_TO_RAW', true)) {
			throw $e;
		}
	} catch (Throwable $e) {
		if (!(bool) vehicleTrackConfig('OSRM_TRACK_FALLBACK_TO_RAW', true)) {
			throw $e;
		}
	}
}

function vehicleTrackMatchPoints(array $points): array
{
	$maxPoints = (int) vehicleTrackConfig(
		'OSRM_TRACK_MAX_POINTS_PER_REQUEST',
		1000,
	);

	if ($maxPoints < 2) {
		throw new RuntimeException(
			'OSRM_TRACK_MAX_POINTS_PER_REQUEST must be at least 2.',
		);
	}

	$inputPoints = vehicleTrackBuildInputPoints($points);

	if (count($inputPoints) < 2) {
		return $points;
	}

	foreach (vehicleTrackSplitTrips($inputPoints) as $trip) {
		$tripPointCount = count($trip);

		if ($tripPointCount < 2) {
			continue;
		}

		$start = 0;

		while ($start < $tripPointCount - 1) {
			$end = min($start + $maxPoints, $tripPointCount);
			$batch = array_slice($trip, $start, $end - $start);

			vehicleTrackProcessBatch($points, $batch);

			if ($end >= $tripPointCount) {
				break;
			}

			$start = $end - 1;
		}
	}

	return $points;
}

function vehicleTrackMatchRows(array $rows): array
{
	$points = [];
	$pointRowIndexes = [];

	foreach ($rows as $rowIndex => $row) {
		if (!is_array($row)) {
			throw new RuntimeException(
				sprintf(
					'Track row at index %d must be an array.',
					$rowIndex,
				),
			);
		}

		if (!array_key_exists('pos_data', $row)) {
			throw new RuntimeException(
				sprintf(
					'Track row at index %d does not contain pos_data.',
					$rowIndex,
				),
			);
		}

		try {
			$points[] = vehicleTrackDecodePosDataPoint($row['pos_data']);
			$pointRowIndexes[] = $rowIndex;
		} catch (Throwable $e) {
			throw new RuntimeException(
				sprintf(
					'Could not decode pos_data in track row %d: %s',
					$rowIndex,
					$e->getMessage(),
				),
				0,
				$e,
			);
		}
	}

	$matchedPoints = vehicleTrackMatchPoints($points);

	foreach ($pointRowIndexes as $pointIndex => $rowIndex) {
		$rows[$rowIndex]['pos_data'] = $matchedPoints[$pointIndex];
	}

	return $rows;
}
