<?php
require_once('common/telegram.php');

define('TM_APP_NAME', 'eurobeton');

//ключ авторизации со своим скриптом для входящих сообщений
define('IN_MSG_AUTH_KEY', 'a32544fa-c680-11eb-b8bc-0242ac130003');

function log_tm_error($dbTMConn, $appId, $token, $chatId, $t){
	
	try{
		$dbTMConn->query(sprintf(
			"SELECT public.logger_add(row(NULL, now(), %d, '%s', 0, 'tm', 1)::logger)",
			$appId, 'Telegram bot: '.$t
		));
		apiRequestJson($token, "sendMessage",
			array(
				'chat_id' => $chatId,
				"text" => 'Ошибка при выполнении запроса'
			),
			FALSE
		);
		
	}catch(Exception $e){
		error_log('Telegram bot log_tm_error: '.$e->getMessage());
	}
}

function log_msg($msg){
	file_put_contents('log/tm_log.txt',date('Y-m-dTH:i:s').' '.$msg.PHP_EOL,FILE_APPEND);
}

/**
 * Application specific function
 */
function processMessage($message) {
	// process incoming message

	$dbTMConn = getTMDbConn();
	
	$q_params = $dbTMConn->query_first(sprintf(
		"SELECT
			id,
			tm_params
		FROM apps WHERE name = '%s'", TM_APP_NAME
	));
	if(!isset($q_params['tm_params'])){
		throw new Exception('TM params not found on application name '.$appName);
	}
	$tm_params = json_decode($q_params['tm_params'], TRUE);
	
	$message_id = $message['message_id'];
	$chat_id = $message['chat']['id'];
	
	if (isset($message['text'])) {

		// incoming text message
		$text = $message['text'];

		if (strpos($text, "/start") === 0) {
			try{
				//activation code?
				$code = 0;
				$code_start = strpos($text, " ");
				if($code_start > 0){
					$code = @intval(substr($text, $code_start+1));
				}
				$regged = FALSE;
				if($code > 0 && $code<10000){
					$code_q = sprintf(
						"SELECT notifications.reg_ext_user(%d, '%s'::jsonb, %d) AS id",
						$q_params['id'],
						$dbTMConn->escape_string(json_encode($message['from'])),
						$code
					);				
					//check on code
					$ar = $dbTMConn->query_first($code_q);
					if(is_array($ar) && count($ar) && isset($ar['id'])) {
						//registered!
						$out_m = sprintf('%s, зарегистрирован',$message['from']['first_name']);
						$regged = TRUE;
					}
				}
				if(!$regged){
					//no code/wrong code
					$ar = $dbTMConn->query_first(sprintf(
						"SELECT ext_contact_id
						FROM notifications.ext_users WHERE tm_user->>'id' = '%s'",
						$chat_id
					));
					if(is_array($ar) && count($ar) && isset($ar['ext_contact_id'])) {
						//registered already
						$out_m = sprintf('С возвращением, %s',$message['from']['first_name']);
						
					}else{
					
						$q_ar = $dbTMConn->query_first(sprintf(
							"SELECT notifications.reg_ext_user(%d, '%s'::jsonb, 0) AS id",
							$q_params['id'],
							$dbTMConn->escape_string(json_encode($message['from']))
						));
						$out_m = sprintf('%s, отправьте код активации для окончания регистрации',$message['from']['first_name']);
					}
				}
				apiRequestJson($tm_params['token'], "sendMessage",
					array(
						'chat_id' => $chat_id,
						"text" => $out_m
					),
					FALSE
				);
				
			}catch(Exception $e){
				log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
			}
			
		
		} else if (strpos($text, "/stop") === 0) {
			// stop now
			try{
				$dbTMConn->query(sprintf(
					"DELETE FROM notifications.ext_users WHERE tm_user->>'id' = '%s' AND app_id = %d",
					$chat_id,
					$q_params['id']
				));
				apiRequestJson($tm_params['token'], "sendMessage",
					array(
						'chat_id' => $chat_id,
						"text" => sprintf('Пользователь %s удален.',$message['from']['first_name'])
					),
					FALSE
				);
			}catch(Exception $e){
				log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
			}
			
		} else {
//log_msg($text);			
			try{					
				$q = sprintf(
					"SELECT ext_contact_id
					FROM notifications.ext_users
					WHERE tm_user->>'id' = '%s'
						AND app_id = %d",
					$chat_id,
					$q_params['id']
				);

				$ar = $dbTMConn->query_first($q);
				//есть связка с телеграм, но не указан наш пользователь
				if(is_array($ar) && count($ar) && !isset($ar['ext_contact_id'])){
					apiRequestJson($tm_params['token'], "sendMessage",
						array('chat_id' => $chat_id, "text" => 'Контакт приложения не определен. Обратитесь в офис'),
						FALSE
					);
					return;
				}
				
				//Нет вообще информации о контакте, но есть регистрационная информация, попробуем найти
				// по коду активации
				if(strlen($message['text'])==4 && (!is_array($ar) || !count($ar))){
					$act_code = @intval($message['text']);
					if($act_code > 0){
						$q_ar = $dbTMConn->query_first(sprintf(
							"SELECT notifications.reg_ext_user(%d, '%s'::jsonb, %d) AS id",
							$q_params['id'],
							$dbTMConn->escape_string(json_encode($message['from'])),
							$act_code
						));

						if(is_array($q_ar) && count($q_ar)){
							if(!isset($q_ar['id'])){
								$msg = 'Невернй код акивации.';
							}else{
								$msg = 'Регистрация завершена.';
							}
							
							apiRequestJson($tm_params['token'], "sendMessage",
								array('chat_id' => $chat_id, "text" => $msg),
								FALSE
							);
							
						}else{	
							throw new Exception('Unknown error, q_ar not set');
						}
						//stop here
						return;
					}
				}

				//Нет контакта у нас в базе и шлет какое-то сообщение
				//зарегим со всеми данными, отьравим в офис
				if(!is_array($ar) || !count($ar)){
					$dbTMConn->query(sprintf(
						"INSERT INTO notifications.ext_users (app_id, tm_user) VALUES (%d, '%s'::jsonb)"
						,$q_params['id']
						,$dbTMConn->escape_string(json_encode($message['from']))
					));
					apiRequestJson($tm_params['token'], "sendMessage",
						array('chat_id' => $chat_id, "text" => 'Контакт приложения не определен. Обратитесь в офис.'),
						FALSE
					);
					return;
				}
				
				//ordinary message
				$ar = $dbTMConn->query_first(sprintf(
					"INSERT INTO notifications.tm_in_messages
					(app_id, message)
					VALUES (%d, '%s'::jsonb)
					RETURNING id",
					$q_params['id'],
					json_encode($message)
				));
				if(!is_array($ar) || !count($ar)){
					throw new Exception('INSERT INTO notifications.tm_in_messages no id');
				}
				if(!isset($tm_params['inMessageNotificationURL'])){
					throw new Exception('inMessageNotificationURL is not set');
				}
				$handle = curl_init($tm_params["inMessageNotificationURL"]. sprintf('/?k=%s&id=%d', IN_MSG_AUTH_KEY, $ar['id']) );
				curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($handle, CURLOPT_CONNECTTIMEOUT, CURL_CON_TIMEOUT);
				curl_setopt($handle, CURLOPT_TIMEOUT, CURL_TIMEOUT);
				$response = curl_exec($handle);
				if ($response === false) {
					$errno = curl_errno($handle);
					$error = curl_error($handle);
					curl_close($handle);
					throw new Exception("Telegram Curl callback $errno: $error");
				}
				$http_code = intval(curl_getinfo($handle, CURLINFO_HTTP_CODE));
				curl_close($handle);

				if ($http_code != 200) {
					throw new Exception("Telegram Curl callback http_code=$http_code");
					/*apiRequestJson($tm_params['token'], "sendMessage",
						array('chat_id' => $chat_id, "text" => 'Сообщение обрабатывается...'),
						FALSE
					);*/
				}
				
			}catch(Exception $e){
				log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
			}
		}
	} else {
		apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Обрабатываются только текстовые сообщения'),FALSE);
	}
}

if (php_sapi_name() == 'cli') {
	// if run from console, set or delete webhook
	if(!isset($argv) || !is_array($argv) || count($argv)<2){
		die('App name is not specified!'.PHP_EOL);
	}
	if(isset($argv) && is_array($argv) && count($argv)>=3 && $argv[2] == 'delete'){
		delWebhook($argv[1]);
		
	}else{
		//Настройки берутся из базы ms.apps по имени приложения
		//php7.4 tm_bot.php eurobeton
		addWebhook($argv[1]);
	}
	exit;
}

$content = file_get_contents("php://input");
$update = json_decode($content, TRUE);

if (!$update) {
	// receive wrong update, must not happen
	exit;
}

if (isset($update["message"])) {
	processMessage($update["message"]);
}

?>
