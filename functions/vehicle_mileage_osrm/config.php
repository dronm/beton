<?php
define('VEHICLE_MILEAGES_CRON_MAX_DAYS_PER_VEHICLE', 10);

/*
 * Keep this at or below osrm-routed --max-matching-size.
 * The standard OSRM server default is 100.
 */
define('OSRM_MATCH_POINTS_PER_REQUEST', 2000);
define('OSRM_MATCH_SERVER_MAX_POINTS', 2000);

/*
 * Prevent oversized HTTP GET requests.
 */
define('OSRM_MATCH_MAX_URL_LENGTH', 250000);
define('OSRM_MATCH_SERVER_MAX_HEADER_SIZE', 262144);
define('OSRM_MATCH_HEADER_SAFETY_MARGIN', 4096);
define('OSRM_MATCH_CONNECT_TIMEOUT_SECONDS', 5);
define('OSRM_MATCH_TIMEOUT_SECONDS', 60);

define('OSRM_MATCH_STOP_GAP_SECONDS', 600);
define('OSRM_MATCH_BATCH_OVERLAP_POINTS', 20);
/*
 * The radius calculation is:
 *
 * radius = hdop * OSRM_MATCH_HDOP_RADIUS_MULTIPLIER
 *
 * HDOP is not itself a distance in metres, so calibrate this multiplier using
 * known odometer journeys.
 */
define('OSRM_MATCH_HDOP_RADIUS_MULTIPLIER', 5.0);
define('OSRM_MATCH_DEFAULT_RADIUS_METERS', 15.0);
define('OSRM_MATCH_MIN_RADIUS_METERS', 5.0);
define('OSRM_MATCH_MAX_RADIUS_METERS', 50.0);
define('OSRM_MATCH_LOW_SATELLITE_MULTIPLIER', 1.5);

define('OSRM_MATCH_TIDY', false);
define('OSRM_MATCH_FALLBACK_TO_RAW', true);
/*
 * Print information about every OSRM request during testing.
 */
define('OSRM_MATCH_DEBUG', true);

