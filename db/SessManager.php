<?php
/**
 * Newer class than SessionManager.
 */
class SessManager{
	private $dbLink;
	private $dbLinkMaster;
	private $encrPassword;
	
	function __construct() {
		// set our custom session functions.
		session_set_save_handler(
			array($this, 'open'),
			array($this, 'close'),
			array($this, 'read'),
			array($this, 'write'),
			array($this, 'destroy'),
			array($this, 'gc')
		);
	 
		// This line prevents unexpected effects when using objects as save handlers.
		register_shutdown_function('session_write_close');
	}
	function start($session_name, $dbLinkMaster, $dbLink,$secure=FALSE,$durationSec=0,$encrPassword='') {
		$this->dbLinkMaster = $dbLinkMaster;
		$this->dbLink = $dbLink;
		$this->encrPassword = $encrPassword;
		
		// Make sure the session cookie is not accessable via javascript.
		$httponly = true;
	 
		// Hash algorithm to use for the sessionid. (use hash_algos() to get a list of available hashes.)
		$session_hash = 'sha512';
	 
		// Check if hash is available
		if (in_array($session_hash, hash_algos())) {
		  // Set the has function.
		  ini_set('session.hash_function', $session_hash);
		}
		// How many bits per character of the hash.
		// The possible values are '4' (0-9, a-f), '5' (0-9, a-v), and '6' (0-9, a-z, A-Z, "-", ",").
		ini_set('session.hash_bits_per_character', 5);
	 
		// Force the session to only use cookies, not URL variables.
		ini_set('session.use_only_cookies', 1);
	 
	 	if($durationSec){
		 	ini_set('session.gc_maxlifetime', $durationSec);
		 }
	 
		// Get session cookie parameters 
		$cookieParams = session_get_cookie_params(); 
		// Set the parameters
		session_set_cookie_params($cookieParams["lifetime"], $cookieParams["path"], $cookieParams["domain"], $secure, $httponly); 
		// Change the session name 
		session_name($session_name);
		// Now we cat start the session
		session_start();
		// This line regenerates the session and delete the old one. 
		// It also generates a new encryption key in the database. 
		//session_regenerate_id(true);    		
	}
	function open() {
		return TRUE;
	}	
	function close() {
		return TRUE;
	}
	function read($id) {
		if(isset($this->encrPassword)&&strlen($this->encrPassword)){
			$q = sprintf("SELECT sess_enc_read('%s','%s') AS data",$id,$this->encrPassword);			
		}
		else{
			$q = sprintf("SELECT data FROM sessions WHERE id='%s'",$id);
		}
		$ar = $this->dbLink->query_first($q);
		if (isset($ar) && count($ar)>0){
			$d = $ar['data'];
			if(is_null($d)){
				$d = '';
			}
			return base64_decode($d);
		}
	}
	function write($id, $data) {	
		$ip = isset($_SERVER["REMOTE_ADDR"])? $_SERVER["REMOTE_ADDR"] : '127.0.0.1';
		if(strlen($this->encrPassword)){
			$q = sprintf("SELECT sess_enc_write('%s','%s','%s','%s')",$id,base64_encode($data),$this->encrPassword,$ip);
		}
		else{
			$q = sprintf("SELECT sess_write('%s','%s','%s')",$id,base64_encode($data),$ip);
		}
		$this->dbLinkMaster->query($q);
		
		return TRUE;
	}
	
	function destroy($id) {
		$this->dbLinkMaster->query(sprintf("DELETE FROM sessions WHERE id='%s'",$id));
		$this->dbLinkMaster->query(
			sprintf(
				"UPDATE logins SET date_time_out = '%s' WHERE session_id='%s'",
				date('Y-m-d H:i:s'),
				$id
			)
		);
			
		return true;
	}	
	function gc($lifetime) {
		$this->dbLinkMaster->query(
			sprintf(
				"SELECT sess_gc('%d seconds'::interval)",
				$lifetime
			)
		);
			
		return TRUE;
	}
	
	function restart() {
		session_unset();
		session_destroy();
		session_start();	
	}

	function findSession($token,&$dbLink,&$sessInf) {
		$res = FALSE;
		$access_p = strpos($token,':');
		if ($access_p!==FALSE){
			$access_salt = substr($token,0,$access_p);
			$access_hash = substr($token,$access_p+1);
		
			$access_salt_db = NULL;
			$f = new FieldExtString('salt');
			FieldSQLString::formatForDb($dbLink,$f->validate($access_salt),$access_salt_db);
		
			$sess_exp_col = (defined('SESSION_EXP_SEC')? intval(SESSION_EXP_SEC):0)? sprintf('(EXTRACT(EPOCH FROM now()::timestamp-l.set_date_time)>=%d)',SESSION_EXP_SEC):'FALSE';
			$sess_live_col = (defined('SESSION_LIVE_SEC')? intval(SESSION_LIVE_SEC):0)? sprintf('(EXTRACT(EPOCH FROM now()::timestamp-l.date_time_in)>=%d)',SESSION_LIVE_SEC):'FALSE';
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
			//throw new Exception('access_hash='.$access_hash.' md5='.md5($access_salt.$session_ar['session_id']).' salt='.$access_salt);						
			if (is_array($session_ar) && isset($session_ar['session_id']) && $access_hash==md5($access_salt.$session_ar['session_id'])){
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
	
	/*
	private function encrypt($data, $key) {
		//return $data;
		$salt = 'cH!swe!retReGu7W6bEDRup7usuDUh9THeD2CHeGE*ewr4n39=E@rAsp7c-Ph@pH';
		$key = substr(hash('sha256', $salt.$key.$salt), 0, 32);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB);
		$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
		$encrypted = base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $key, $data, MCRYPT_MODE_ECB, $iv));
		return $encrypted;
	}
	private function decrypt($data, $key) {
		//return $data;
		$salt = 'cH!swe!retReGu7W6bEDRup7usuDUh9THeD2CHeGE*ewr4n39=E@rAsp7c-Ph@pH';
		$key = substr(hash('sha256', $salt.$key.$salt), 0, 32);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB);
		$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
		$decrypted = mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $key, base64_decode($data), MCRYPT_MODE_ECB, $iv);
		return $decrypted;
	}	
	*/		
}
?>
