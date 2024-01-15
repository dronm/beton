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
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class ProgUpdateDetail_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("prog_update_details");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field code ***
		$f_opts = array();
		
		$f_opts['alias']='Код сортирвки';
		$f_opts['id']="code";
						
		$f_code=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"code",$f_opts);
		$this->addField($f_code);
		//********************
		
		//*** Field prog_update_id ***
		$f_opts = array();
		
		$f_opts['alias']='Обновление';
		$f_opts['id']="prog_update_id";
						
		$f_prog_update_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"prog_update_id",$f_opts);
		$this->addField($f_prog_update_id);
		//********************
		
		//*** Field description ***
		$f_opts = array();
		
		$f_opts['alias']='Описание';
		$f_opts['id']="description";
						
		$f_description=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"description",$f_opts);
		$this->addField($f_description);
		//********************
		
		//*** Field description_tech ***
		$f_opts = array();
		
		$f_opts['alias']='Техническое описание';
		$f_opts['id']="description_tech";
						
		$f_description_tech=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"description_tech",$f_opts);
		$this->addField($f_description_tech);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_code,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
