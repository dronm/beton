<?php

/**
 * Интеграция с облачной АТС Дом.ру
 * URL скрипта прописан в ЛК Дом.ру
 *
 * accounts(GET / POST)
 * groups(GET / POST)
 * makeCall(POST) 
 * history (GET/ POST)
 * subscribeOnCalls (POST)
 * subscriptionStatus (GET/ POST)
 * set_dnd (POST)
 * get_dnd (GET / POST)
 */

class DOMRuIntegration {

	private $token;
	private $url;

	private function sendPost($params){
		if( ($curl = curl_init())===FALSE ) {
			throw new Exception('Curl not installed!');
		}		
		curl_setopt($curl, CURLOPT_URL, $this->url);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER,true);		
		$response = curl_exec($curl);
		$header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
		$resp_code = curl_getinfo($curl,  CURLINFO_RESPONSE_CODE);
		curl_close($curl);
		
	//file_put_contents(OUTPUT_PATH.'domru.txt',$response);
	//file_put_contents(OUTPUT_PATH.'domru_res.txt',$resp_code);
		if($response && strlen($response)){
			$response_o = json_decode($response);
		}
		
		if ($resp_code!="200"){
			$err = 'Response code '.$resp_code;
			if($response_o && isset($response_o->error)){
				$err = trim($response_o->error);
				if($err == "Invalid parameters"){
					$err = 'Переданы некорректные параметры';
				}
				else if($err == "Invalid token"){
					$err = 'Передан неверный ключ';
				}					
			}				
			throw new Exception($err);
		}
		
