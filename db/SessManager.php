<?php
/**
 * Redis-backed PHP session handler.
 *
 * Required Config.php constants:
 *
 * define('SESSION_REDIS_DSN', 'redis://eurobeton:PWD@192.168.1.177:5015/0');
 * define('SESSION_REDIS_NAMESPACE', 'eurobeton');
 *
 * Optional constants:
 *
 * define('SESSION_REDIS_CONNECT_TIMEOUT', 2.5);
 * define('SESSION_REDIS_READ_TIMEOUT', 2.5);
 * define('SESSION_REDIS_LOCK_WAIT_MS', 10000);
 * define('SESSION_REDIS_LOCK_TTL_MS', 60000);
 * define('SESSION_REDIS_GC_BATCH_SIZE', 500);
 */
define('DEFAULT_REDIS_SESSION_LIFE_TIME', 180*60);

class SessManager {
	private $dbLink;
	private $dbLinkMaster;
	private $encrPassword = '';
	private $redis;
	private $redisDsn;
	private $namespace = '';
	private $lifetime = DEFAULT_REDIS_SESSION_LIFE_TIME;
	private $lockToken;
	private $lockedSessionId;

	function __construct() {
		session_set_save_handler(
			array($this, 'open'),
			array($this, 'close'),
			array($this, 'read'),
			array($this, 'write'),
			array($this, 'destroy'),
			array($this, 'gc')
		);

		register_shutdown_function('session_write_close');
	}

	function start($session_name, $dbLinkMaster, $dbLink, $secure = FALSE, $durationSec = 0, $encrPassword = '') {
		$this->dbLinkMaster = $dbLinkMaster;
		$this->dbLink = $dbLink;
		$this->encrPassword = (string)$encrPassword;
		$this->redisDsn = $this->getRedisDsn();
		$this->namespace = $this->normalizeNamespace(
			defined('SESSION_REDIS_NAMESPACE') ? SESSION_REDIS_NAMESPACE : ''
		);

		$this->lifetime = $durationSec
			? intval($durationSec)
			: intval(ini_get('session.gc_maxlifetime'));
		if ($this->lifetime <= 0) {
			$this->lifetime = DEFAULT_REDIS_SESSION_LIFE_TIME;
		}

		$httponly = TRUE;

		if (PHP_VERSION_ID < 70100) {
			if (in_array('sha512', hash_algos())) {
				ini_set('session.hash_function', 'sha512');
			}
			ini_set('session.hash_bits_per_character', 5);
		}
		else {
			// Keep the legacy 128-character session ID format.
			ini_set('session.sid_length', 128);
			ini_set('session.sid_bits_per_character', 5);
		}

		ini_set('session.use_only_cookies', 1);
		ini_set('session.gc_maxlifetime', $this->lifetime);

		$cookieParams = session_get_cookie_params();
		session_set_cookie_params(
			$cookieParams['lifetime'],
			$cookieParams['path'],
			$cookieParams['domain'],
			$secure,
			$httponly
		);

		session_name($session_name);
		if (!session_start()) {
			throw new RuntimeException('Could not start PHP session.');
		}
	}

	function open($savePath = '', $sessionName = '') {
		if ($this->redis instanceof Redis) {
			return TRUE;
		}

		if (!class_exists('Redis')) {
			throw new RuntimeException(
				'PHP Redis extension is not installed. Install/enable the phpredis extension.'
			);
		}

		$config = $this->parseRedisDsn($this->redisDsn);
		$redis = new Redis();
		$connectTimeout = defined('SESSION_REDIS_CONNECT_TIMEOUT')
			? floatval(SESSION_REDIS_CONNECT_TIMEOUT)
			: 2.5;

		$host = $config['host'];
		if ($config['scheme'] === 'rediss') {
			$host = 'tls://' . $host;
		}

		if (!$redis->connect($host, $config['port'], $connectTimeout)) {
			throw new RuntimeException('Could not connect to Redis session storage.');
		}

		if ($config['username'] !== NULL && $config['username'] !== '') {
			$authResult = $redis->rawCommand(
				'AUTH',
				$config['username'],
				$config['password']
			);
			if ($authResult !== TRUE && $authResult !== 'OK') {
				throw new RuntimeException('Redis ACL authentication failed.');
			}
		}
		else if ($config['password'] !== NULL && $config['password'] !== '') {
			if (!$redis->auth($config['password'])) {
				throw new RuntimeException('Redis authentication failed.');
			}
		}

		if ($config['database'] > 0 && !$redis->select($config['database'])) {
			throw new RuntimeException('Could not select Redis database.');
		}

		$readTimeout = defined('SESSION_REDIS_READ_TIMEOUT')
			? floatval(SESSION_REDIS_READ_TIMEOUT)
			: 2.5;
		if (defined('Redis::OPT_READ_TIMEOUT')) {
			$redis->setOption(Redis::OPT_READ_TIMEOUT, $readTimeout);
		}

		$this->redis = $redis;
		return TRUE;
	}

