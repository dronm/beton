<?php
	require_once("db_con_f.php");

	$con = db_con();

	$veh = file_get_contents("vehicles.csv");
	$lines = explode("\n", $veh);
	$i = -1;
	foreach ($lines as $line) {
		// echo $line.PHP_EOL;
		$i++;
		if($i == 0){
			continue;
		}
		$vals = explode(",", $line);
		if(count($vals) < 4){
			continue;
		}
		$plate = str_replace('"', "'", $vals[0]);
		$make = str_replace('"', "'", $vals[1]);
		$load_cap = str_replace('"', "", $vals[2]);
		$tracker = str_replace('"', "'", $vals[3]);
		$q = sprintf("UPDATE vehicles SET
			make = %s,
			load_capacity = %s,
			tracker_id = %s 
		WHERE plate = %s",
		$make, $load_cap, $tracker, $plate);
		// echo $q.PHP_EOL;

		$con->query($q);
	}
	echo "queries count: ".$i.PHP_EOL;
?>
