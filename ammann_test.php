<?php
require_once('Config.php');
require_once(FUNC_PATH.'Ammann.php');
require_once(FUNC_PATH.'db_con.php');

/*
$result = NULL;
Ammann::parseProduction('/home/andrey/www/htdocs/beton_new/build/Konkred/6.pdf', $result);
var_dump($result);
*/
Ammann::uploadProductionFile($dbLink,1, '/home/andrey/www/htdocs/beton_new/build/Konkred/7.pdf', 1);
?>