	function close() {
		$this->releaseLock();
		$this->redis = NULL;
		return TRUE;
	}

	function read($id) {
		$this->ensureRedisConnection();
		$this->acquireLock($id);

		$data = $this->redis->get($this->sessionKey($id));
		if ($data === FALSE) {
			return '';
		}

		return $this->decodeData($data);
	}

	function write($id, $data) {
		$this->ensureRedisConnection();

		// write() can theoretically be called without read() by PHP internals.
		if ($this->lockedSessionId !== $id) {
			$this->acquireLock($id);
		}

		$encodedData = $this->encodeData($data);
		$written = $this->redis->setEx(
			$this->sessionKey($id),
			$this->lifetime,
			$encodedData
		);

		if ($written) {
			$this->redis->zAdd(
				$this->expiryIndexKey(),
				time() + $this->lifetime,
				$id
			);
		}

		$this->releaseLock();
		return (bool)$written;
	}

	function destroy($id) {
		$this->ensureRedisConnection();

		$this->redis->del($this->sessionKey($id));
		$this->redis->zRem($this->expiryIndexKey(), $id);
		$this->markLoginsClosed(array($id));
		$this->releaseLock();

		return TRUE;
	}

	function gc($lifetime) {
		$this->ensureRedisConnection();

		$batchSize = defined('SESSION_REDIS_GC_BATCH_SIZE')
			? max(1, intval(SESSION_REDIS_GC_BATCH_SIZE))
			: 500;
		$expiredIds = $this->redis->zRangeByScore(
			$this->expiryIndexKey(),
			'-inf',
			time(),
			array('limit' => array(0, $batchSize))
		);

		if (!is_array($expiredIds) || count($expiredIds) === 0) {
			return TRUE;
		}

		foreach ($expiredIds as $id) {
			$this->redis->del($this->sessionKey($id));
		}
		call_user_func_array(
			array($this->redis, 'zRem'),
			array_merge(array($this->expiryIndexKey()), $expiredIds)
		);

		// PostgreSQL's old sessions DELETE trigger could close login rows.
		// Preserve that important side effect while payloads live in Redis.
		$this->markLoginsClosed($expiredIds);

		return TRUE;
	}

	function restart() {
		session_unset();
		session_destroy();
		session_start();
	}

	function findSession($token, &$dbLink, &$sessInf) {
		$res = FALSE;
		$access_p = strpos($token, ':');
		if ($access_p !== FALSE) {
			$access_salt = substr($token, 0, $access_p);
			$access_hash = substr($token, $access_p + 1);

			$access_salt_db = NULL;
			$f = new FieldExtString('salt');
			FieldSQLString::formatForDb($dbLink, $f->validate($access_salt), $access_salt_db);

			$sess_exp_col = (defined('SESSION_EXP_SEC') ? intval(SESSION_EXP_SEC) : 0)
				? sprintf('(EXTRACT(EPOCH FROM now()::timestamp-l.set_date_time)>=%d)', SESSION_EXP_SEC)
				: 'FALSE';
			$sess_live_col = (defined('SESSION_LIVE_SEC') ? intval(SESSION_LIVE_SEC) : 0)
				? sprintf('(EXTRACT(EPOCH FROM now()::timestamp-l.date_time_in)>=%d)', SESSION_LIVE_SEC)
				: 'FALSE';
			$session_ar = $dbLink->query_first(
				sprintf(
					"SELECT
						trim(l.session_id) AS session_id,
						%s AS expired,
						%s AS died
					FROM logins l
					WHERE l.date_time_out IS NULL AND l.pub_key=%s",
					$sess_exp_col,
					$sess_live_col,
					$access_salt_db
				)
			);

			if (
				is_array($session_ar)
				&& isset($session_ar['session_id'])
				&& $access_hash == md5($access_salt . $session_ar['session_id'])
			) {
				$res = TRUE;
				$sessInf = array(
					'session_id' => $session_ar['session_id'],
					'expired' => $session_ar['expired'],
					'died' => $session_ar['died'],
					'pub_key' => $access_salt
				);
				@session_id($session_ar['session_id']);
			}
		}
		return $res;
	}

