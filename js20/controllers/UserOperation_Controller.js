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

function UserOperation_Controller(options){
	options = options || {};
	options.listModelClass = UserOperation_Model;
	options.objModelClass = UserOperation_Model;
	UserOperation_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(UserOperation_Controller,ControllerObjServer);

			UserOperation_Controller.prototype.addInsert = function(){
	UserOperation_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.required = true;
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;options.required = true;
	var field = new FieldString("operation_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("operation",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("status",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("percent",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("error_text",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time_end",options);
	
	pm.addField(field);
	
	
}

			UserOperation_Controller.prototype.addUpdate = function(){
	UserOperation_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_user_id",{});
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldString("operation_id",options);
	
	pm.addField(field);
	
	field = new FieldString("old_operation_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("operation",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("status",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("percent",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("error_text",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time_end",options);
	
	pm.addField(field);
	
	
}

			UserOperation_Controller.prototype.addDelete = function(){
	UserOperation_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("user_id",options));
	var options = {"required":true};
		
	pm.addField(new FieldString("operation_id",options));
}

			UserOperation_Controller.prototype.addGetList = function(){
	UserOperation_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("operation_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("operation",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("status",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("percent",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("error_text",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("comment_text",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("date_time_end",f_opts));
}

			UserOperation_Controller.prototype.addGetObject = function(){
	UserOperation_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
		
	pm.addField(new FieldString("operation_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		