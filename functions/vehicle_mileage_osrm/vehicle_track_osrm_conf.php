<?php

/*
 * Must not exceed the --max-matching-size value used by osrm-routed.
 */
define('OSRM_TRACK_MAX_POINTS_PER_REQUEST', 2000);

/*
 * Start a separate map-matching trip after a GPS time gap.
 * Set to 0 to disable time-gap splitting.
 */
define('OSRM_TRACK_SPLIT_GAP_SECONDS', 600);

/*
 * Search radius around every GPS point.
 */
define('OSRM_TRACK_RADIUS_METERS', 30);

/*
 * Keep original coordinates when OSRM fails.
 */
define('OSRM_TRACK_FALLBACK_TO_RAW', true);

define('OSRM_TRACK_CONNECT_TIMEOUT_SECONDS', 5);
define('OSRM_TRACK_TIMEOUT_SECONDS', 60);

/*
 * Optional: reject OSRM matches farther than this from the GPS point.
 */
// define('OSRM_TRACK_MAX_SNAP_DISTANCE_METERS', 100);

/*
 * Optional debugging fields inside each pos_data point.
 */
// define('OSRM_TRACK_KEEP_RAW_COORDINATES', true);
// define('OSRM_TRACK_ADD_MATCH_INFO', true);

