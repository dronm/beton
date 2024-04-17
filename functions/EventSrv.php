<?php

require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/db_con_f.php');

class EventSrv {
	
	public static function publish($eventId, $eventParams){				
		$link = db_con();
		
		//add lsn to event
		//ControllerDb.php
		
		$link->query(sprintf(
			"SELECT pg_notify('%s','%s')"
			,$eventId
			,json_encode(array('params' => $eventParams))
		));
	}
	
	public static function publishAsync($eventId,$eventParams){
		self::publish($eventId, $eventParams);
		/*
		if(!is_array($eventParams)){
			$eventParams = [];
		}
	
		$param_f_n = sys_get_temp_dir().DIRECTORY_SEPARATOR. uniqid();
		file_put_contents($param_f_n,
			$eventId.PHP_EOL.
			serialize($eventParams)			
		);
		
		$script = FUNC_PATH.'ev_publish.php';
		if(is_null($script) || !file_exists($script)){
			error_log('ev_publish.php script not found');
			
		}else{
			exec("php ".$script." ".$param_f_n." > /dev/null 2>&1 &");
		}
		*/
	}
	
}
