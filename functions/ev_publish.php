<?php
require_once(dirname(__FILE__).'/EventSrv.php');

if (count($argv)<2){
	die("Arguments: param_file");
}
if(!file_exists($argv[1])){
	die("File not found:".$argv[1]);
}
$params = file_get_contents($argv[1]);
$param_ar = explode(PHP_EOL,$params);

/**
 * 2 Lines!
 * 0 - eventId
 * 1 - eventParams
 */
if(count($param_ar)<2){
	die("Param file must have 2 lines!");
}

$ev_params = unserialize($param_ar[1]);
try{
	EventSrv::publish($param_ar[0], $ev_params);
}finally{
	unlink($argv[1]);
}

?>
