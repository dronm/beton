<?php
require_once(dirname(__FILE__).'/../../functions/exch1c.php');

$res = Exch1c::health();
echo "********** result:".PHP_EOL;
echo var_export($res, true).PHP_EOL;

?>


