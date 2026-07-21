<?php

require_once('db_con.php');

if (!defined('SESSION_REDIS_DSN')) {
	throw new RuntimeException('SESSION_REDIS_DSN is not defined.');
}

if (!defined('SESSION_REDIS_NAMESPACE')) {
	throw new RuntimeException('SESSION_REDIS_NAMESPACE is not defined.');
}

if (!class_exists('Redis')) {
	throw new RuntimeException('The PHP Redis extension is not installed.');
}

function connectRedis($dsn) {
	$config = parse_url($dsn);

	if (
		$config === FALSE
		|| !isset($config['scheme'])
		|| !isset($config['host'])
	) {
		throw new RuntimeException('Invalid Redis DSN.');
	}

	$scheme = strtolower($config['scheme']);

	if ($scheme !== 'redis' && $scheme !== 'rediss') {
		throw new RuntimeException(
			'Redis DSN must use redis:// or rediss://.'
		);
	}

	$host = $config['host'];

	if ($scheme === 'rediss') {
		$host = 'tls://' . $host;
	}

	$port = isset($config['port'])
		? intval($config['port'])
		: 6379;

	$database = isset($config['path'])
		? intval(ltrim($config['path'], '/'))
		: 0;

	$username = isset($config['user'])
		? rawurldecode($config['user'])
		: NULL;

	$password = isset($config['pass'])
		? rawurldecode($config['pass'])
		: NULL;

	$redis = new Redis();

	if (!$redis->connect($host, $port, 5.0)) {
		throw new RuntimeException('Could not connect to Redis.');
	}

	if ($username !== NULL && $username !== '') {
		$result = $redis->rawCommand(
			'AUTH',
			$username,
			$password !== NULL ? $password : ''
		);

		if ($result !== TRUE && $result !== 'OK') {
			throw new RuntimeException(
				'Redis ACL authentication failed.'
			);
		}
	}
	else if ($password !== NULL && $password !== '') {
		if (!$redis->auth($password)) {
			throw new RuntimeException(
				'Redis authentication failed.'
			);
		}
	}

	if (!$redis->select($database)) {
		throw new RuntimeException(
			'Could not select Redis database ' . $database . '.'
		);
	}

	return $redis;
}

function quoteSessionIds($sessionIds) {
	$result = array();

	foreach ($sessionIds as $sessionId) {
		$result[] = "'" . str_replace(
			"'",
			"''",
			$sessionId
		) . "'";
	}

	return implode(',', $result);
}

function deleteRedisKeys($redis, $keys) {
	if (count($keys) === 0) {
		return;
	}

	if (method_exists($redis, 'unlink')) {
		call_user_func_array(
			array($redis, 'unlink'),
			$keys
		);

		return;
	}

	call_user_func_array(
		array($redis, 'del'),
		$keys
	);
}

$redis = connectRedis(SESSION_REDIS_DSN);

$namespace = rtrim(
	trim(SESSION_REDIS_NAMESPACE),
	':'
) . ':';

$expiresKey = $namespace . 'expires';
$batchSize = 500;
$totalDeleted = 0;

while (TRUE) {
	/*
	 * SessManager.php registers every active session ID in this
	 * sorted set.
	 */
	$sessionIds = $redis->zRange(
		$expiresKey,
		0,
		$batchSize - 1
	);

	if (!is_array($sessionIds) || count($sessionIds) === 0) {
		break;
	}

	/*
	 * Preserve the behavior previously implemented by the
	 * sessions table and its delete trigger.
	 */
	$dbLink->query(
		"UPDATE logins
		SET date_time_out = now()
		WHERE date_time_out IS NULL
			AND trim(session_id) IN ("
			. quoteSessionIds($sessionIds)
			. ")"
	);

	$sessionKeys = array();

	foreach ($sessionIds as $sessionId) {
		$sessionKeys[] = $namespace
			. 'session:'
			. $sessionId;
	}

	deleteRedisKeys($redis, $sessionKeys);

	call_user_func_array(
		array($redis, 'zRem'),
		array_merge(
			array($expiresKey),
			$sessionIds
		)
	);

	$totalDeleted += count($sessionIds);
}

/*
 * Usually the sorted set has already been removed after its last
 * member was removed. This makes the cleanup explicit.
 */
$redis->del($expiresKey);

$redis->close();

printf(
	"Closed and deleted %d Redis sessions.\n",
	$totalDeleted
);
