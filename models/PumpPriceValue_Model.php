<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class PumpPriceValue_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("pump_prices_values");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field pump_price_id ***
		$f_opts = array();
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="pump_price_id";
						
		$f_pump_price_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_price_id",$f_opts);
		$this->addField($f_pump_price_id);
		//********************
		
		//*** Field quant_from ***
		$f_opts = array();
		$f_opts['length']=19;
		$f_opts['id']="quant_from";
						
		$f_quant_from=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_from",$f_opts);
		$this->addField($f_quant_from);
		//********************
		
		//*** Field quant_to ***
		$f_opts = array();
		$f_opts['length']=19;
		$f_opts['id']="quant_to";
						
		$f_quant_to=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_to",$f_opts);
		$this->addField($f_quant_to);
		//********************
		
		//*** Field price_m ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="price_m";
						
		$f_price_m=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"price_m",$f_opts);
		$this->addField($f_price_m);
		//********************
		
		//*** Field price_fixed ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="price_fixed";
						
		$f_price_fixed=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"price_fixed",$f_opts);
		$this->addField($f_price_fixed);
		//********************
		
		//*** Field price_garanteed ***
		$f_opts = array();
		
		$f_opts['alias']='Гарантированная сумма (если установлено, и объем превышает, то сначала эта сумма, а потом по шкале остаток кубов)';
		$f_opts['defaultValue']='FALSE';
		$f_opts['id']="price_garanteed";
						
		$f_price_garanteed=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"price_garanteed",$f_opts);
		$this->addField($f_price_garanteed);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_quant_from,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
