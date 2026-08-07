<?php
require_once('db_con.php');
$qId = $dbLink->query(
	'SELECT 
		workplace_id, user_id 
	FROM workplace_schedules 
	WHERE for_date=NOW()::date'
);

while($ar = $dbLink->fetch_array($qId)){
	if(isset($ar["workplace_id"]) && isset($ar["user_id"])){
		//echo 'newUserID:'.$ar["user_id"].', workplace_id:'.$ar["workplace_id"];
		$dbLink->query(
			"UPDATE workplaces SET user_id = $1 WHERE id = $2",
			[ $ar["user_id"], $ar["workplace_id"] ]
		);
	}
}
