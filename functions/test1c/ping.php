<?php
require_once(dirname(__FILE__).'/../../functions/exch1c.php');

$res = Exch1c::ping();
echo "********** result:".PHP_EOL;
echo $res.PHP_EOL;

?>
