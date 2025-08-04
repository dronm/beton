<?php
$ch = curl_init("https://www.foreca.com/101488754/Tyumen-Tyumen’-Oblast-Russia");
//curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
//curl_setopt($ch, CURLOPT_HEADER, false);
$contents = curl_exec($ch);
curl_close($ch);
echo $contents.PHP_EOL;
?>
