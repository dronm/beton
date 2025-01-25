<?php
require_once('ExtProg.php');
require_once('db_con_f.php');

$res = ExtProg::ping();
$link = db_con();
$dbResult = sprintf('{"result": %s, "date": "%s"}', ($res===TRUE? "true" : "false"), date("Y-m-d H:i:s"));
$link->query(sprintf("SELECT const_ping1c_set_val('%s'::JSON)", $dbResult));

?>

