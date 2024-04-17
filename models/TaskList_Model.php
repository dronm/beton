<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class TaskList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("tasks_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Сотрудник, создавший';
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
		
		//*** Field to_user_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="to_user_id";
						
		$f_to_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"to_user_id",$f_opts);
		$this->addField($f_to_user_id);
		//********************
		
		//*** Field to_users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Сотрудник для кого создали';
		$f_opts['id']="to_users_ref";
						
		$f_to_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"to_users_ref",$f_opts);
		$this->addField($f_to_users_ref);
		//********************
		
		//*** Field task_importance_level_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="task_importance_level_id";
						
		$f_task_importance_level_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"task_importance_level_id",$f_opts);
		$this->addField($f_task_importance_level_id);
		//********************
		
		//*** Field task_importance_levels_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Уровень важности';
		$f_opts['id']="task_importance_levels_ref";
						
		$f_task_importance_levels_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"task_importance_levels_ref",$f_opts);
		$this->addField($f_task_importance_levels_ref);
		//********************
		
		//*** Field subject ***
		$f_opts = array();
		
		$f_opts['alias']='Тема';
		$f_opts['id']="subject";
						
		$f_subject=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"subject",$f_opts);
		$this->addField($f_subject);
		//********************
		
		//*** Field create_date_time ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="create_date_time";
						
		$f_create_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"create_date_time",$f_opts);
		$this->addField($f_create_date_time);
		//********************
		
		//*** Field till_date_time ***
		$f_opts = array();
		$f_opts['id']="till_date_time";
						
		$f_till_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"till_date_time",$f_opts);
		$this->addField($f_till_date_time);
		//********************
		
		//*** Field open_date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Просмотрена';
		$f_opts['id']="open_date_time";
						
		$f_open_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"open_date_time",$f_opts);
		$this->addField($f_open_date_time);
		//********************
		
		//*** Field close_date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Закрыта';
		$f_opts['id']="close_date_time";
						
		$f_close_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"close_date_time",$f_opts);
		$this->addField($f_close_date_time);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
