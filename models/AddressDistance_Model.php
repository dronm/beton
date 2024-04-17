<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
 
class AddressDistance_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("address_distances");
			
		//*** Field hash ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='address md5';
		$f_opts['length']=36;
		$f_opts['id']="hash";
						
		$f_hash=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"hash",$f_opts);
		$this->addField($f_hash);
		//********************
		
		//*** Field address ***
		$f_opts = array();
		
		$f_opts['alias']='Адрес';
		$f_opts['id']="address";
						
		$f_address=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"address",$f_opts);
		$this->addField($f_address);
		//********************
		
		//*** Field route ***
		$f_opts = array();
		$f_opts['id']="route";
						
		$f_route=new FieldSQLgeometry($this->getDbLink(),$this->getDbName(),$this->getTableName(),"route",$f_opts);
		$this->addField($f_route);
		//********************
		
		//*** Field distance ***
		$f_opts = array();
		
		$f_opts['alias']='Расстояние';
		$f_opts['length']=15;
		$f_opts['id']="distance";
						
		$f_distance=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"distance",$f_opts);
		$this->addField($f_distance);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