		return $response_o;
	}

	public function __construct($token, $url){
		$this->token = $token;
		$this->url = $url;  
	}
	
	/**
	 * Кликом по номеру клиента в CRM совершается исходящий звонок клиенту
	 * cmd тип операции, в данном случае makeCall
	 * phone номер, на который последует звонок
	 * user пользователь Облачной АТС, от которого последует звонок(может быть передан логин, внутренний номер
	 *	или прямой телефонный номер пользователя)
	 * token ключ (token) Облачной АТС, полученный в веб-кабинете
	 *
	 * returns ID
	 */
	public function makeCall($user, $to){
		$CORRECT_TEL_LEN = 11;
		$phone = '';
		for ($i=0;$i<strlen($to);$i++){
			$ch = substr($to,$i,1);
			if (is_numeric($ch)){
				$phone.=$ch;
			}
		}
	
		if (substr($phone,0,1) != '7' && strlen($phone)<$CORRECT_TEL_LEN){
			$phone = '7'.$phone;
		}
	
		if (strlen($phone)!=$CORRECT_TEL_LEN){
			throw new Exception("Неверный номер!");
		}
			
		//return '123456';
		//$phone = '79199378888';
		//{"uuid":"4122465154"}
		
		$response_o = $this->sendPost(array(
			'cmd' => 'makeCall'
			,'phone' => $phone
			,'user' => $user
			,'token' => $this->token
		));
		
		if($response_o && isset($response_o->uuid)){
			return $response_o->uuid;
		}		
	}
	
	/**
	 * CRMможет включить или выключить прием звонков сотрудником во всех его отделахили конкретном отделе
	 *
	 * cmd тип операции, в данном случае subscribeoncalls
	 * user пользователь Облачной АТС, от которого последует звонок(может быть передан логин, внутренний номер
	 *	или прямой телефонный номер пользователя)
	 * token ключ (token) Облачной АТС, полученный в вебкабинете
	 * group_id идентификатор отдела ВАТС, в котором надо  выключить/включить прием звонков
	 * status on -чтобы  включить  прием  звонков,  off -чтобы  выключить прием звонков
	 */
	public function subscribeOnCalls($user, $status, $group_id=NULL){
		$params = array(
			'cmd' => 'subscribeoncalls'
			,'user' => $user
			,'token' => $this->token
			,'status' => (gettype($status)=='boolean')? ( ($status===TRUE)? 'on' : 'off' ) : $status
		);
		if($group_id && strlen($group_id)){
			$params['group_id'] = $group_id;
		}
		$this->sendPost($params);
	}
		 
	/**
	 * CRMможет запросить информацию о том, принимает или не принимает звонки сотрудник в отделе
	 *
	 * cmd тип операции, в данном случае subscribtionstatus
	 * user пользователь Облачной АТС, от которого последует звонок(может быть передан логин, внутренний номер
	 *	или прямой телефонный номер пользователя)
	 * token ключ (token) Облачной АТС, полученный в вебкабинете
	 * group_id идентификатор отдела ВАТС, в котором надо  выключить/включить прием звонков
	 * 
	 * returns bool
	 */
	public function subscriptionStatus($user, $group_id=NULL){
		$params = array(
			'cmd' => 'subscribtionstatus'
			,'user' => $user
			,'token' => $this->token
		);
		if($group_id && strlen($group_id)){
			$params['group_id'] = $group_id;
		}
		$cont = $this->sendPost($params);
		if(strlen($cont)){
			$cont_o = json_decode($cont);
			if($cont_o && isset($cont_o->status)){
				return ($cont_o->status=='on');
			}
		}
	}
	
	/**
	 * CRMможет включить или выключить прием звонков сотрудником (режим do not disturb)
	 *
	 * cmd тип операции, в данном случае set_dnd
	 * user пользователь Облачной АТС, от которого последует звонок(может быть передан логин, внутренний номер
	 *	или прямой телефонный номер пользователя)
	 * token ключ (token) Облачной АТС, полученный в вебкабинете
	 * status true | false
	 */
	public function set_dnd($user, $status){
		$this->sendPost(array(
			'cmd' => 'set_dnd'
			,'user' => $user
			,'token' => $this->token
			,'status' => (gettype($status)=='boolean')? ( ($status===TRUE)? 'true' : 'false' ) : $status
		));
	}
	
	/**
	 * CRM может проверить факт прием звонков сотрудником (включен или выключен режим do not disturb)
	 *
	 * cmd тип операции, в данном случае get_dnd
	 * user пользователь Облачной АТС, от которого последует звонок(может быть передан логин, внутренний номер
	 *	или прямой телефонный номер пользователя)
	 * token ключ (token) Облачной АТС, полученный в вебкабинете
	 * status true | false
	 */
	public function get_dnd($user, $status){
		$this->sendPost(array(
			'cmd' => 'get_dnd'
			,'user' => $user
			,'token' => $this->token
		));
		$cont = $this->sendPost($params);
		if(strlen($cont)){
			$cont_o = json_decode($cont);
			if($cont_o && isset($cont_o->status)){
				return ($cont_o->status=='true');
			}
		}
	}

	public static function toLog($str){
		error_log(date('d/m/y H:i:s').' DOMRuIntegration '.$str);
	}
	
	public static function getExtParam(&$params, $paramId, $required, $defVal=NULL){
		$param_v = isset($params[$paramId])? $params[$paramId]:$defVal;
		if($required && !$param_v || !strlen($param_v)){
			self::toLog($paramId.' is missing');
			return FALSE;
		}
		
		if($paramId =="phone" && substr($param_v,0,1)=="7"){
			$param_v = substr($param_v,1);
		}
		
		return $param_v;
	}
	
	public static function onHistory(&$params, &$dbLink){
	
		//self::logEvent('onHistory', $params);
	
		$call_id = self::getExtParam($params, 'callid', TRUE);
		if($call_id === FALSE){
			return 400;
		}		
		
		$start = self::getExtParam($params, 'start', TRUE);
		if($start === FALSE){
			return 400;
		}
		$type = self::getExtParam($params, 'type', TRUE);
		if($type === FALSE){
			return 400;
		}
		$phone = self::getExtParam($params, 'phone', TRUE);
		if($phone === FALSE){
			return 400;
		}
		$status = self::getExtParam($params, 'status', TRUE);
		if($status === FALSE){
			return 400;
		}
		
		try{
			$link = self::getExtParam($params, 'link', FALSE);
			$ext = self::getExtParam($params, 'ext', FALSE);				
			$duration = self::getExtParam($params, 'duration', FALSE);
			if(!$duration || !strlen($duration)){
				$duration = 0;
			}
			
			$dbLink->query(
				sprintf("UPDATE ast_calls
				SET
					record_link = %s
					,start_time = '%s'::timestamp + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,end_time = '%s'::timestamp + age(now(), timezone('UTC'::text, now())::timestamp with time zone) + (%s||' seconds')::interval
					,call_status = '%s'
				WHERE unique_id = '%s'"
				//update
				,$link? "'".$link."'":'NULL'
				,$start
				,$start, $duration
				,$status
				,$call_id
				)
			);
			
			$res = 200;
			
		}catch(Exception $e){
			$res = 500;
			self::toLog($e->getMessage());
		}		
		
		return $res;
	}
	
	public static function onEvent(&$params, &$dbLink){
		
		//self::logEvent('onEvent', $params);
	
		$call_id = self::getExtParam($params, 'callid', TRUE);
		if($call_id === FALSE){
			return 400;
		}		
		$type = self::getExtParam($params, 'type', TRUE);
		if($type === FALSE){
			return 400;
		}
		$phone = self::getExtParam($params, 'phone', TRUE);
		if($phone === FALSE){
			return 400;
		}
		
		try{
			$ext = self::getExtParam($params, 'ext', FALSE);				
			$res = 200;
			if($type == 'INCOMING'){
				$dbLink->query(
					sprintf("INSERT INTO ast_calls
					(unique_id, caller_id_num, ext, call_type, dt, call_status)
					VALUES (
						'%s'
						,'%s'
						,%s
						,'in'::call_types
						,now()
						,'INCOMING'
					)
					ON CONFLICT (unique_id) DO UPDATE SET
					caller_id_num = '%s'
					,ext = %s"
					,$call_id
					,$phone
					,$ext? "'".$ext."'":'NULL'
					,$phone
					,$ext? "'".$ext."'":'NULL'
				)
			);
			
			
			}else if($type == 'ACCEPTED'){
				$fields = "start_time = now(), call_status = 'ACCEPTED'";
				if($ext){
					$fields.= sprintf(", ext='%s'",$ext);
				}
				$dbLink->query(
					sprintf("UPDATE ast_calls
					SET %s
					WHERE unique_id='%s'"
					,$fields
					,$call_id
				));
			
			}else if($type == 'COMPLETED'){
				$fields = "end_time = now(), call_status = 'COMPLETED'";
				if($ext){
					$fields.= sprintf(", ext='%s'",$ext);
				}
			
				$dbLink->query(
					sprintf("UPDATE ast_calls
					SET %s
					WHERE unique_id='%s'"
					,$fields
					,$call_id
				));
				
			}else if($type == 'CANCELLED'){			
				$dbLink->query(
					sprintf("UPDATE ast_calls
					SET
						call_status = 'CANCELLED'
					WHERE unique_id='%s'"
					,$call_id
				));
			
			}else if($type == 'OUTGOING'){
				$dbLink->query(
					sprintf("INSERT INTO ast_calls
					(unique_id, caller_id_num, ext, call_type, dt, call_status)
					VALUES (
						'%s'
						,'%s'
						,%s
						,'out'::call_types
						,now()
						,'OUTGOING'
					)"
					,$call_id
					,$phone
					,$ext? "'".$ext."'":'NULL'
				));
			}else{
				$res = 400;
			}
			
		}catch(Exception $e){
			$res = 500;
			self::toLog($e->getMessage());
		}		
		
		return $res;
	}	
	
	public static function onContact(&$params, &$dbLink, &$response){
	
		//self::logEvent('onContact', $params);
		
		$phone = self::getExtParam($params, 'phone', TRUE);
		if($phone === FALSE){
			return 400;
		}		
	
		try{
			$ar = $dbLink->query_first(sprintf(
				"SELECT
					cl.name AS client_name
					,u.domru_user_name AS user_id
				FROM client_tels AS tl
				LEFT JOIN clients AS cl ON cl.id = tl.client_id
				LEFT JOIN users AS u ON u.id = cl.manager_id				
				WHERE tl.tel=format_cel_phone('%s')"
				,$phone
			));
			
			if(!is_array($ar) || !isset($ar['client_name'])){
				throw new Exception('Client not found!');
			}
			
			$user_id = (isset($ar['user_id']) && strlen($ar['user_id']))? '"'.$ar['user_id'].'"' : 'null';
			$response = sprintf('{"contact_name": "%s","responsible":%s}', $ar['client_name'], $user_id);
				
			$res = 200;
			
		}catch(Exception $e){
			$res = 500;
			self::toLog($e->getMessage());
		}
		
		return $res;		
	}
	
	public static function logEvent($eventId, &$params){
		file_put_contents(
			OUTPUT_PATH.'domru.log',
			date('Y-m-d H:i:s').' '.$eventId.PHP_EOL.
			var_export($params,TRUE).PHP_EOL.
			'**********'.PHP_EOL,
			FILE_APPEND
		);
	}
}
?>
