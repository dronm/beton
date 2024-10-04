<?php
//Обработка входящих колбаков телеграм
//Можно запускать как cli, с указанием базы и команды
//

//telegram store constant
require_once(dirname(__FILE__).'/../Config.uniq.php');

require_once('common/telegram.php');

//auth key
require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/../functions/tm_sync_files.php');

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
	file_put_contents(dirname(__FILE__).'/../output/tm_log.txt',date('Y-m-dTH:i:s').' '.$msg.PHP_EOL,FILE_APPEND);
}

function downloadFile($token, $fullFileId){
	$file_id = apiDownloadFile($token, $fullFileId, TM_STORE);
	syncStore(TM_STORE. '/'. $file_id);//$resp["file_unique_id"]
	
	//$pid = pcntl_fork();
	//if ($pid == 0) {		
		//exit(0);
	//}	
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
	
	// incoming message, might be no text
	if (isset($message['text']) && strpos($message['text'], "/start") === 0) {
		try{
			//activation code?
			$code = 0;
			$code_start = strpos($message['text'], " ");
			if($code_start > 0){
				$code = @intval(substr($message['text'], $code_start+1));
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
	
	} else if (isset($message['text']) && strpos($message['text'], "/stop") === 0) {
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
//log_msg($message['text']);			
		try{	
			//check ext_contact_id
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
			if(isset($message['text']) && strlen($message['text'])==4 && (!is_array($ar) || !count($ar)) ){
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
							$msg = 'Неверный код акивации.';
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
			//зарегим со всеми данными, отправим в офис
			if(!is_array($ar) || !count($ar)){
				$dbTMConn->query(sprintf(
					"INSERT INTO notifications.ext_users (app_id, tm_user) VALUES (%d, '%s'::jsonb)"
					,$q_params['id']
					,$dbTMConn->escape_string(json_encode($message['from']))
				));
				apiRequestJson($tm_params['token'], "sendMessage",
					array('chat_id' => $chat_id, "text" => 'Вы не зарегистрированы. Обратитесь в офис.'),
					FALSE
				);
				return;
			}
			
			//photo array
			if(isset($message['photo']) && is_array($message['photo']) && count($message['photo']) ){
				//smallest, largest
				$small_size = 99999999;
				$big_size = 0;
				$small_file_id = NULL;
				$big_file_id = NULL;
				foreach($message['photo'] as $photo){
					//$photo['file_unique_id']
					if(isset($photo['file_size'])){
						$file_size = intval($photo['file_size']);
						if($file_size > $big_size){
							$big_size = $file_size;
							$big_file_id = $photo['file_id'];
						}
						if($file_size < $small_size){
							$small_size = $file_size;
							$small_file_id = $photo['file_id'];
						}
					}					
				}
				if(isset($small_file_id)){
					downloadFile($tm_params['token'], $small_file_id);	
				}
				if(isset($big_file_id)){
					downloadFile($tm_params['token'], $big_file_id);	
				}
				apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Фото загружено'),FALSE);
				
			}else if(isset($message['sticker']) ){
				downloadFile($tm_params['token'], $message['sticker']['file_id']);	
				
			}else if(isset($message['video']) ){
				downloadFile($tm_params['token'], $message['video']['file_id']);
				if(isset($message['document']['thumb']) && isset($message['document']['thumb']['file_id'])){
					downloadFile($tm_params['token'], $message['video']['thumb']['file_id']);		
				}
				apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Видео загружено'),FALSE);

			}else if(isset($message['voice']) ){
				downloadFile($tm_params['token'], $message['voice']['file_id']);	
				apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Голосовое сообщение загружено'),FALSE);
				
			}else if(isset($message['animation']) ){
				downloadFile($tm_params['token'], $message['animation']['file_id']);	
				
			}else if(isset($message['audio']) ){
				downloadFile($tm_params['token'], $message['audio']['file_id']);	
				apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Аудио файл загружен'),FALSE);
				
			}else if(isset($message['document'])){
				downloadFile($tm_params['token'], $message['document']['file_id']);
				if(isset($message['document']['thumb']) && isset($message['document']['thumb']['file_id'])){
					downloadFile($tm_params['token'], $message['document']['thumb']['file_id']);							
				}
				apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Документ загружен'),FALSE);
			}
			/*if(!isset($message['text'])){
				$pid = pcntl_fork();
				if ($pid == 0) {
					syncStore();
					exit(0);
				}
			}*/
			
			//message contact registered
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
			
			//application inform callback
			if(!isset($tm_params['inMessageNotificationURL'])){
				throw new Exception('inMessageNotificationURL is not set');
			}
			
			//fork!
			//db parameter does not have protocol!
			//because of MS!
			$handle = curl_init('https://'.$tm_params["inMessageNotificationURL"]. sprintf('/?k=%s&id=%d', TM_NOTIF_AUTH_KEY, $ar['id']) );
			curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($handle, CURLOPT_CONNECTTIMEOUT, CURL_CON_TIMEOUT);
			curl_setopt($handle, CURLOPT_TIMEOUT, CURL_TIMEOUT);
			$response = curl_exec($handle);
			if ($response === false) {
				$errno = curl_errno($handle);
				curl_close($handle);
				throw new Exception("Telegram Curl callback $errno: $error");
			}
			$http_code = intval(curl_getinfo($handle, CURLINFO_HTTP_CODE));
			curl_close($handle);

			if ($http_code != 200) {
				throw new Exception("Telegram Curl callback http_code=$http_code");
			}
			
		}catch(Exception $e){
			log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
		}
	}
	//apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Обрабатываются только текстовые сообщения!'),FALSE);
}

if (php_sapi_name() == 'cli') {
	// if run from console, set or delete webhook
	if(!isset($argv) || !is_array($argv) || count($argv)<2){
		die('Usage: <APP_NAME> <COMMAND>'.PHP_EOL.'commands: delete, add'.PHP_EOL);
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
/*
$update = '{
  "chat": {
    "id": 1663576744,
    "type": "private",
    "last_name": "Халилов",
    "first_name": "Рамзан"
  },
  "date": 1709125414,
  "from": {
    "id": 1663576744,
    "is_bot": false,
    "last_name": "Халилов",
    "first_name": "Рамзан",
    "language_code": "ru"
  },
  "voice": {
    "file_id": "AwACAgIAAxkBAAEBZOFl3y8mT-2R8JNCMNWKXTeacBzoQwACG0UAAtaX-EplivUtxU3jlDQE",
    "duration": 0,
    "file_size": 3324,
    "mime_type": "audio/ogg",
    "file_unique_id": "AgADG0UAAtaX-Eo"
  },
  "message_id": 91361
}';
*/
if (!$update) {
	// receive wrong update, must not happen
	exit;
}

if (isset($update["message"])) {
	processMessage($update["message"]);
}

?>
