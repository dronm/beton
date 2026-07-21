<?php

declare(strict_types=1);

return array(
	'postgres' => array(
		'dsn' => 'pgsql:host=192.168.1.177;port=6432;dbname=beton',
		'user' => 'beton',
		'password' => '159753',
	),

	'signal_file' => '/tmp/elkon_upload.syg',
	'stale_after_seconds' => 300,
	'warn_script' => '/home/andrey/failover/notify.sh',
	'default_operator_user_id' => 1,
	'batch_size' => 10,
	'sleep_microseconds' => 100000,
);
