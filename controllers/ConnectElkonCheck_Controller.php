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


class ConnectElkonCheck_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('connected');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('base_id',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function connected($pm){

		$base_id = $pm->getParamValue('base_id')? $this->getExtDbVal($pm,'base_id'):0;
		$this->addNewModel(
			sprintf("SELECT DISTINCT ON (el.production_site_id) 
				el.production_site_id,
				elkon_connect_err(el.message, el.date_time) AS pong
			FROM elkon_log AS el
			LEFT JOIN production_sites AS ps ON ps.id = el.production_site_id
			WHERE %d = 0 OR ps.production_base_id = %d
			ORDER BY 
				el.production_site_id, 
				el.date_time DESC"
		,$base_id, $base_id)
		,'ConnectElkon_Model'		
		);
	}

}
?>