/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 
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

function TmUserList_Controller(options){
	options = options || {};
	options.listModelClass = TmUserList_Model;
	options.objModelClass = TmUserList_Model;
	TmUserList_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.addUpdate();
		
}
extend(TmUserList_Controller,ControllerObjServer);

			TmUserList_Controller.prototype.addGetList = function(){
	TmUserList_Controller.superclass.addGetList.call(this);
	
	
	
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

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tm_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tm_first_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("ext_obj",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("tm_first_name");
	
}

			TmUserList_Controller.prototype.addGetObject = function(){
	TmUserList_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
}

			TmUserList_Controller.prototype.addComplete = function(){
	TmUserList_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("tm_first_name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("tm_first_name");	
}

			TmUserList_Controller.prototype.addUpdate = function(){
	TmUserList_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
		var options = {};
		options.required = true;		
		pm.addField(new FieldInt("id",options));
	
		var options = {};
		options.required = true;		
		pm.addField(new FieldString("ext_obj_type",options));
	
		var options = {};
		options.required = true;		
		pm.addField(new FieldInt("ext_obj_int",options));
	
	
}
			
		