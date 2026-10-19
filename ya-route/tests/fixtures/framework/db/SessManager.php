<?php
class SessManager
{
	public $detailedError;
	public $productionError;
	public function start($name, $db, $master, $persistent, $life, $key): void
	{
		ini_set('session.save_path', getenv('ROUTE_FIXTURE_SESSIONS'));
		session_name($name);
		session_start();
	}
}
