<?php

//returns boolean
function material_period_check($dbLink, $userIdDb, $periodDb) {
	$ar = $dbLink->query_first(sprintf( 
		"SELECT user_allowed_material_correction_check(%d, %s) allowed"
		,$userIdDb
		,$periodDb
	));
	if(!is_array($ar) || !count($ar) || !isset($ar)){
		throw new Exception("query_first() error");
	}
	if($ar["allowed"] == 'f'){
		throw new Exception("Запрещена загрузка в данном периоде");
	}
}

?>

