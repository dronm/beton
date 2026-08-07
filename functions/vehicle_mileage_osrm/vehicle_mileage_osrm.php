<?php

declare(strict_types=1);

require_once("config.php");
require_once(dirname(__FILE__).'/../db_con.php');

function vehicleMileageConfig(string $name, mixed $default = null): mixed
{
	if (defined($name)) {
		return constant($name);
	}

	if (array_key_exists($name, $GLOBALS)) {
		return $GLOBALS[$name];
	}

	return $default;
}

function vehicleMileagePgLiteral(string $value): string
{
	if (str_contains($value, "\0")) {
		throw new InvalidArgumentException('PostgreSQL literal contains a null byte.');
	}

	return "'" . str_replace("'", "''", $value) . "'";
}

function vehicleMileageParseUtcTimestamp(string $value): DateTimeImmutable
{
	$value = trim($value);

	if ($value === '') {
		throw new InvalidArgumentException('Timestamp cannot be empty.');
	}

	try {
		$dateTime = new DateTimeImmutable(
			$value,
			new DateTimeZone('UTC'),
		);
	} catch (Exception $e) {
		throw new InvalidArgumentException(
			sprintf('Invalid timestamp "%s".', $value),
			0,
			$e,
		);
	}

	return $dateTime->setTimezone(new DateTimeZone('UTC'));
}

function vehicleMileageQueryRows(object $dbLink, string $sql): array
{
	if (!method_exists($dbLink, 'query')) {
		throw new RuntimeException(
			'The database wrapper must provide query(string $sql).',
		);
	}

	if (!method_exists($dbLink, 'fetch_array')) {
		throw new RuntimeException(
			'The database wrapper must provide fetch_array($queryId).',
		);
	}

	$queryId = $dbLink->query($sql);
	$rows = [];

	while ($row = $dbLink->fetch_array($queryId)) {
		if (!is_array($row)) {
			throw new RuntimeException(
				'Database fetch_array() returned an invalid row.',
			);
		}

		$rows[] = $row;
	}

	return $rows;
}

function vehicleMileageQueryFirst(object $dbLink, string $sql): array
{
	if (method_exists($dbLink, 'query_first')) {
		$row = $dbLink->query_first($sql);

		if (!is_array($row)) {
			throw new RuntimeException(
				'Database query_first() did not return a row.',
			);
		}

		return $row;
	}

	$rows = vehicleMileageQueryRows($dbLink, $sql);

	if ($rows === []) {
		throw new RuntimeException('Database query returned no rows.');
	}

	return $rows[0];
}

/**
 * Fetch ordered GPS points.
 *
 * car_tracking.period is timestamp without time zone and stores UTC.
 * Points sharing the same Unix second are deduplicated because OSRM requires
 * monotonically increasing integer timestamps.
 */
