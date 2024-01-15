<?php
require_once('common/telegram.php');

define('TM_APP_NAME', 'bereg');

//ключ авторизации со своим скриптом для входящих сообщений
define('IN_MSG_AUTH_KEY', 'a32544fa-c680-11eb-b8bc-0242ac130003');

function log_tm_error($dbTMConn, $appId, $token, $chatId, $t){
	
	try{
		$dbTMConn->query(sprintf(
			"SELECT public.logger_add(row(NULL, now(), %d, '%s', 0, 'tm', 1)::logger)",
			$appId, $t
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
file_put_contents('log/log.txt','text='.$text.PHP_EOL,FILE_APPEND);

		if (strpos($text, "/start") === 0) {
			try{
				apiRequestJson($tm_params['token'], "sendMessage",
					array(
						'chat_id' => $chat_id,
						"text" => 'starting'
					),
					FALSE
				);
				
			}catch(Exception $e){
				log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
			}
			
		
		} else if (strpos($text, "/stop") === 0) {
			// stop now
			apiRequestJson($tm_params['token'], "sendMessage",
				array(
					'chat_id' => $chat_id,
					"text" => sprintf('Пользователен %s удален.',$message['from']['first_name'])
				),
				FALSE
			);
			
		} else if (strpos($text, "/cmd1") === 0) {
				apiRequestJson($tm_params['token'], "sendMessage",
					array('chat_id' => $chat_id,
						'parse_mode' => 'HTML',
						"text" => '<i>Заказ</i>',
						'reply_markup' => array(
							//Кнопки с колбаками
							'inline_keyboard' => array(
								array(
									array(
										'text' => 'Кнопка1',
										'callback_data' => 'Кнопка1'
									)
									,array(
										'text' => 'Кнопка2',
										'callback_data' => 'Кнопка12'
									)
									,array(
										'text' => 'Файл',
										'callback_data' => 'Файл'
									)
									
								)
							)
						)
					),
					FALSE
				);
		
		} else if (strpos($text, "/cmd2") === 0) {
				apiRequestJson($tm_params['token'], "sendMessage",
					array('chat_id' => $chat_id,
						'parse_mode' => 'HTML',
						"text" => '<i>Заказ</i>',
						'reply_markup' => array(
							//'one_time_keyboard' => TRUE,
							'keyboard' => array(
								array(
									array(
										'text' => 'Отправить местоположение',
										'request_location' => TRUE
									)
									,array(
										'text' => 'Отправить контакт',
										'request_contact' => TRUE
									)
									,array(
										'text' => 'Web app',
										'web_app' => array(
											'url' => 'https://eurobeton.katren.org/app/'
										)
									)
									
								)
							),
							'input_field_placeholder' => 'placeholder'
						)
					),
					FALSE
				);
		
			
		} else {
			try{					
				apiRequestJson($tm_params['token'], "sendMessage",
					array('chat_id' => $chat_id,
						'parse_mode' => 'HTML',
						"text" => '<i>italic</i>',
						'reply_markup' => array(
						)
					),
					FALSE
				);
				
			}catch(Exception $e){
				//log_tm_error($dbTMConn, $q_params['id'], $tm_params['token'], $chat_id, $e->getMessage());
				file_put_contents('log/log.txt','ERROR:'.$e->getMessage().PHP_EOL,FILE_APPEND);								
			}
		}
	} else if(isset($message['contact'])){
		apiRequest($tm_params['token'], "sendMessage",
			array(
				'chat_id' => $chat_id,
				"text" => 'Есть контакт '.$message['contact']['phone_number'],
				'reply_markup' => array(
					'remove_keyboard' => TRUE
				)				
			),
		FALSE);
	} else if(isset($message['location'])){
		apiRequest($tm_params['token'], "sendMessage",		
			array(
				'chat_id' => $chat_id,
				"text" => 'Есть локация '.$message['location']['latitude'].' '.$message['location']['longitude'],
				'reply_markup' => array(
					'remove_keyboard' => TRUE
				)				
			),
		FALSE);
	
	} else {
		apiRequest($tm_params['token'], "sendMessage", array('chat_id' => $chat_id, "text" => 'Обрабатываются только текстовые сообщения'),FALSE);
	}
}

if (php_sapi_name() == 'cli') {
	// if run from console, set or delete webhook
	if(!isset($argv) || !is_array($argv) || count($argv)<2){
		die('App name is not specified!');
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

//file_put_contents('log/log.txt',$content.PHP_EOL.PHP_EOL,FILE_APPEND);
if (!$update) {
	// receive wrong update, must not happen
	exit;
}

if (isset($update["message"])) {
file_put_contents('log/log.txt','*** message:'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);		
	processMessage($update["message"]);
	
}else if (isset($update["callback_query"])) {
	//Ответы на коллбаки
file_put_contents('log/log.txt','*** callback_query:'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);		
	/**
	 * данные $update["callback_query"]['data']
	 * ид запроса $update["callback_query"]['id']
	 */
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

	if($update["callback_query"]['data'] == 'Файл'){
		//curl -F "chat_id=1676023518" -F document=@/home/andrey/777.pdf https://api.telegram.org/bot5352972138:AAGZt9-_BvHDXjRwOWamEw0916-ab4BIN80/sendDocument
			$fl = '/home/andrey/elena/Pictures2/i-4706.jpg';
			$cmd = sprintf('curl -F "chat_id=1676023518" -F document=@%s https://api.telegram.org/bot5352972138:AAGZt9-_BvHDXjRwOWamEw0916-ab4BIN80/sendDocument',$fl);
file_put_contents('log/log.txt','CMD='.$cmd.PHP_EOL,FILE_APPEND);			
		exec($cmd);
		
		apiRequestJson($tm_params['token'], "answerCallbackQuery",
			array(
				'callback_query_id' => $update["callback_query"]['id'],
				"text" => 'Эдите файл...',
				'show_alert'=>FALSE
			),
			FALSE
		);
		
	}else{
		apiRequestJson($tm_params['token'], "answerCallbackQuery",
			array(
				'callback_query_id' => $update["callback_query"]['id'],
				"text" => $update["callback_query"]['data'],
				'show_alert'=>$update["callback_query"]['data']=='Кнопка1'
			),
			FALSE
		);
	}
	//
	
}else{
	file_put_contents('log/log.txt','UPDATE'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);	
}

?>
