<?php
//rejected this method because of low speed execution of about 150ms vs 30ms native

require_once('db_con_f.php');
require_once(FRAME_WORK_PATH.'Constants.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelServResponse.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');

error_reporting(E_ALL);

//ob_start();
session_start();

/* Allow the script to hang around waiting for connections. */
set_time_limit(0);

/* Turn on implicit output flushing so we see what we're getting
 * as it comes in. */
ob_implicit_flush();

$address = '192.168.1.3';
$port = 59200;

if (($sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) === false) {
    echo "socket_create() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
}

if (socket_bind($sock, $address, $port) === false) {
    echo "socket_bind() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
}

if (socket_listen($sock, 5) === false) {
    echo "socket_listen() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
}

do {
	if (($msgsock = socket_accept($sock)) === false) {
		echo "socket_accept() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
		break;
	}
	echo "got connection".PHP_EOL;
	
	do {
		if (false === ($buf = socket_read($msgsock, 2048, PHP_NORMAL_READ))) {
			echo "socket_read() failed: reason: " . socket_strerror(socket_last_error($msgsock)) . "\n";
			break;
		}
		if (!$buf = trim($buf)) {
			continue;
		}

		$pid = pcntl_fork();
		if ($pid == -1) {
			socket_write( $msgsock, pack("l", 0));
			exit;
		} else if ($pid) {
			continue;
		}

		//child
		
		echo 'Command:'.$buf.PHP_EOL;
		
		$parts = explode(" ", $buf);
		if(count($parts) < 2){
			//internal error
			socket_write( $msgsock, pack("l", 0));
			exit;
		}
		
		$params = explode("$$", $parts[1]);
		$response = handlePublicMethod($parts[0], $params);
		/*
		$response = '<?xml version="1.0" encoding="UTF-8"?><document><model id="ModelServResponse" sysModel="1"
		rowsPerPage="0" listFrom="0" totalCount="0"><row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><result>0</result><descr xsi:nil="true"/>
		<app_version>1.00314</app_version></row></model>
		</document>';
		*/
		
		$talk_len = is_null($response)? 0 : strlen($response);
		socket_write( $msgsock, pack("l", $talk_len)); //packet length
		if($talk_len){
			socket_write($msgsock, $response, $talk_len);  //packet
		}
		exit;
		
	} while (true);
	socket_close($msgsock);
} while (true);

socket_close($sock);

function handlePublicMethod($sessFile, $queryParams){
	$sess_data = file_get_contents($sessFile);
		
	session_decode($sess_data);
	$conn = db_con();

	foreach($queryParams as $l){
		$p = strpos($l, "=");
		$key = substr($l, 0, $p);
		$val = substr($l, $p+1);
		$_REQUEST[$key] = $val;
		echo 'Adding param '.$key.' val='.$val.PHP_EOL;
	}

	$response = NULL;
	try{
		$start_time = microtime(true); 
		
		$contr = $_REQUEST[PARAM_CONTROLLER];
		$meth = $_REQUEST[PARAM_METHOD];	
		$view = $_REQUEST[PARAM_VIEW];

		//controller
		require_once(USER_CONTROLLERS_PATH.$contr.'.php');
		$contrObj = new $contr($conn, $conn);

		if (is_null($view)){
			$def_view = $contrObj->getDefaultView();
			$view = (isset($def_view))? $def_view:DEF_VIEW;
			if (!isset($view)){
				throw new Exception(ERR_COM_NO_VIEW);
			}	
		}
		$view_class = $view;

		//view
		if (!file_exists($v_script=USER_VIEWS_PATH.$view.'.php')){	
			$path_ar = explode(PATH_SEPARATOR, get_include_path());	
			$framework_absolute_path = (count($path_ar)>=1)? $path_ar[1].'/'.FRAME_WORK_PATH.'basic_classes/':NULL;
			
			$v_script = !is_null($framework_absolute_path)? $framework_absolute_path.$view.'.php' : USER_VIEWS_PATH.$view.'.php';
			if (!file_exists($v_script)){	
				if (file_exists($v_script=USER_VIEWS_PATH.DEF_VIEW.'.php')){
					$view_class = DEF_VIEW;
				}
				else{
					throw new Exception(ERR_COM_NO_VIEW);
				}
			}
		}
		
		require_once($v_script);
		if (!$contrObj->runPublicMethod($meth, $_REQUEST)){
			$response = write($contrObj, $view_class, $view);
		}
		echo "Execution=".(microtime(true) - $start_time)." sec".PHP_EOL; 
		
	}catch (Exception $e){
		if (defined('PARAM_TEMPLATE')){
			unset($_REQUEST[PARAM_TEMPLATE]);
		}
		$contrObj = new Controller($conn, $conn);	
		$resp = new ModelServResponse();				
		$contrObj->addModel($resp);	
		$ar = explode('@',$e->getMessage());
		$resp->result = (count($ar)>1)? intval($ar[1]) : 1;
		if ($resp->result==0){
			$resp->result = 1;
		}
		if (count($ar)){		
			//$resp->descr = htmlspecialchars(str_replace("exception 'Exception' with message",'','111='.$ar[0]));		
			$er_s = str_replace('ОШИБКА: ','',$ar[0]);//ошибки postgre
			$er_s = str_replace("exception 'Exception' with message '",'',$er_s);
			$resp->descr = $er_s;//htmlspecialchars($er_s,ENT_XML1,'UTF-8',FALSE);//
		}
		else{
			$resp->descr = $e->getMessage();//htmlspecialchars($e->getMessage(),ENT_XML1,'UTF-8',FALSE);
		}
		
		$view = (isset($_REQUEST[PARAM_VIEW]))? $_REQUEST[PARAM_VIEW]:DEF_VIEW;
		
		if (!isset($v_script)){
			//not included yet
			if (!file_exists($v_script=USER_VIEWS_PATH.$view.'.php')){	
				$pathArray = explode(PATH_SEPARATOR, get_include_path());	
				$v_script = (count($pathArray)>=1)?
					$pathArray[1].'/'.FRAME_WORK_PATH.'basic_classes/'.$view.'.php' :
					USER_VIEWS_PATH.$view.'.php';
			}
			if (file_exists($v_script)){
				require_once($v_script);		
			}
		}
		
		$response = write($contrObj, $view, $view, $resp->result);
	}
	return $response;
}

function write($contrObj, $viewClassId, $viewId, $errorCode=NULL){
	$view = new $viewClassId($viewId);
	if ($contrObj->getStatelessClient()){
		$contrObj->setStateVars($view);
	}
	
	/* if template is requested it is returned with any method*/
	if (defined('PARAM_TEMPLATE') && isset($_REQUEST[PARAM_TEMPLATE])){
		$tmpl = $_REQUEST[PARAM_TEMPLATE]; 
		if (
		(isset($_SESSION['role_id']) && file_exists($file = USER_TMPL_PATH. $tmpl.'.'.$_SESSION['role_id']. '.html') )
		|| (file_exists($file = USER_TMPL_PATH. $tmpl. '.html') )
		)
		{
			$text = file_get_contents($file);
			if (mb_detect_encoding($text,"UTF-8,iso-8859-1",TRUE)!="UTF-8" ){
				$text = iconv("iso-8859-1","UTF-8",$text);
			}
			
			$contrObj->addModel(new ModelTemplate($tmpl,$text));
		}
	}		
	
	$m = $contrObj->getModels();
	//throw new Exception("@@er_code=".$errorCode);	
	return $view->write($m, $errorCode);
}

?>
