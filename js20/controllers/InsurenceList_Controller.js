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

function InsurenceList_Controller(options){
	options = options || {};
	options.listModelClass = InsurenceList_Model;
	options.objModelClass = InsurenceList_Model;
	InsurenceList_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(InsurenceList_Controller,ControllerObjClient);

			InsurenceList_Controller.prototype.addInsert = function(){
	InsurenceList_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("dt_from",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("dt_to",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("issuer",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			InsurenceList_Controller.prototype.addUpdate = function(){
	InsurenceList_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("dt_from",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("dt_to",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("issuer",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	
}

			InsurenceList_Controller.prototype.addDelete = function(){
	InsurenceList_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			InsurenceList_Controller.prototype.addGetList = function(){
	InsurenceList_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDate("dt_from",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDate("dt_to",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("issuer",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("total",f_opts));
}

			InsurenceList_Controller.prototype.addGetObject = function(){
	InsurenceList_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		