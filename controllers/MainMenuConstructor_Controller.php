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



require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

class MainMenuConstructor_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Содержание';
			
				$f_params['required']=TRUE;
			$param = new FieldExtText('content'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Содержание для модели,заполняется при записи из контроллера!';
			
				$f_params['required']=FALSE;
			$param = new FieldExtText('model_content'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('MainMenuConstructor.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('MainMenuConstructor_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			
				$f_params['alias']='Код';
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Содержание';
			$param = new FieldExtText('content'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Содержание для модели,заполняется при записи из контроллера!';
			$param = new FieldExtText('model_content'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			
				'alias'=>'Код'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('MainMenuConstructor.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('MainMenuConstructor_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('MainMenuConstructor.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('MainMenuConstructor_Model');

			
		/* get_list */
		$pm = new PublicMethod('get_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);
		
		$this->setListModelId('MainMenuConstructorList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('MainMenuConstructorDialog_Model');		

		
	}	
	

	public function genMenuForUser($userId,$roleId){
		$pm = new PublicMethod('update');
		$pm->addParam(new FieldExtString('content'));
		$pm->addParam(new FieldExtInt('user_id'));
		$pm->addParam(new FieldExtInt('role_id'));
	
		$id = $this->getDbLink()->query(sprintf(
			"SELECT * FROM main_menus WHERE user_id=%d
			UNION ALL
			SELECT * FROM main_menus WHERE user_id=%d AND role_id='%s'
			UNION ALL
			SELECT * FROM main_menus WHERE role_id='%s'",
			$userId,
			$userId,$roleId,
			$roleId
		));
		while($ar = $this->getDbLink()->fetch_array($id)){
			$this->gen_menu($pm,$ar['id']);
		}
	}

	/**
	 * From 20/04/21 returns XML!!!
	 * !!!model_content!!!
	 */
	private function gen_menu($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
				
		$content = $p->getVal('content');
		$old_id = $p->getDbVal('old_id');
		if (!isset($content) && isset($old_id)){
			$ar = $this->getDbLink()->query_first(sprintf(
				"SELECT content FROM main_menus WHERE id=%d"
				,$old_id
			));
			
			if(!is_array($ar) || !count($ar) || !isset($ar['content'])){
				throw new Exception('Content not found!');
			}
			$content = $ar['content'];
			
		}else if(!isset($content)){
			throw new Exception('Empty content!');
		}
		$content = html_entity_decode($content);	
		
		/*
		$user_id = $p->getVal('user_id');
		$role_id = $p->getVal('role_id');
		if (!isset($content) || !isset($user_id) || !isset($role_id)){
			$id = $p->getDbVal('old_id');
			$id = (isset($id))? $id:$newId;
			//update content wasnt changed, so it does not exist
			$ar = $this->getDbLink()->query_first(sprintf("SELECT content,user_id,role_id FROM main_menus WHERE id=%s",$id));
			$content = (isset($content))? html_entity_decode($content):$ar['content'];
			$user_id = (isset($user_id))? $user_id:$ar['user_id'];
			$role_id = (isset($role_id))? $role_id:$ar['role_id'];
		}
		else{
			$content = html_entity_decode($content);
		}
		*/
		
		//!!!XMLNS!!!
		$content = str_replace('xmlns="http://www.w3.org/1999/xhtml"','',$content);
		$content = str_replace('xmlns="http://www.katren.org/crm/doc/mainmenu"','',$content);		
//file_put_contents(OUTPUT_PATH.'menu.xml', $content);
		$xml = simplexml_load_string($content);
		if($xml === FALSE) {
			throw new Exception('XML not valid');
		}
		$items = $xml->xpath('//menuitem[@viewid]');
		$sql = '';
		foreach($items as $item){
			$id = $item->attributes()->viewid;
			if (!isset($id)||$id=='')continue;
			$sql.=($sql=='')? '':',';
			$sql.=sprintf(
				'(SELECT
					CASE WHEN v.c IS NOT NULL THEN \'c="\'||v.c||\'"\' ELSE \'\' END
					||CASE WHEN v.f IS NOT NULL THEN CASE WHEN v.c IS NULL THEN \'\' ELSE \' \' END||\'f="\'||v.f||\'"\' ELSE \'\' END
					||CASE WHEN v.t IS NOT NULL THEN CASE WHEN v.c IS NULL AND v.f IS NULL THEN \'\' ELSE \' \' END||\'t="\'||v.t||\'"\' ELSE \'\' END
					||CASE WHEN v.limited IS NOT NULL AND v.limited THEN CASE WHEN v.c IS NULL AND v.f IS NULL AND v.t IS NULL THEN \'\' ELSE \' \' END||\'limit="TRUE"\' ELSE \'\' END
				FROM views v WHERE v.id=%s) AS view_%s',
				$id,$id
			);
		}
		
		$ar = $this->getDbLink()->query_first("SELECT ".$sql);
		foreach($ar as $f=>$v){
			list($view_t, $view_id) = explode('_',$f);
			$content = str_replace(sprintf('viewid="%s"',$view_id),$v,$content);
			$content = str_replace(sprintf('viewid ="%s"',$view_id),$v,$content);
			$content = str_replace(sprintf('viewid= "%s"',$view_id),$v,$content);
			$content = str_replace(sprintf('viewid = "%s"',$view_id),$v,$content);
		}
		
		return $content;
		
		/*
		 * From 20/04/21 MainMenus are generated from DB only due to multy server structure
		 
		$postf = ( (isset($role_id))? '_'.$role_id:'' ).( (isset($user_id))? '_'.$user_id:'' ); 		
		//USER_MODELS_PATH
		file_put_contents(
			OUTPUT_PATH.'MainMenu_Model'. $postf. '.php',
			sprintf('<?php
require_once(FRAME_WORK_PATH.\'basic_classes/Model.php\');

class MainMenu_Model%s extends Model{
	public function dataToXML(){
		return \'<model id="MainMenu_Model" sysModel="1">
		%s
		</model>\';
	}
}
?>',$postf,$content));
*/

	}

	public function insert($pm){	
		$pm->setParamValue('model_content', $this->gen_menu($pm));
		parent::insert($pm);		
	}
	public function update($pm){
		$pm->setParamValue('model_content', $this->gen_menu($pm));
		parent::update($pm);	
	}

	/*
	* From 20/04/21 MainMenus are generated from DB only due to multy server structure
	* !!!model_content!!!
	public function delete($pm){
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT user_id,role_id FROM main_menus
			WHERE id=%s",
		$this->getExtDbVal($pm,"id")
		));
		
		$postf = ( (isset($ar['role_id']))? '_'.$ar['role_id']:'' ).( (isset($ar['user_id']))? '_'.$ar['user_id']:'' ); 		
		$fl = OUTPUT_PATH.'MainMenu_Model'. $postf. '.php';
		if (file_exists($fl)){
			unlink($fl);
		}
		parent::delete($pm);
	}
	*/
	

}
?>