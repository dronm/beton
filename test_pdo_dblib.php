<?php
/*
 * sudo apt install php8.1-sybase freetds-bin freetds-common
 * php8.1 -m | grep -Ei 'PDO|dblib' -- expected PDO pdo_dblib
 * php8.1 -r 'print_r(PDO::getAvailableDrivers());' -- expected to include dblib
 */

$host = '92.255.167.42';
$port = 50203;
$database = 'Santral';
$user = 'andreymikhalevich';
$password = 'wimaf2020ii42';

if(!extension_loaded('pdo_dblib')){
	fwrite(STDERR, "PDO_DBLIB extension is not loaded.\n");
	exit(1);
}

$dsn = sprintf(
	'dblib:host=%s:%d;dbname=%s;charset=UTF-8',
	$host,
	$port,
	$database
);

try{
	$pdo = new PDO(
		$dsn,
		$user,
		$password,
		array(
			PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
		)
	);

	echo "Connection successful.\n";

	$sql = "
		SELECT TOP 1
			Uretim.Id AS id,
			Uretim.BasTarih AS dt_start,
			Uretim.AracPlaka AS vehicle_descr
		FROM Uretim
		ORDER BY Uretim.Id DESC
	";

	$statement = $pdo->query($sql);
	$row = $statement->fetch();

	if($row === FALSE){
		echo "Query succeeded, but no rows were returned.\n";
		exit(0);
	}

	echo "Query result:\n";
	print_r($row);
}
catch(PDOException $e){
	fwrite(STDERR, "PDO error:\n");
	fwrite(STDERR, $e->getMessage()."\n");
	exit(1);
}
