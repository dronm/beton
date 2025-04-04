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

function OperatorForTranspNakl_Controller(options){
	options = options || {};
	options.listModelClass = OperatorForTranspNaklList_Model;
	options.objModelClass = OperatorForTranspNaklList_Model;
	OperatorForTranspNakl_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(OperatorForTranspNakl_Controller,ControllerObjServer);

			OperatorForTranspNakl_Controller.prototype.addInsert = function(){
	OperatorForTranspNakl_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	
}

			OperatorForTranspNakl_Controller.prototype.addUpdate = function(){
	OperatorForTranspNakl_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_user_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	
}

			OperatorForTranspNakl_Controller.prototype.addDelete = function(){
	OperatorForTranspNakl_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("user_id",options));
}

			OperatorForTranspNakl_Controller.prototype.addGetList = function(){
	OperatorForTranspNakl_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("production_site_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("production_sites_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("users_ref",f_opts));
}

			OperatorForTranspNakl_Controller.prototype.addGetObject = function(){
	OperatorForTranspNakl_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("user_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		