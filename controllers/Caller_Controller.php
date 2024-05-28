<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtArray.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBytea.php');

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */



//Asterisk
require_once 'common/Caller.php';

require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

require_once(ABSOLUTE_PATH.'domru/DOMRuIntegration.php');

require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');

class Caller_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);
			
		$pm = new PublicMethod('call');
		
				
	$opts=array();
	
		$opts['length']=15;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function call($pm){
	
		$asterisk = (defined('AST_SERVER')&&defined('AST_PORT')&&defined('AST_USER')&&defined('AST_PASSWORD'));
		$dom_ru = (defined('DOMRU_URL')&&defined('DOMRU_TOKEN'));

		$ext = $_SESSION['tel_ext'];
		$tel = $this->getExtVal($pm,'tel');
		
		if(isset($ext) && $asterisk){			
			$caller = new Caller(AST_SERVER,AST_PORT,AST_USER,AST_PASSWORD);
			$caller->call($ext,$tel);	
		
		}else if(isset($ext) && $dom_ru){
			$caller = new DOMRuIntegration(DOMRU_TOKEN, DOMRU_URL);
			$call_id = $caller->makeCall($ext, $tel);
			
			if($call_id && strlen($call_id)){
				$this->addModel(new ModelVars(
					array('name'=>'Vars',
						'id'=>'Call_Model',
						'values'=>[new Field('call_id',DT_STRING,array('value'=>$call_id))]
						)
					)
				);		
			}
		}else{
			throw new Exception('Нет настроек телефонии!');
		}
	
	}

}
?>
