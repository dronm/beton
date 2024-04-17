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
 
class ContactList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("contacts_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field posts_ref ***
		$f_opts = array();
		$f_opts['id']="posts_ref";
						
		$f_posts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"posts_ref",$f_opts);
		$this->addField($f_posts_ref);
		//********************
		
		//*** Field email ***
		$f_opts = array();
		
		$f_opts['alias']='Email';
		$f_opts['id']="email";
						
		$f_email=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"email",$f_opts);
		$this->addField($f_email);
		//********************
		
		//*** Field tel ***
		$f_opts = array();
		
		$f_opts['alias']='Телефон';
		$f_opts['id']="tel";
						
		$f_tel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tel",$f_opts);
		$this->addField($f_tel);
		//********************
		
		//*** Field tel_ext ***
		$f_opts = array();
		
		$f_opts['alias']='Добавочный номер';
		$f_opts['id']="tel_ext";
						
		$f_tel_ext=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tel_ext",$f_opts);
		$this->addField($f_tel_ext);
		//********************
		
		//*** Field descr ***
		$f_opts = array();
		
		$f_opts['alias']='Описание для поиска';
		$f_opts['id']="descr";
						
		$f_descr=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"descr",$f_opts);
		$this->addField($f_descr);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий';
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field tm_photo ***
		$f_opts = array();
		$f_opts['id']="tm_photo";
						
		$f_tm_photo=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_photo",$f_opts);
		$this->addField($f_tm_photo);
		//********************
		
		//*** Field tm_first_name ***
		$f_opts = array();
		$f_opts['id']="tm_first_name";
						
		$f_tm_first_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_first_name",$f_opts);
		$this->addField($f_tm_first_name);
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
		
		//*** Field ext_id ***
		$f_opts = array();
		$f_opts['id']="ext_id";
						
		$f_ext_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ext_id",$f_opts);
		$this->addField($f_ext_id);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_descr,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
