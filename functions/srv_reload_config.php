<?php

require_once('db_con_f.php');

$dbLink = db_con();
$dbLink->query("SELECT pg_notify('Service.reload_config', NULL)");

?>