function vehicleMileageFetchPoints(
	object $dbLink,
	string $carId,
	DateTimeImmutable $dateFrom,
	DateTimeImmutable $dateTo,
): array {
	if ($carId === '') {
		throw new InvalidArgumentException('Car ID cannot be empty.');
	}

	if (strlen($carId) > 15) {
		throw new InvalidArgumentException('Car ID cannot exceed 15 characters.');
	}

	if ($dateFrom >= $dateTo) {
		throw new InvalidArgumentException(
			'The beginning of the period must be earlier than the end.',
		);
	}

	$dateFromSql = $dateFrom->format('Y-m-d H:i:s.u');
	$dateToSql = $dateTo->format('Y-m-d H:i:s.u');

	$sql = sprintf(
		<<<'SQL'
			WITH source_points AS (
				SELECT
					ct.period,
					FLOOR(
						EXTRACT(EPOCH FROM ct.period)
					)::bigint AS epoch_second,
					ct.lon,
					ct.lat,
					ct.hdop,
					ct.sat_num
				FROM public.car_tracking AS ct
				WHERE
					ct.car_id = %s
					AND ct.gps_valid = 1
					AND ct.period >= %s::timestamp
					AND ct.period < %s::timestamp
					AND ct.lon IS NOT NULL
					AND ct.lat IS NOT NULL
					AND ct.lon BETWEEN -180 AND 180
					AND ct.lat BETWEEN -90 AND 90
			),
			unique_points AS (
				SELECT DISTINCT ON (epoch_second)
					period,
					epoch_second,
					lon,
					lat,
					hdop,
					sat_num
				FROM source_points
				ORDER BY
					epoch_second,
					hdop ASC NULLS LAST,
					sat_num DESC NULLS LAST,
					period ASC
			)
			SELECT
				COALESCE(
					JSON_AGG(
						JSON_BUILD_OBJECT(
							'period',
							period,
							'timestamp',
							epoch_second,
							'lon',
							lon,
							'lat',
							lat,
							'hdop',
							hdop,
							'sat_num',
							sat_num
						)
						ORDER BY epoch_second
					),
					'[]'::json
				)::text AS points_json
			FROM unique_points
			SQL,
		vehicleMileagePgLiteral($carId),
		vehicleMileagePgLiteral($dateFromSql),
		vehicleMileagePgLiteral($dateToSql),
	);

	$row = vehicleMileageQueryFirst($dbLink, $sql);
	$pointsJson = $row['points_json'] ?? '[]';

	if (is_array($pointsJson)) {
		$points = $pointsJson;
	} else {
		try {
			$points = json_decode(
				(string) $pointsJson,
				true,
				512,
				JSON_THROW_ON_ERROR,
			);
		} catch (JsonException $e) {
			throw new RuntimeException(
				'Could not decode GPS points returned by PostgreSQL.',
				0,
				$e,
			);
		}
	}

	if (!is_array($points)) {
		throw new RuntimeException('GPS points JSON is not an array.');
	}

	$resultPoints = [];
	$previousTimestamp = null;

	foreach ($points as $point) {
		if (!is_array($point)) {
			continue;
		}

		if (
			!isset($point['timestamp'])
			|| !isset($point['lon'])
			|| !isset($point['lat'])
		) {
			continue;
		}

		$timestamp = (int) $point['timestamp'];
		$lon = (float) $point['lon'];
		$lat = (float) $point['lat'];

		if (
			!is_finite($lon)
			|| !is_finite($lat)
			|| $lon < -180
			|| $lon > 180
			|| $lat < -90
			|| $lat > 90
		) {
			continue;
		}

		if (
			$previousTimestamp !== null
			&& $timestamp <= $previousTimestamp
		) {
			continue;
		}

		$resultPoints[] = [
			'global_index' => count($resultPoints),
			'period' => (string) ($point['period'] ?? ''),
			'timestamp' => $timestamp,
			'lon' => $lon,
			'lat' => $lat,
			'hdop' => $point['hdop'] !== null
				? (float) $point['hdop']
				: null,
			'sat_num' => $point['sat_num'] !== null
				? (int) $point['sat_num']
				: null,
		];

		$previousTimestamp = $timestamp;
	}

	return $resultPoints;
}

function vehicleMileageCalculateRadius(
	?float $hdop,
	?int $satNum,
): float {
	$minRadius = (float) vehicleMileageConfig(
		'OSRM_MATCH_MIN_RADIUS_METERS',
		5.0,
	);

	$maxRadius = (float) vehicleMileageConfig(
		'OSRM_MATCH_MAX_RADIUS_METERS',
		50.0,
	);

	$defaultRadius = (float) vehicleMileageConfig(
		'OSRM_MATCH_DEFAULT_RADIUS_METERS',
		15.0,
	);

	$hdopMultiplier = (float) vehicleMileageConfig(
		'OSRM_MATCH_HDOP_RADIUS_MULTIPLIER',
		5.0,
	);

	$lowSatelliteMultiplier = (float) vehicleMileageConfig(
		'OSRM_MATCH_LOW_SATELLITE_MULTIPLIER',
		1.5,
	);

	if ($hdop === null || $hdop <= 0) {
		$radius = $defaultRadius;
	} else {
		$radius = $hdop * $hdopMultiplier;
	}

	if ($satNum !== null && $satNum < 4) {
		$radius *= $lowSatelliteMultiplier;
	}

	return max(
		$minRadius,
		min($radius, $maxRadius),
	);
}

function vehicleMileageFormatFloat(float $value, int $precision): string
{
	$formatted = number_format(
		$value,
		$precision,
		'.',
		'',
	);

	$formatted = rtrim($formatted, '0');
	$formatted = rtrim($formatted, '.');

	return $formatted === '' ? '0' : $formatted;
}

