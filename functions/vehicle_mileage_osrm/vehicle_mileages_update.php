<?php

declare(strict_types=1);

require_once(__DIR__.'/vehicle_mileage_osrm.php');

const VEHICLE_MILEAGES_CRON_LOCK_NAME = 'vehicle_mileages_update_osrm';

/**
 * Write a timestamped cron message to STDOUT or STDERR.
 */
function vehicleMileagesCronLog(string $message, bool $error = false): void
{
	$stream = $error ? STDERR : STDOUT;

	fwrite(
		$stream,
		sprintf(
			"[%s] %s\n",
			(new DateTimeImmutable('now'))->format(DateTimeInterface::ATOM),
			$message,
		),
	);
}

/**
 * Convert common PostgreSQL boolean result formats to bool.
 */
function vehicleMileagesCronPgBool(mixed $value): bool
{
	return in_array(
		$value,
		[true, 1, '1', 't', 'true', 'TRUE'],
		true,
	);
}

/**
 * Parse a PostgreSQL timestamptz value while preserving its UTC offset.
 */
function vehicleMileagesCronParseTimestamp(string $value): DateTimeImmutable
{
	$value = trim($value);

	if ($value === '') {
		throw new InvalidArgumentException('Database timestamp cannot be empty.');
	}

	try {
		return new DateTimeImmutable($value);
	} catch (Exception $e) {
		throw new InvalidArgumentException(
			sprintf('Invalid database timestamp "%s".', $value),
			0,
			$e,
		);
	}
}

/**
 * Acquire a PostgreSQL advisory lock so two cron processes cannot update the
 * same mileage sequence concurrently, including when cron runs on two hosts.
 */
function vehicleMileagesCronAcquireLock(object $dbLink): bool
{
	$sql = sprintf(
		'SELECT pg_try_advisory_lock(hashtext(%s)) AS locked',
		vehicleMileagePgLiteral(VEHICLE_MILEAGES_CRON_LOCK_NAME),
	);

	$row = vehicleMileageQueryFirst($dbLink, $sql);

	return vehicleMileagesCronPgBool($row['locked'] ?? false);
}

/**
 * Release the PostgreSQL advisory lock acquired by this session.
 */
function vehicleMileagesCronReleaseLock(object $dbLink): void
{
	$sql = sprintf(
		'SELECT pg_advisory_unlock(hashtext(%s)) AS unlocked',
		vehicleMileagePgLiteral(VEHICLE_MILEAGES_CRON_LOCK_NAME),
	);

	$dbLink->query($sql);
}

/**
 * Read the regulation user and database clock used for this run.
 *
 * Reading now() from PostgreSQL keeps the PHP implementation aligned with the
 * former PL/pgSQL function and avoids differences between server clocks.
 *
 * @return array{user_id: int, run_until: DateTimeImmutable}
 */
function vehicleMileagesCronContext(object $dbLink): array
{
	$row = vehicleMileageQueryFirst(
		$dbLink,
		<<<'SQL'
			SELECT
				(
					const_reglament_user_val()
						-> 'keys'
						->> 'id'
				)::int AS user_id,
				now()::text AS run_until
			SQL,
	);

	if (!isset($row['user_id'])) {
		throw new RuntimeException(
			'const_reglament_user_val() did not return a user ID.',
		);
	}

	if (!isset($row['run_until'])) {
		throw new RuntimeException('PostgreSQL did not return the current time.');
	}

	return [
		'user_id' => (int) $row['user_id'],
		'run_until' => vehicleMileagesCronParseTimestamp(
			(string) $row['run_until'],
		),
	];
}

/**
 * Select the latest cumulative mileage record for every vehicle that has a
 * configured tracker.
 */
function vehicleMileagesCronVehicles(object $dbLink): array
{
	return vehicleMileageQueryRows(
		$dbLink,
		<<<'SQL'
			SELECT DISTINCT ON (vm.vehicle_id)
				vm.vehicle_id,
				vm.for_date::text AS for_date,
				COALESCE(vm.mileage, 0) AS mileage,
				BTRIM(veh.tracker_id) AS tracker_id
			FROM public.vehicle_mileages AS vm
			INNER JOIN public.vehicles AS veh
				ON veh.id = vm.vehicle_id
			WHERE
				veh.tracker_id IS NOT NULL
				AND BTRIM(veh.tracker_id) <> ''
			ORDER BY
				vm.vehicle_id,
				vm.for_date DESC
			SQL,
	);
}

/**
 * Insert one new cumulative mileage record.
 */
function vehicleMileagesCronInsert(
	object $dbLink,
	int $vehicleId,
	DateTimeImmutable $forDate,
	int $userId,
	int $mileage,
): void {
	$forDateSql = vehicleMileagePgLiteral(
		$forDate->format('Y-m-d H:i:s.uP'),
	);

	$sql = sprintf(
		<<<'SQL'
			INSERT INTO public.vehicle_mileages (
				vehicle_id,
				for_date,
				user_id,
				mileage,
				timing
			)
			VALUES (
				%d,
				%s::timestamptz,
				%d,
				%d,
				vehicle_timing(
					%d,
					get_shift_start(
						(%s::timestamptz)::timestamp without time zone
					),
					%s::timestamptz
				)
			)
			SQL,
		$vehicleId,
		$forDateSql,
		$userId,
		$mileage,
		$vehicleId,
		$forDateSql,
		$forDateSql,
	);

	$dbLink->query($sql);
}

/**
 * Recalculate all missing complete daily periods and append cumulative mileage
 * rows to vehicle_mileages.
 *
 * Each period is half-open: [start_time, end_time). Therefore no second is
 * subtracted from end_time when calling vehicleMileageKmOsrm().
 *
 * @return int Number of inserted vehicle_mileages records.
 */
