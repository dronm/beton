/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017 - 2024
 
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_js20.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * @class
 * @classdesc controller
 
 * @extends ControllerObjClient
  
 * @requires core/extend.js
 * @requires core/ControllerObjClient.js
  
 * @param {Object} options
 * @param {Model} options.listModelClass
 * @param {Model} options.objModelClass
 */ 

function AuditLogChange_Controller(options){
	options = options || {};
	options.listModelClass = AuditLogChange_Model;
	options.objModelClass = AuditLogChange_Model;
	AuditLogChange_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
		
}
extend(AuditLogChange_Controller,ControllerObjClient);

			AuditLogChange_Controller.prototype.addGetList = function(){
	AuditLogChange_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("col",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("alias",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("new",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("new_descr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("old",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("old_descr",f_opts));
}

			AuditLogChange_Controller.prototype.addGetObject = function(){
	AuditLogChange_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldString("col",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		
