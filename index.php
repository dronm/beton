<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Expose-Headers: X-LSN-Position');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-LSN-Position');

/* header('Service-Worker-Allowed: /'); */
require_once('Config.php');

if (isset($_REQUEST['sid'])){
	session_id($_REQUEST['sid']);
}
else if (strlen($_SERVER['QUERY_STRING'])&&substr($_SERVER['QUERY_STRING'],0,3)=='sid'){	
	session_id(substr($_SERVER['QUERY_STRING'],3));
}

require_once('cmd.php');
?>
