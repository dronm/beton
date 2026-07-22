<?php

require_once("vehicle_mileage_osrm.php");

/**
 * Editable manual test.
 */
function testVehicleMileageKmOsrm(): void
{
	/*
	 * Set your test parameters here.
	 *
	 * These timestamps are interpreted as UTC because they do not include
	 * a timezone suffix.
	 */
	$carId = '862531042204801';
	$dateFrom = '2026-07-20T01:00:00';
	$dateTo = '2026-07-21T01:00:00';

	try {
		$mileageKm = vehicleMileageKmOsrm(
			$carId,
			$dateFrom,
			$dateTo,
		);

		printf(
			"Vehicle: %s\nPeriod: %s — %s UTC\nOSRM mileage: %.3f km\n",
			$carId,
			$dateFrom,
			$dateTo,
			$mileageKm,
		);
	} catch (Throwable $e) {
		fwrite(
			STDERR,
			sprintf(
				"OSRM mileage test failed: %s\n",
				$e->getMessage(),
			),
		);

		exit(1);
	}
}

/*
 * Run the test only when this file is executed directly from the command line.
 * Including the file from another script will not run the test.
 */
if (
	PHP_SAPI === 'cli'
	&& isset($_SERVER['SCRIPT_FILENAME'])
	&& realpath($_SERVER['SCRIPT_FILENAME']) === __FILE__
) {
	testVehicleMileageKmOsrm();
}
