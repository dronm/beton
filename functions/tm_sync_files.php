<?php
require_once(dirname(__FILE__).'/../Config.uniq.php');

function syncStore($file){
	if(!defined('TM_REMOTE_HOSTS') || TM_REMOTE_HOSTS == ''){
		return;
	}
	$hosts = json_decode(TM_REMOTE_HOSTS, TRUE);
	foreach($hosts as $h){
		$cmd = sprintf('sudo -H -u andrey rsync -az -e "ssh -p %d" %s %s:%s > /dev/null &', intval($h['port']), $file, $h['host'], $file);
		//log_msg($cmd);
		exec($cmd);
	}
}
?>
