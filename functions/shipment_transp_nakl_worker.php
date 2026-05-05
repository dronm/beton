<?php

require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'Shipment_Controller.php');

if ($argc < 2) {
	error_log("params file is required");
	exit(1);
}

$paramsFile = $argv[1];

if (!file_exists($paramsFile)) {
	error_log("params file not found");
	exit(1);
}

$params = json_decode(file_get_contents($paramsFile), true);

if (!is_array($params)) {
	error_log("invalid params json");
	exit(1);
}

try {
	$controller = new Shipment_Controller($dbLink);
	$controller->shipment_transp_nakl_on_list_async_worker($params);

	unlink($paramsFile);

	exit(0);
} catch (Throwable $e) {
	$errText = $e->getMessage();
	$dbLink->query(
		"UPDATE user_operations 
		SET 
			error_text = $2,
			status = 'error',
			date_time_end = now()
		WHERE operation_id = $1",
		[ $params["operation_id"], $errText ]
	);
	unlink($paramsFile);
	error_log($errText);
	exit(1);
}
