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



require_once(ABSOLUTE_PATH.'functions/ExtProg.php');

class Client1c_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('search'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('Client1cList_Model');

			
		$pm = new PublicMethod('get_leasor_on_pp');
		
				
	$opts=array();
	
		$opts['length']=20;				
		$pm->addParam(new FieldExtString('pp_num',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function complete($pm){		
		$resp = ExtProg::getClientList($this->getExtVal($pm, "search"));
		//file_put_contents('output/qres.txt', $resp);
		//return as is
		ob_clean();
		header('Content-Type: application/json; charset=utf-8');
		echo json_encode($resp, JSON_UNESCAPED_UNICODE);
		return true;
	}

	public function get_leasor_on_pp($pm){
		$resp = ExtProg::getClientOnPP($this->getExtVal($pm, "pp_num"));
		file_put_contents('output/qres.txt', $resp);
		ob_clean();
		header('Content-Type: application/json; charset=utf-8');
		echo json_encode($resp, JSON_UNESCAPED_UNICODE);
		return true;
	}

}
?>