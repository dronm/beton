<?php
require_once('common/telegram.php');

define('TM_APP_NAME', 'bereg');

//ключ авторизации со своим скриптом для входящих сообщений
define('IN_MSG_AUTH_KEY', 'a32544fa-c680-11eb-b8bc-0242ac130003');

$content = file_get_contents("php://input");
$update = json_decode($content, TRUE);

//file_put_contents('log/log.txt',$content.PHP_EOL.PHP_EOL,FILE_APPEND);
if (!$update) {
	// receive wrong update, must not happen
	exit;
}

if (isset($update["message"])) {
	file_put_contents('log/log.txt','*** message:'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);		
	
}else if (isset($update["callback_query"])) {
	//Ответы на коллбаки
	file_put_contents('log/log.txt','*** callback_query:'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);		
	
}else{
	file_put_contents('log/log.txt','UPDATE'.PHP_EOL.var_export($update,TRUE).PHP_EOL,FILE_APPEND);	
}

?>