function vehicleMileageBuildOsrmUrl(array $points): string
{
	$protocol = strtolower(
		trim(
			(string) vehicleMileageConfig(
				'OSRM_PROTOCOLE',
				vehicleMileageConfig('OSRM_PROTOCOL', 'http'),
			),
		),
	);

	$host = trim(
		(string) vehicleMileageConfig('OSRM_HOST', ''),
		"/ \t\n\r\0\x0B",
	);

	$port = (int) vehicleMileageConfig('OSRM_PORT', 5000);

	if (!in_array($protocol, ['http', 'https'], true)) {
		throw new RuntimeException(
			'OSRM_PROTOCOLE must be either "http" or "https".',
		);
	}

	if ($host === '') {
		throw new RuntimeException('OSRM_HOST is not configured.');
	}

	if ($port < 1 || $port > 65535) {
		throw new RuntimeException('OSRM_PORT is invalid.');
	}

	$coordinates = [];
	$timestamps = [];
	$radiuses = [];

	foreach ($points as $point) {
		$coordinates[] = sprintf(
			'%s,%s',
			vehicleMileageFormatFloat((float) $point['lon'], 7),
			vehicleMileageFormatFloat((float) $point['lat'], 7),
		);

		$timestamps[] = (string) ((int) $point['timestamp']);

		$radiuses[] = vehicleMileageFormatFloat(
			vehicleMileageCalculateRadius(
				$point['hdop'],
				$point['sat_num'],
			),
			1,
		);
	}

	$tidy = (bool) vehicleMileageConfig(
		'OSRM_MATCH_TIDY',
		false,
	);

	return sprintf(
		'%s://%s:%d/match/v1/driving/%s'
			. '?timestamps=%s'
			. '&radiuses=%s'
			. '&gaps=ignore'
			. '&tidy=%s'
			. '&steps=false'
			. '&overview=false'
			. '&annotations=false',
		$protocol,
		$host,
		$port,
		implode(';', $coordinates),
		implode(';', $timestamps),
		implode(';', $radiuses),
		$tidy ? 'true' : 'false',
	);
}

