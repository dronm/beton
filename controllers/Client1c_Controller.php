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



require_once(ABSOLUTE_PATH.'functions/exch1c.php');

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
		$search = $this->getExtVal($pm, "search");
		$clients = Exch1c::catalogByAttr('clients', $search);
		$model = new Model(array("id"=>"Client1cList_Model"));
		foreach($clients as $client){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $client["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $client["name"])));
			array_push($fields, new Field('inn',DT_STRING,array('value'=>(string) $client["inn"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		
	}

	public function get_leasor_on_pp($pm){
		throw new Exception("Not implemented");
		
	}

}
?>