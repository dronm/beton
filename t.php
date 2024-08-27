<?php
 $text = 'some text
another line of text goes here;
import {Class1} from "../somepath/Class1.json"
import {Class2} from "../somepath/Class2.json"

 var v = "Какой-то русский текст";
Some more text goes here.';
echo $text."</br>";

while(1==1) {
	$p = mb_strpos($text, "import {", 0);
	if($p === FALSE){
		break;
	}
	echo $p."</br>";
	$p2 = mb_strpos($text, "\n", $p);
	if($p2 === FALSE){
		break;
	}
	echo $p2."</br>";
	$text = mb_substr($text, 0, $p).mb_substr($text, $p2+1);
}
// $p2 = mb_strpos($text, "\n", $p);
// echo $p."</br>";
// echo $p2."</br>";
// $text = mb_substr($text, 0, $p).mb_substr($text, $p2+1);
echo $text."</br>";

/*
while ($p = strpos($text, "import {", $p) !== FALSE) {
				
	echo $p.PHP_EOL;
	$p = strpos($text, '\n', $p);
}
*/
?>
