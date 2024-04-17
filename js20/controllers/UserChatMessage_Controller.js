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

function UserChatMessage_Controller(options){
	options = options || {};
	options.listModelClass = UserChatMessage_Model;
	options.objModelClass = UserChatMessage_Model;
	UserChatMessage_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(UserChatMessage_Controller,ControllerObjServer);

			UserChatMessage_Controller.prototype.addInsert = function(){
	UserChatMessage_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("from_user",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("to_user",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("media_type",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("message",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			UserChatMessage_Controller.prototype.addUpdate = function(){
	UserChatMessage_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("from_user",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("to_user",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("media_type",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("message",options);
	
	pm.addField(field);
	
	
}

			UserChatMessage_Controller.prototype.addDelete = function(){
	UserChatMessage_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			UserChatMessage_Controller.prototype.addGetList = function(){
	UserChatMessage_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDateTimeTZ("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("from_user",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("to_user",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("media_type",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("message",f_opts));
}

			UserChatMessage_Controller.prototype.addGetObject = function(){
	UserChatMessage_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		