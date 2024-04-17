<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class RoleViewRestriction_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("role_view_restrictions");
			
		//*** Field role_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Роль';
		$f_opts['id']="role_id";
						
		$f_role_id=new FieldSQLEnum($this->getDbLink(),$this->getDbName(),$this->getTableName(),"role_id",$f_opts);
		$this->addField($f_role_id);
		//********************
		
		//*** Field back_days_allowed ***
		$f_opts = array();
		
		$f_opts['alias']='Сколько дней разрешено для просмотра назад';
		$f_opts['id']="back_days_allowed";
						
		$f_back_days_allowed=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"back_days_allowed",$f_opts);
		$this->addField($f_back_days_allowed);
		//********************
		
		//*** Field front_days_allowed ***
		$f_opts = array();
		
		$f_opts['alias']='Сколько дней разрешено для просмотра вперед';
		$f_opts['id']="front_days_allowed";
						
		$f_front_days_allowed=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"front_days_allowed",$f_opts);
		$this->addField($f_front_days_allowed);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_role_id,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