function vehicleMileagesUpdateOsrm(): int
{
	global $dbLink;

	if (!isset($dbLink) || !is_object($dbLink)) {
		throw new RuntimeException(
			'The $dbLink variable was not exported by db_con.php.',
		);
	}

	if (!method_exists($dbLink, 'query')) {
		throw new RuntimeException(
			'The database wrapper must provide query(string $sql).',
		);
	}

	if (!vehicleMileagesCronAcquireLock($dbLink)) {
		vehicleMileagesCronLog(
			'Another vehicle mileage update process is already running; exiting.',
		);

		return 0;
	}

	$insertedCount = 0;
	$failedVehicleCount = 0;

	try {
		$context = vehicleMileagesCronContext($dbLink);
		$userId = $context['user_id'];
		$runUntil = $context['run_until'];
		$vehicles = vehicleMileagesCronVehicles($dbLink);

		$maxDaysPerVehicle = max(
			0,
			(int) vehicleMileageConfig(
				'VEHICLE_MILEAGES_CRON_MAX_DAYS_PER_VEHICLE',
				0,
			),
		);

		vehicleMileagesCronLog(
			sprintf(
				'Starting mileage update: vehicles=%d, run_until=%s, user_id=%d.',
				count($vehicles),
				$runUntil->format(DateTimeInterface::ATOM),
				$userId,
			),
		);

		foreach ($vehicles as $vehicle) {
			$vehicleId = (int) ($vehicle['vehicle_id'] ?? 0);
			$trackerId = trim((string) ($vehicle['tracker_id'] ?? ''));
			$currentMileage = (int) ($vehicle['mileage'] ?? 0);
			$forDateValue = (string) ($vehicle['for_date'] ?? '');

			if ($vehicleId <= 0 || $trackerId === '' || $forDateValue === '') {
				$failedVehicleCount++;

				vehicleMileagesCronLog(
					sprintf(
						'Skipping invalid vehicle row: vehicle_id=%d, tracker_id="%s", for_date="%s".',
						$vehicleId,
						$trackerId,
						$forDateValue,
					),
					true,
				);

				continue;
			}

			try {
				$startTime = vehicleMileagesCronParseTimestamp($forDateValue);
				$processedDays = 0;

				while (true) {
					$endTime = $startTime->add(new DateInterval('P1D'));

					if ($endTime > $runUntil) {
						break;
					}

					if (
						$maxDaysPerVehicle > 0
						&& $processedDays >= $maxDaysPerVehicle
					) {
						vehicleMileagesCronLog(
							sprintf(
								'Vehicle %d reached the configured limit of %d day(s) per run.',
								$vehicleId,
								$maxDaysPerVehicle,
							),
						);

						break;
					}

					vehicleMileagesCronLog(
						sprintf(
							'Calculating vehicle=%d, tracker=%s, period=[%s, %s).',
							$vehicleId,
							$trackerId,
							$startTime->format(DateTimeInterface::ATOM),
							$endTime->format(DateTimeInterface::ATOM),
						),
					);

					$distanceKm = vehicleMileageKmOsrm(
						$trackerId,
						$startTime->format('Y-m-d H:i:s.uP'),
						$endTime->format('Y-m-d H:i:s.uP'),
					);

					if (!is_finite($distanceKm) || $distanceKm < 0) {
						throw new RuntimeException(
							sprintf(
								'Invalid OSRM distance %.6f km for vehicle %d.',
								$distanceKm,
								$vehicleId,
							),
						);
					}

					$dailyMileage = (int) round(
						$distanceKm,
						0,
						PHP_ROUND_HALF_UP,
					);

					$newMileage = $currentMileage + $dailyMileage;

					vehicleMileagesCronInsert(
						$dbLink,
						$vehicleId,
						$endTime,
						$userId,
						$newMileage,
					);

					$insertedCount++;
					$processedDays++;
					$currentMileage = $newMileage;
					$startTime = $endTime;

					vehicleMileagesCronLog(
						sprintf(
							'Inserted vehicle=%d, for_date=%s, daily=%.3f km, rounded=%d km, cumulative=%d km.',
							$vehicleId,
							$endTime->format(DateTimeInterface::ATOM),
							$distanceKm,
							$dailyMileage,
							$newMileage,
						),
					);
				}
			} catch (Throwable $e) {
				$failedVehicleCount++;

				vehicleMileagesCronLog(
					sprintf(
						'Vehicle %d (%s) failed at period start %s: %s',
						$vehicleId,
						$trackerId,
						isset($startTime)
							? $startTime->format(DateTimeInterface::ATOM)
							: $forDateValue,
						$e->getMessage(),
					),
					true,
				);
			}
		}

		vehicleMileagesCronLog(
			sprintf(
				'Mileage update finished: inserted=%d, failed_vehicles=%d.',
				$insertedCount,
				$failedVehicleCount,
			),
		);

		if ($failedVehicleCount > 0) {
			throw new RuntimeException(
				sprintf(
					'Mileage update completed with %d failed vehicle(s).',
					$failedVehicleCount,
				),
			);
		}

		return $insertedCount;
	} finally {
		vehicleMileagesCronReleaseLock($dbLink);
	}
}

/**
 * CLI entry point.
 */
function vehicleMileagesCronMain(): int
{
	if (PHP_SAPI !== 'cli') {
		fwrite(STDERR, "This script can only be run from the command line.\n");

		return 1;
	}

	try {
		vehicleMileagesUpdateOsrm();

		return 0;
	} catch (Throwable $e) {
		vehicleMileagesCronLog(
			sprintf('Fatal mileage update error: %s', $e->getMessage()),
			true,
		);

		return 1;
	}
}

exit(vehicleMileagesCronMain());
