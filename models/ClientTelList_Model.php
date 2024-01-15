<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ClientTelList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("client_tels_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field client_id ***
		$f_opts = array();
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='ФИО';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field tel ***
		$f_opts = array();
		
		$f_opts['alias']='Телефон';
		$f_opts['id']="tel";
						
		$f_tel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tel",$f_opts);
		$this->addField($f_tel);
		//********************
		
		//*** Field email ***
		$f_opts = array();
		
		$f_opts['alias']='Эл.почта';
		$f_opts['id']="email";
						
		$f_email=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"email",$f_opts);
		$this->addField($f_email);
		//********************
		
		//*** Field post ***
		$f_opts = array();
		
		$f_opts['alias']='Должность';
		$f_opts['id']="post";
						
		$f_post=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"post",$f_opts);
		$this->addField($f_post);
		//********************
		
		//*** Field search ***
		$f_opts = array();
		$f_opts['id']="search";
						
		$f_search=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"search",$f_opts);
		$this->addField($f_search);
		//********************
		
		//*** Field tm_exists ***
		$f_opts = array();
		$f_opts['id']="tm_exists";
						
		$f_tm_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_exists",$f_opts);
		$this->addField($f_tm_exists);
		//********************
		
		//*** Field tm_activated ***
		$f_opts = array();
		$f_opts['id']="tm_activated";
						
		$f_tm_activated=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_activated",$f_opts);
		$this->addField($f_tm_activated);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_search,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
