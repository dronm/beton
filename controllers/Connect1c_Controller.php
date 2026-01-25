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

class Connect1c_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('complete_user');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_item');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_stop');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_start');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_health');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_status');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('production_report_export');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function complete_user($pm){		
		$search = $this->getExtVal($pm, "search");
		$users = Exch1c::catalogByAttr('users', $search);
		$model = new Model(array("id"=>"User1cList_Model"));
		foreach($users as $user){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $user["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $user["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		
	}

	public function complete_item($pm){		
		$search = $this->getExtVal($pm, "search");
		$users = Exch1c::catalogByAttr('items', $search);
		$model = new Model(array("id"=>"Item1cList_Model"));
		foreach($users as $user){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $user["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $user["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
	}

	private function add_result_model($res){		
		$res_json = json_encode($res, JSON_UNESCAPED_UNICODE);

		$model = new Model(array("id"=>"Result1c_Model"));
		$fields = [ new Field('obj',DT_STRING,array('value'=>(string) $res_json)) ];
		$model->insert($fields);
		$this->addModel($model);
	}

	public function service_stop($pm){		
		$res = Exch1c::stop();
		$this->add_result_model($res);
	}

	public function service_start($pm){		
		$res = Exch1c::start();
		$this->add_result_model($res);
	}

	public function service_status($pm){		
		$res = Exch1c::status();
		$this->add_result_model($res);
	}

	public function service_health($pm){		
		$res = Exch1c::health(); //returns string!
		$this->add_result_model(['response' => $res]);
	}

	public function production_report_export($pm){		
		$id = $this->getExtDbVal($pm, 'id');
		$link = $this->getDbLinkMaster();
		$res = self::exportProductionReport($link, $id);
		$this->add_result_model($res);
	}

	public static function exportProductionReport($dbLink, $id){		
		$ar = $dbLink->query_first(
			"SELECT 
				t.data_for_1c_current AS params
			FROM production_reports_dialog AS t
			WHERE t.id = $1", [$id]
		);
		if(!is_array($ar) || !count($ar)){
			throw new Exception("document not found");
		}
		$res = Exch1c::newProductionReport(json_decode($ar["params"], TRUE));

		$dbLink->query(
			"UPDATE production_reports SET 
				data_for_1c = $1,
				ref_1c = $2
			WHERE id = $3", 
			[ json_encode($ar["params"]), json_encode($res), $id ]
		);

		return $res;
	}


}
?>
