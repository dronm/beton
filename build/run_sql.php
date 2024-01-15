<?php
require_once(dirname(__FILE__).'/../Config.php');

$sql = file_get_contents($argv[1]);
$cnt1 = NULL;$cnt2 = NULL;$cnt3 = NULL;$cnt4 = NULL;
$sql = str_replace('OWNER TO;', 'OWNER TO '.DB_USER.';', $sql, $cnt1);
$sql = str_replace('OWNER TO ;', 'OWNER TO '.DB_USER.';', $sql, $cnt2);
if(defined("DB_SCHEMA")){
	$sql = str_replace('public', DB_SCHEMA, $sql, $cnt4);
}

if ($cnt1||$cnt2||$cnt3||$cnt4){
	$sql_f = '.run_sql.sql';
	file_put_contents($sql_f, $sql);	
}
else{
	$sql_f = $argv[1];
}

$er_f = dirname(__FILE__).'/run_sql.er';
if(file_exists($er_f)){
	unlink($er_f);
}
$cmd = sprintf('export PGPASSWORD=%s ; psql -h %s -d %s -U %s -f '.$sql_f.' 2>'.$er_f,
		DB_PASSWORD,
		DB_SERVER_MASTER,
		DB_NAME,
		DB_USER
);
passthru ($cmd);

$er = FALSE;
if(file_exists($er_f) && strlen($er_s = file_get_contents($er_f))){
	//NOTICE:
	//ЗАМЕЧАНИЕ:
	echo $er_s;
	if(strpos($er_s, 'ERROR:') !==FALSE || mb_strpos($er_s, 'ОШИБКА:') !==FALSE){
		echo PHP_EOL.'********************* ERROR *********************'.PHP_EOL.$er_s.PHP_EOL;
		$er = TRUE;
	}
}
if(!$er){
	//add update log
	file_put_contents(
		dirname(__FILE__).'/update.sql',
		PHP_EOL.sprintf('-- ******************* update %s ******************',date('d/m/Y H:i:s')).PHP_EOL.$sql.PHP_EOL,
		FILE_APPEND
	);
}	
?>