	private function getRedisDsn() {
		$constantNames = array(
			'SESSION_REDIS_DSN',
			'SESSION_REDIS_URL',
			'REDIS_SESSION_DSN',
			'REDIS_DSN',
			'REDIS_CONN'
		);

		foreach ($constantNames as $constantName) {
			if (defined($constantName) && strlen(constant($constantName))) {
				return constant($constantName);
			}
		}

		throw new RuntimeException(
			'SESSION_REDIS_DSN is not defined in Config.php.'
		);
	}

	private function parseRedisDsn($dsn) {
		$parts = parse_url($dsn);
		if ($parts === FALSE || !isset($parts['scheme']) || !isset($parts['host'])) {
			throw new InvalidArgumentException('Invalid Redis DSN.');
		}

		$scheme = strtolower($parts['scheme']);
		if ($scheme !== 'redis' && $scheme !== 'rediss') {
			throw new InvalidArgumentException('Redis DSN scheme must be redis:// or rediss://.');
		}

		$database = 0;
		if (isset($parts['path']) && $parts['path'] !== '' && $parts['path'] !== '/') {
			$databaseText = ltrim($parts['path'], '/');
			if (!ctype_digit($databaseText)) {
				throw new InvalidArgumentException('Redis DSN database must be a non-negative integer.');
			}
			$database = intval($databaseText);
		}

		return array(
			'scheme' => $scheme,
			'host' => $parts['host'],
			'port' => isset($parts['port']) ? intval($parts['port']) : 6379,
			'username' => isset($parts['user']) ? rawurldecode($parts['user']) : NULL,
			'password' => isset($parts['pass']) ? rawurldecode($parts['pass']) : NULL,
			'database' => $database
		);
	}

	private function normalizeNamespace($namespace) {
		$namespace = trim((string)$namespace);
		if ($namespace === '') {
			throw new RuntimeException('SESSION_REDIS_NAMESPACE must not be empty.');
		}

		return rtrim($namespace, ':') . ':';
	}

	private function ensureRedisConnection() {
		if (!($this->redis instanceof Redis)) {
			$this->open();
		}
	}

	private function sessionKey($id) {
		return $this->namespace . 'session:' . $id;
	}

	private function lockKey($id) {
		return $this->namespace . 'lock:' . $id;
	}

	private function expiryIndexKey() {
		return $this->namespace . 'expires';
	}

	private function acquireLock($id) {
		if ($this->lockedSessionId === $id && $this->lockToken !== NULL) {
			return;
		}

		$this->releaseLock();

		$waitMs = defined('SESSION_REDIS_LOCK_WAIT_MS')
			? max(0, intval(SESSION_REDIS_LOCK_WAIT_MS))
			: 10000;
		$ttlMs = defined('SESSION_REDIS_LOCK_TTL_MS')
			? max(1000, intval(SESSION_REDIS_LOCK_TTL_MS))
			: 60000;
		$token = $this->randomToken();
		$startedAt = microtime(TRUE);

		do {
			$locked = $this->redis->set(
				$this->lockKey($id),
				$token,
				array('nx', 'px' => $ttlMs)
			);
			if ($locked) {
				$this->lockToken = $token;
				$this->lockedSessionId = $id;
				return;
			}

			usleep(20000);
		} while (((microtime(TRUE) - $startedAt) * 1000) < $waitMs);

		throw new RuntimeException('Timed out waiting for the Redis session lock.');
	}

