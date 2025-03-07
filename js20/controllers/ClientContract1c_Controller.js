/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017 - 2024
 
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_js20.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * @class
 * @classdesc controller
 
 * @extends ControllerObjServer
  
 * @requires core/extend.js
 * @requires core/ControllerObjServer.js
  
 * @param {Object} options
 * @param {Model} options.listModelClass
 * @param {Model} options.objModelClass
 */ 

function ClientContract1c_Controller(options){
	options = options || {};
	options.listModelClass = ClientDebtList_Model;
	options.objModelClass = ClientDebtList_Model;
	ClientContract1c_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
	this.add_complete_from_1c();
		
}
extend(ClientContract1c_Controller,ControllerObjServer);

			ClientContract1c_Controller.prototype.addGetList = function(){
	ClientContract1c_Controller.superclass.addGetList.call(this);
	
	
	
	var pm = this.getGetList();
	
	pm.addField(new FieldInt(this.PARAM_COUNT));
	pm.addField(new FieldInt(this.PARAM_FROM));
	pm.addField(new FieldString(this.PARAM_COND_FIELDS));
	pm.addField(new FieldString(this.PARAM_COND_SGNS));
	pm.addField(new FieldString(this.PARAM_COND_VALS));
	pm.addField(new FieldString(this.PARAM_COND_ICASE));
	pm.addField(new FieldString(this.PARAM_ORD_FIELDS));
	pm.addField(new FieldString(this.PARAM_ORD_DIRECTS));
	pm.addField(new FieldString(this.PARAM_FIELD_SEP));
	pm.addField(new FieldString(this.PARAM_FIELD_LSN));

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("firm_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("firms_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_contract_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("client_contracts_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("debt_total",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDate("update_date",f_opts));
}

			ClientContract1c_Controller.prototype.addGetObject = function(){
	ClientContract1c_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ClientContract1c_Controller.prototype.add_complete_from_1c = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_from_1c',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		options.maxlength = "36";
	
		pm.addField(new FieldString("client_ref_1c",options));
	
				
	
	var options = {};
	
		options.maxlength = "100";
	
		pm.addField(new FieldString("search",options));
	
			
	this.addPublicMethod(pm);
}

		