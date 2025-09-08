<?php
header('Access-Control-Allow-Origin: *');
/* header('Service-Worker-Allowed: /'); */
require_once('Config.php');

//ini_set('session.serialize_handler', 'php_serialize');

if (isset($_REQUEST['sid'])){
	session_id($_REQUEST['sid']);
}
else if (strlen($_SERVER['QUERY_STRING'])&&substr($_SERVER['QUERY_STRING'],0,3)=='sid'){	
	session_id(substr($_SERVER['QUERY_STRING'],3));
}
//throw new Exception("dbLinkMaster");
require_once('cmd.php');
?>