function vehicleMileageCallOsrm(
	string $url,
	int $tripNumber,
	int $batchNumber,
	int $pointCount,
): array {
	if (!function_exists('curl_init')) {
		throw new RuntimeException('The PHP cURL extension is not installed.');
	}

	$connectTimeout = (int) vehicleMileageConfig(
		'OSRM_MATCH_CONNECT_TIMEOUT_SECONDS',
		5,
	);

	$requestTimeout = (int) vehicleMileageConfig(
		'OSRM_MATCH_TIMEOUT_SECONDS',
		60,
	);

	$curl = curl_init();

	if ($curl === false) {
		throw new RuntimeException('Could not initialize cURL.');
	}

	curl_setopt_array(
		$curl,
		[
			CURLOPT_URL => $url,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_CONNECTTIMEOUT => $connectTimeout,
			CURLOPT_TIMEOUT => $requestTimeout,
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
			sprintf(
				'OSRM request for trip %d, batch %d failed: %s',
				$tripNumber,
				$batchNumber,
				$curlError,
			),
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
				'OSRM returned invalid JSON for trip %d, batch %d. HTTP status: %d.',
				$tripNumber,
				$batchNumber,
				$httpStatus,
			),
			0,
			$e,
		);
	}

	if (!is_array($response)) {
		throw new RuntimeException(
			sprintf(
				'OSRM returned an invalid response for trip %d, batch %d.',
				$tripNumber,
				$batchNumber,
			),
		);
	}

	$code = (string) ($response['code'] ?? '');
	$message = (string) ($response['message'] ?? '');

	if ($httpStatus !== 200 || $code !== 'Ok') {
		throw new RuntimeException(
			sprintf(
				'OSRM trip %d, batch %d failed. HTTP: %d; code: %s; message: %s',
				$tripNumber,
				$batchNumber,
				$httpStatus,
				$code !== '' ? $code : 'unknown',
				$message !== '' ? $message : 'none',
			),
		);
	}

	$matchings = $response['matchings'] ?? null;
	$tracepoints = $response['tracepoints'] ?? null;

	if (!is_array($matchings) || count($matchings) === 0) {
		throw new RuntimeException(
			sprintf(
				'OSRM returned no matchings for trip %d, batch %d.',
				$tripNumber,
				$batchNumber,
			),
		);
	}

	if (!is_array($tracepoints)) {
		throw new RuntimeException(
			sprintf(
				'OSRM returned no tracepoints for trip %d, batch %d.',
				$tripNumber,
				$batchNumber,
			),
		);
	}

	$distanceMeters = 0.0;
	$confidences = [];

	foreach ($matchings as $matching) {
		if (!is_array($matching)) {
			continue;
		}

		if (isset($matching['distance']) && is_numeric($matching['distance'])) {
			$distanceMeters += (float) $matching['distance'];
		}

		if (
			isset($matching['confidence'])
			&& is_numeric($matching['confidence'])
		) {
			$confidences[] = (float) $matching['confidence'];
		}
	}

	$matchedPointCount = 0;
	$unmatchedPointCount = 0;
	$ambiguousPointCount = 0;

	foreach ($tracepoints as $tracepoint) {
		if (!is_array($tracepoint)) {
			$unmatchedPointCount++;
			continue;
		}

		$matchedPointCount++;

		if (
			isset($tracepoint['alternatives_count'])
			&& (int) $tracepoint['alternatives_count'] > 0
		) {
			$ambiguousPointCount++;
		}
	}

	$minConfidence = count($confidences) > 0
		? min($confidences)
		: null;

	if ((bool) vehicleMileageConfig('OSRM_MATCH_DEBUG', false)) {
		printf(
			"Trip %d, batch %d: points=%d, matched=%d, unmatched=%d, ambiguous=%d, "
				. "matchings=%d, distance=%.3f km, min confidence=%s\n",
			$tripNumber,
			$batchNumber,
			$pointCount,
			$matchedPointCount,
			$unmatchedPointCount,
			$ambiguousPointCount,
			count($matchings),
			$distanceMeters / 1000.0,
			$minConfidence !== null
				? number_format($minConfidence, 3, '.', '')
				: 'n/a',
		);
	}

	return [
		'response' => $response,
		'distance_m' => $distanceMeters,
		'matching_count' => count($matchings),
		'matched_point_count' => $matchedPointCount,
		'unmatched_point_count' => $unmatchedPointCount,
		'ambiguous_point_count' => $ambiguousPointCount,
		'min_confidence' => $minConfidence,
	];
}

/**
 * Split the day into trips. A gap at or above the configured threshold is
 * treated as a stop, so no distance is counted across that gap.
 */
function vehicleMileageSplitTrips(
	array $points,
	int $stopGapSeconds,
): array {
	if ($stopGapSeconds < 1) {
		throw new RuntimeException(
			'OSRM_MATCH_STOP_GAP_SECONDS must be positive.',
		);
	}

	$trips = [];
	$currentTrip = [];

	foreach ($points as $point) {
		if ($currentTrip !== []) {
			$previousPoint = $currentTrip[count($currentTrip) - 1];
			$gapSeconds = (int) $point['timestamp']
				- (int) $previousPoint['timestamp'];

			if ($gapSeconds >= $stopGapSeconds) {
				if (count($currentTrip) >= 2) {
					$trips[] = $currentTrip;
				}

				$currentTrip = [];
			}
		}

		$currentTrip[] = $point;
	}

	if (count($currentTrip) >= 2) {
		$trips[] = $currentTrip;
	}

	return $trips;
}

function vehicleMileageEffectiveMaxUrlLength(): int
{
	$configuredMax = (int) vehicleMileageConfig(
		'OSRM_MATCH_MAX_URL_LENGTH',
		120000,
	);

	$serverHeaderMax = (int) vehicleMileageConfig(
		'OSRM_MATCH_SERVER_MAX_HEADER_SIZE',
		131072,
	);

	$safetyMargin = (int) vehicleMileageConfig(
		'OSRM_MATCH_HEADER_SAFETY_MARGIN',
		4096,
	);

	if ($configuredMax < 1000) {
		throw new RuntimeException(
			'OSRM_MATCH_MAX_URL_LENGTH is too small.',
		);
	}

	if ($serverHeaderMax <= $safetyMargin) {
		throw new RuntimeException(
			'OSRM header size must exceed the safety margin.',
		);
	}

	return min(
		$configuredMax,
		$serverHeaderMax - $safetyMargin,
	);
}

