<?php
require_once('db_con.php');

$dbLink->query("UPDATE logins
	SET date_time_out = now()
	WHERE session_id IN (SELECT id FROM sessions)");

$dbLink->query("TRUNCATE sessions");

