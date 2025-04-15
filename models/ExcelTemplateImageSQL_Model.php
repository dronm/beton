<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class ExcelTemplateImageSQL_Model extends {
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		$f_opts['length']=100;
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field sql_query ***
		$f_opts = array();
		$f_opts['length']=5000;
		$f_opts['id']="sql_query";
						
		$f_sql_query=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sql_query",$f_opts);
		$this->addField($f_sql_query);
		//********************
		
		//*** Field w ***
		$f_opts = array();
		$f_opts['id']="w";
						
		$f_w=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"w",$f_opts);
		$this->addField($f_w);
		//********************
		
		//*** Field h ***
		$f_opts = array();
		$f_opts['id']="h";
						
		$f_h=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"h",$f_opts);
		$this->addField($f_h);
		//********************
		
		//*** Field offset_x ***
		$f_opts = array();
		$f_opts['id']="offset_x";
						
		$f_offset_x=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"offset_x",$f_opts);
		$this->addField($f_offset_x);
		//********************
		
		//*** Field offset_y ***
		$f_opts = array();
		$f_opts['id']="offset_y";
						
		$f_offset_y=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"offset_y",$f_opts);
		$this->addField($f_offset_y);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['length']=5000;
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
