<?php

require_once('db_con.php');

$dbLink->query('SELECT special_vehicles_list_refresh_today()');

?>