	private function releaseLock() {
		if (
			!($this->redis instanceof Redis)
			|| $this->lockedSessionId === NULL
			|| $this->lockToken === NULL
		) {
			$this->lockedSessionId = NULL;
			$this->lockToken = NULL;
			return;
		}

		$script = "if redis.call('get', KEYS[1]) == ARGV[1] then "
			. "return redis.call('del', KEYS[1]) else return 0 end";
		$this->redis->eval(
			$script,
			array($this->lockKey($this->lockedSessionId), $this->lockToken),
			1
		);

		$this->lockedSessionId = NULL;
		$this->lockToken = NULL;
	}

	private function encodeData($data) {
		if ($this->encrPassword === '') {
			return $data;
		}

		if (!function_exists('openssl_encrypt')) {
			throw new RuntimeException('OpenSSL PHP extension is required for encrypted sessions.');
		}

		$cipherName = 'aes-256-cbc';
		$ivLength = openssl_cipher_iv_length($cipherName);
		$iv = $this->randomBytes($ivLength);
		$keyMaterial = hash('sha512', $this->encrPassword, TRUE);
		$encryptionKey = substr($keyMaterial, 0, 32);
		$macKey = substr($keyMaterial, 32, 32);
		$cipherText = openssl_encrypt(
			$data,
			$cipherName,
			$encryptionKey,
			OPENSSL_RAW_DATA,
			$iv
		);
		if ($cipherText === FALSE) {
			throw new RuntimeException('Could not encrypt session data.');
		}

		$mac = hash_hmac('sha256', $iv . $cipherText, $macKey, TRUE);
		return 'enc:v1:' . base64_encode($iv . $mac . $cipherText);
	}

	private function decodeData($data) {
		if ($this->encrPassword === '') {
			return $data;
		}

		if (substr($data, 0, 7) !== 'enc:v1:') {
			return '';
		}

		$payload = base64_decode(substr($data, 7), TRUE);
		if ($payload === FALSE) {
			return '';
		}

		$cipherName = 'aes-256-cbc';
		$ivLength = openssl_cipher_iv_length($cipherName);
		if (strlen($payload) <= $ivLength + 32) {
			return '';
		}

		$iv = substr($payload, 0, $ivLength);
		$mac = substr($payload, $ivLength, 32);
		$cipherText = substr($payload, $ivLength + 32);
		$keyMaterial = hash('sha512', $this->encrPassword, TRUE);
		$encryptionKey = substr($keyMaterial, 0, 32);
		$macKey = substr($keyMaterial, 32, 32);
		$expectedMac = hash_hmac('sha256', $iv . $cipherText, $macKey, TRUE);

		if (!hash_equals($expectedMac, $mac)) {
			return '';
		}

		$plainText = openssl_decrypt(
			$cipherText,
			$cipherName,
			$encryptionKey,
			OPENSSL_RAW_DATA,
			$iv
		);

		return $plainText === FALSE ? '' : $plainText;
	}

	private function randomToken() {
		return bin2hex($this->randomBytes(16));
	}

	private function randomBytes($length) {
		if (function_exists('random_bytes')) {
			return random_bytes($length);
		}

		$bytes = openssl_random_pseudo_bytes($length, $strong);
		if ($bytes === FALSE || !$strong) {
			throw new RuntimeException('Could not generate cryptographically secure random bytes.');
		}
		return $bytes;
	}

	private function markLoginsClosed($sessionIds) {
		if (!$this->dbLinkMaster || !is_array($sessionIds) || count($sessionIds) === 0) {
			return;
		}

		$quotedIds = array();
		foreach ($sessionIds as $sessionId) {
			$quotedIds[] = "'" . str_replace("'", "''", $sessionId) . "'";
		}

		$this->dbLinkMaster->query(
			"UPDATE logins "
			. "SET date_time_out = now() "
			. "WHERE date_time_out IS NULL "
			. "AND trim(session_id) IN (" . implode(',', $quotedIds) . ")"
		);
	}
}
?>
