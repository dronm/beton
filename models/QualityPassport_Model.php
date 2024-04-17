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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
 
class QualityPassport_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("quality_passports");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field f_val ***
		$f_opts = array();
		
		$f_opts['alias']='F';
		$f_opts['id']="f_val";
						
		$f_f_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"f_val",$f_opts);
		$this->addField($f_f_val);
		//********************
		
		//*** Field w_val ***
		$f_opts = array();
		
		$f_opts['alias']='W';
		$f_opts['id']="w_val";
						
		$f_w_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"w_val",$f_opts);
		$this->addField($f_w_val);
		//********************
		
		//*** Field vid_smesi_gost ***
		$f_opts = array();
		
		$f_opts['alias']='Гост вида смеси';
		$f_opts['id']="vid_smesi_gost";
						
		$f_vid_smesi_gost=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vid_smesi_gost",$f_opts);
		$this->addField($f_vid_smesi_gost);
		//********************
		
		//*** Field uklad ***
		$f_opts = array();
		
		$f_opts['alias']='Место укладки';
		$f_opts['id']="uklad";
						
		$f_uklad=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"uklad",$f_opts);
		$this->addField($f_uklad);
		//********************
		
		//*** Field sohran_udobouklad ***
		$f_opts = array();
		$f_opts['id']="sohran_udobouklad";
						
		$f_sohran_udobouklad=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sohran_udobouklad",$f_opts);
		$this->addField($f_sohran_udobouklad);
		//********************
		
		//*** Field kf_prochnosti ***
		$f_opts = array();
		$f_opts['id']="kf_prochnosti";
						
		$f_kf_prochnosti=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"kf_prochnosti",$f_opts);
		$this->addField($f_kf_prochnosti);
		//********************
		
		//*** Field prochnost ***
		$f_opts = array();
		$f_opts['id']="prochnost";
						
		$f_prochnost=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"prochnost",$f_opts);
		$this->addField($f_prochnost);
		//********************
		
		//*** Field naim_dobavki ***
		$f_opts = array();
		$f_opts['id']="naim_dobavki";
						
		$f_naim_dobavki=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"naim_dobavki",$f_opts);
		$this->addField($f_naim_dobavki);
		//********************
		
		//*** Field aeff ***
		$f_opts = array();
		$f_opts['id']="aeff";
						
		$f_aeff=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"aeff",$f_opts);
		$this->addField($f_aeff);
		//********************
		
		//*** Field krupnost ***
		$f_opts = array();
		$f_opts['id']="krupnost";
						
		$f_krupnost=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"krupnost",$f_opts);
		$this->addField($f_krupnost);
		//********************
		
		//*** Field vidan ***
		$f_opts = array();
		$f_opts['id']="vidan";
						
		$f_vidan=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vidan",$f_opts);
		$this->addField($f_vidan);
		//********************
		
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field smes_num ***
		$f_opts = array();
		$f_opts['id']="smes_num";
						
		$f_smes_num=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"smes_num",$f_opts);
		$this->addField($f_smes_num);
		//********************
		
		//*** Field order_id ***
		$f_opts = array();
		$f_opts['id']="order_id";
						
		$f_order_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_id",$f_opts);
		$this->addField($f_order_id);
		//********************
		
		//*** Field client_id ***
		$f_opts = array();
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field reg_nomer_dekl ***
		$f_opts = array();
		$f_opts['id']="reg_nomer_dekl";
						
		$f_reg_nomer_dekl=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"reg_nomer_dekl",$f_opts);
		$this->addField($f_reg_nomer_dekl);
		//********************
		
		//*** Field concrete_type_id ***
		$f_opts = array();
		$f_opts['id']="concrete_type_id";
						
		$f_concrete_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_type_id",$f_opts);
		$this->addField($f_concrete_type_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