/**
 * Find the largest batch starting at $start that satisfies both the OSRM point
 * limit and the effective URL length limit.
 *
 * The return value is an exclusive array index.
 */
function vehicleMileageFindBatchEnd(
	array $trip,
	int $start,
	int $maxPoints,
	int $maxUrlLength,
): int {
	$tripPointCount = count($trip);
	$maximumEnd = min(
		$start + $maxPoints,
		$tripPointCount,
	);

	$minimumEnd = $start + 2;

	if ($minimumEnd > $tripPointCount) {
		return $tripPointCount;
	}

	$low = $minimumEnd;
	$high = $maximumEnd;
	$bestEnd = 0;

	while ($low <= $high) {
		$middle = intdiv($low + $high, 2);
		$batch = array_slice(
			$trip,
			$start,
			$middle - $start,
		);

		$url = vehicleMileageBuildOsrmUrl($batch);

		if (strlen($url) <= $maxUrlLength) {
			$bestEnd = $middle;
			$low = $middle + 1;
		} else {
			$high = $middle - 1;
		}
	}

	if ($bestEnd === 0) {
		throw new RuntimeException(
			sprintf(
				'Two OSRM points exceed the effective URL limit of %d bytes.',
				$maxUrlLength,
			),
		);
	}

	return $bestEnd;
}

/**
 * Create overlapping batches for an oversized trip.
 *
 * The overlap provides OSRM with road-direction context around batch
 * boundaries. Distances from overlapping portions are deduplicated later at
 * the original-segment level.
 */
function vehicleMileageCreateBatches(
	array $trip,
	int $maxPoints,
	int $maxUrlLength,
	int $overlapPoints,
): array {
	if ($maxPoints < 2) {
		throw new RuntimeException(
			'OSRM_MATCH_POINTS_PER_REQUEST must be at least 2.',
		);
	}

	if ($overlapPoints < 1) {
		throw new RuntimeException(
			'OSRM_MATCH_BATCH_OVERLAP_POINTS must be at least 1.',
		);
	}

	if ($overlapPoints >= $maxPoints) {
		throw new RuntimeException(
			'OSRM_MATCH_BATCH_OVERLAP_POINTS must be lower than the point limit.',
		);
	}

	$tripPointCount = count($trip);

	if ($tripPointCount < 2) {
		return [];
	}

	$batches = [];
	$start = 0;

	while ($start < $tripPointCount - 1) {
		$end = vehicleMileageFindBatchEnd(
			$trip,
			$start,
			$maxPoints,
			$maxUrlLength,
		);

		$batches[] = array_slice(
			$trip,
			$start,
			$end - $start,
		);

		if ($end >= $tripPointCount) {
			break;
		}

		$nextStart = max(
			$start + 1,
			$end - $overlapPoints,
		);

		if ($nextStart >= $end) {
			$nextStart = $end - 1;
		}

		$start = $nextStart;
	}

	return $batches;
}

function vehicleMileageRawDistanceMeters(
	array $from,
	array $to,
): float {
	$earthRadiusMeters = 6371008.8;

	$lat1 = deg2rad((float) $from['lat']);
	$lat2 = deg2rad((float) $to['lat']);
	$deltaLat = $lat2 - $lat1;
	$deltaLon = deg2rad(
		(float) $to['lon'] - (float) $from['lon'],
	);

	$sinLat = sin($deltaLat / 2.0);
	$sinLon = sin($deltaLon / 2.0);

	$a = $sinLat * $sinLat
		+ cos($lat1) * cos($lat2) * $sinLon * $sinLon;

	$a = min(1.0, max(0.0, $a));

	return 2.0
		* $earthRadiusMeters
		* asin(sqrt($a));
}

/**
 * Convert OSRM route legs into original GPS segment distances.
 *
 * Each OSRM leg is distributed across the original point-to-point segments
 * covered by that leg. Distribution is proportional to raw geodesic distance.
 * This lets overlapping batches provide context without double-counting their
 * shared portions.
 */
