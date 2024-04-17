<?php
//rejected this method because of low speed execution of about 250ms vs 30ms native
session_start();

require_once('db_con_f.php');
require_once(FRAME_WORK_PATH.'Constants.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelServResponse.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');

if (count($argv) < 3){
	die("Arguments: sess_data_file, param_data_file");
}

$sess_data = file_get_contents($argv[1]);
if ($sess_data === FALSE){
	die("error opening session data file");
}

$param_data = file_get_contents($argv[2]);
if ($param_data === FALSE){
	die("error opening param data file");
}

$lines = explode(PHP_EOL, $param_data);
foreach($lines as $l){
	$p = strpos($l, "=");
	$key = substr($l, 0, $p);
	$val = substr($l, $p+1);
	$_REQUEST[$key] = $val;
}

session_decode($sess_data);
$conn = db_con();

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
		$contrObj->write($view_class, $view);
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
	
	$contrObj->write($view,$view,$resp->result);
}

?>
