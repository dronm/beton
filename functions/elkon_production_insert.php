<?php

/**
 * Запускает elkon_production.php: elkon_production_insert
 * принимает аргумент: id производства
 */

require_once(dirname(__FILE__)."/db_con_f.php");
require_once(dirname(__FILE__)."/elkon_production.php");

if (!isset($argv) || count($argv)<2){
	die("Arguments: shipment_id");
}

$dbLink = db_con();
elkon_production_insert($dbLink, intval($argv[1]));
?>