function vehicleMileageApplyOsrmResponse(
	array $response,
	array $batch,
	array $pointsByGlobalIndex,
	array &$segmentDistances,
): void {
	$tracepoints = $response['tracepoints'] ?? [];
	$matchings = $response['matchings'] ?? [];

	if (!is_array($tracepoints) || !is_array($matchings)) {
		return;
	}

	$waypointLocalIndexes = [];

	foreach ($tracepoints as $localIndex => $tracepoint) {
		if (
			!is_array($tracepoint)
			|| !isset($tracepoint['matchings_index'])
			|| !isset($tracepoint['waypoint_index'])
		) {
			continue;
		}

		$matchingIndex = (int) $tracepoint['matchings_index'];
		$waypointIndex = (int) $tracepoint['waypoint_index'];

		$waypointLocalIndexes[$matchingIndex][$waypointIndex] = (int) $localIndex;
	}

	foreach ($matchings as $matchingIndex => $matching) {
		if (!is_array($matching)) {
			continue;
		}

		$legs = $matching['legs'] ?? [];

		if (!is_array($legs)) {
			continue;
		}

		foreach ($legs as $legIndex => $leg) {
			if (
				!is_array($leg)
				|| !isset($leg['distance'])
				|| !is_numeric($leg['distance'])
				|| !isset(
					$waypointLocalIndexes[$matchingIndex][$legIndex],
					$waypointLocalIndexes[$matchingIndex][$legIndex + 1],
				)
			) {
				continue;
			}

			$startLocalIndex = $waypointLocalIndexes[$matchingIndex][$legIndex];
			$endLocalIndex = $waypointLocalIndexes[$matchingIndex][$legIndex + 1];

			if (
				!isset(
					$batch[$startLocalIndex],
					$batch[$endLocalIndex],
				)
			) {
				continue;
			}

			$startGlobalIndex = (int) $batch[$startLocalIndex]['global_index'];
			$endGlobalIndex = (int) $batch[$endLocalIndex]['global_index'];

			if ($endGlobalIndex <= $startGlobalIndex) {
				continue;
			}

			$legDistanceMeters = (float) $leg['distance'];
			$rawDistances = [];
			$totalRawDistance = 0.0;

			for (
				$segmentEndIndex = $startGlobalIndex + 1;
				$segmentEndIndex <= $endGlobalIndex;
				$segmentEndIndex++
			) {
				if (
					!isset(
						$pointsByGlobalIndex[$segmentEndIndex - 1],
						$pointsByGlobalIndex[$segmentEndIndex],
					)
				) {
					continue;
				}

				$rawDistance = vehicleMileageRawDistanceMeters(
					$pointsByGlobalIndex[$segmentEndIndex - 1],
					$pointsByGlobalIndex[$segmentEndIndex],
				);

				$rawDistances[$segmentEndIndex] = $rawDistance;
				$totalRawDistance += $rawDistance;
			}

			$segmentCount = count($rawDistances);

			if ($segmentCount === 0) {
				continue;
			}

			foreach ($rawDistances as $segmentEndIndex => $rawDistance) {
				if (array_key_exists($segmentEndIndex, $segmentDistances)) {
					continue;
				}

				$share = $totalRawDistance > 0
					? $rawDistance / $totalRawDistance
					: 1.0 / $segmentCount;

				$segmentDistances[$segmentEndIndex] = $legDistanceMeters
					* $share;
			}
		}
	}
}

/**
 * Calculate vehicle mileage using OSRM map matching.
 *
 * Values without an explicit timezone are interpreted as UTC.
 */
