<?php
//http://localhost/beton_new/functions/executer.php?c=User_Controller&v=ViewXML&f=get_list

require_once(dirname(__FILE__).'/../Config.php');
require_once('db_con_f.php');
require_once(FRAME_WORK_PATH.'Constants.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelServResponse.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');

$conn = db_con();

try{
	//Accept-Language
	//$_SERVER['HTTP_ACCEPT_LANGUAGE'] = 

	//Connection:
	//$_SERVER['HTTP_CONNECTION

	//Host:
	//$_SERVER['HTTP_HOST

	//User-Agent:
	//$_SERVER['HTTP_USER_AGENT

	//$_SERVER['REMOTE_ADDR

	//****
	//$_REQUEST

	//$_SESSION

	$contr = $_REQUEST[PARAM_CONTROLLER];
	$meth = $_REQUEST[PARAM_METHOD];	
	$view = $_REQUEST[PARAM_VIEW];

	//controller
	require_once(USER_CONTROLLERS_PATH.$contr.'.php');
	$contrObj = new $contr($conn, $conn);

	/* view checking*/
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
		/*if nothing has been sent yet - default output*/
		$contrObj->write($view_class, $view);
	}

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
