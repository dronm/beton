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

function AuditLog_Controller(options){
	options = options || {};
	options.listModelClass = AuditLogList_Model;
	options.objModelClass = AuditLogForObject_Model;
	AuditLog_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
		
}
extend(AuditLog_Controller,ControllerObjServer);

			AuditLog_Controller.prototype.addGetList = function(){
	AuditLog_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldJSON("object_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("table_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("record_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("operation",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("changed_at",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("changed_by",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("type_descr",f_opts));
}

			AuditLog_Controller.prototype.addGetObject = function(){
	AuditLog_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		