function vehicleMileageKmOsrm(
	string $carId,
	string $dateFrom,
	string $dateTo,
): float {
	global $dbLink;

	if (!isset($dbLink) || !is_object($dbLink)) {
		throw new RuntimeException(
			'The $dbLink variable was not exported by db_con.php.',
		);
	}

	$from = vehicleMileageParseUtcTimestamp($dateFrom);
	$to = vehicleMileageParseUtcTimestamp($dateTo);

	$points = vehicleMileageFetchPoints(
		$dbLink,
		$carId,
		$from,
		$to,
	);

	if (count($points) < 2) {
		return 0.0;
	}

	$stopGapSeconds = (int) vehicleMileageConfig(
		'OSRM_MATCH_STOP_GAP_SECONDS',
		600,
	);

	$configuredMaxPoints = (int) vehicleMileageConfig(
		'OSRM_MATCH_POINTS_PER_REQUEST',
		1000,
	);

	$serverMaxPoints = (int) vehicleMileageConfig(
		'OSRM_MATCH_SERVER_MAX_POINTS',
		1000,
	);

	$maxPoints = min(
		$configuredMaxPoints,
		$serverMaxPoints,
	);

	$maxUrlLength = vehicleMileageEffectiveMaxUrlLength();

	$overlapPoints = (int) vehicleMileageConfig(
		'OSRM_MATCH_BATCH_OVERLAP_POINTS',
		20,
	);

	$fallbackToRaw = (bool) vehicleMileageConfig(
		'OSRM_MATCH_FALLBACK_TO_RAW',
		true,
	);

	$debug = (bool) vehicleMileageConfig(
		'OSRM_MATCH_DEBUG',
		false,
	);

	$trips = vehicleMileageSplitTrips(
		$points,
		$stopGapSeconds,
	);

	$pointsByGlobalIndex = [];

	foreach ($points as $point) {
		$pointsByGlobalIndex[(int) $point['global_index']] = $point;
	}

	$segmentDistances = [];
	$tripNumber = 0;
	$requestCount = 0;

	foreach ($trips as $trip) {
		$tripNumber++;

		$batches = vehicleMileageCreateBatches(
			$trip,
			$maxPoints,
			$maxUrlLength,
			$overlapPoints,
		);

		if ($debug) {
			$firstPoint = $trip[0];
			$lastPoint = $trip[count($trip) - 1];

			printf(
				"Trip %d: points=%d, batches=%d, from=%s, to=%s\n",
				$tripNumber,
				count($trip),
				count($batches),
				(string) $firstPoint['period'],
				(string) $lastPoint['period'],
			);
		}

		$batchNumber = 0;

		foreach ($batches as $batch) {
			$batchNumber++;
			$requestCount++;

			$url = vehicleMileageBuildOsrmUrl($batch);

			try {
				$result = vehicleMileageCallOsrm(
					$url,
					$tripNumber,
					$batchNumber,
					count($batch),
				);

				vehicleMileageApplyOsrmResponse(
					$result['response'],
					$batch,
					$pointsByGlobalIndex,
					$segmentDistances,
				);
			} catch (Throwable $e) {
				if (!$fallbackToRaw) {
					throw $e;
				}

				if ($debug) {
					printf(
						"Trip %d, batch %d: OSRM failed, raw fallback will be used: %s\n",
						$tripNumber,
						$batchNumber,
						$e->getMessage(),
					);
				}
			}
		}
	}

	$osrmSegmentCount = count($segmentDistances);
	$fallbackSegmentCount = 0;
	$fallbackDistanceMeters = 0.0;

	/*
	 * Fill every segment that OSRM did not cover with direct geodesic distance,
	 * but never bridge a configured stop gap.
	 */
	foreach ($trips as $trip) {
		for ($index = 1; $index < count($trip); $index++) {
			$previousPoint = $trip[$index - 1];
			$currentPoint = $trip[$index];
			$segmentEndIndex = (int) $currentPoint['global_index'];

			if (array_key_exists($segmentEndIndex, $segmentDistances)) {
				continue;
			}

			$rawDistance = vehicleMileageRawDistanceMeters(
				$previousPoint,
				$currentPoint,
			);

			$segmentDistances[$segmentEndIndex] = $rawDistance;
			$fallbackSegmentCount++;
			$fallbackDistanceMeters += $rawDistance;
		}
	}

	$totalDistanceMeters = array_sum($segmentDistances);

	if ($debug) {
		printf(
			"Summary: points=%d, trips=%d, requests=%d, "
				. "OSRM segments=%d, fallback segments=%d, "
				. "fallback distance=%.3f km, total=%.3f km\n",
			count($points),
			count($trips),
			$requestCount,
			$osrmSegmentCount,
			$fallbackSegmentCount,
			$fallbackDistanceMeters / 1000.0,
			$totalDistanceMeters / 1000.0,
		);
	}

	return $totalDistanceMeters / 1000.0;
}
