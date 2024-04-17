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

function TaskDetail_Controller(options){
	options = options || {};
	options.listModelClass = TaskDetail_Model;
	options.objModelClass = TaskDetail_Model;
	TaskDetail_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(TaskDetail_Controller,ControllerObjServer);

			TaskDetail_Controller.prototype.addInsert = function(){
	TaskDetail_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Шапка задачи";
	var field = new FieldInt("task_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сотрудник";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("create_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по email";
	var field = new FieldBool("inform_email",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по sms";
	var field = new FieldBool("inform_sms",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по whatsup";
	var field = new FieldBool("inform_whatsup",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по telegram";
	var field = new FieldBool("inform_telegram",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Содержимое";
	var field = new FieldText("content",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Просмотрена";
	var field = new FieldDateTimeTZ("open_date_time",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			TaskDetail_Controller.prototype.addUpdate = function(){
	TaskDetail_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Шапка задачи";
	var field = new FieldInt("task_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сотрудник";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("create_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по email";
	var field = new FieldBool("inform_email",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по sms";
	var field = new FieldBool("inform_sms",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по whatsup";
	var field = new FieldBool("inform_whatsup",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Информировать по telegram";
	var field = new FieldBool("inform_telegram",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Содержимое";
	var field = new FieldText("content",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Просмотрена";
	var field = new FieldDateTimeTZ("open_date_time",options);
	
	pm.addField(field);
	
	
}

			TaskDetail_Controller.prototype.addDelete = function(){
	TaskDetail_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			TaskDetail_Controller.prototype.addGetList = function(){
	TaskDetail_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Шапка задачи";
	pm.addField(new FieldInt("task_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Сотрудник";
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("create_date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Информировать по email";
	pm.addField(new FieldBool("inform_email",f_opts));
	var f_opts = {};
	f_opts.alias = "Информировать по sms";
	pm.addField(new FieldBool("inform_sms",f_opts));
	var f_opts = {};
	f_opts.alias = "Информировать по whatsup";
	pm.addField(new FieldBool("inform_whatsup",f_opts));
	var f_opts = {};
	f_opts.alias = "Информировать по telegram";
	pm.addField(new FieldBool("inform_telegram",f_opts));
	var f_opts = {};
	f_opts.alias = "Содержимое";
	pm.addField(new FieldText("content",f_opts));
	var f_opts = {};
	f_opts.alias = "Просмотрена";
	pm.addField(new FieldDateTimeTZ("open_date_time",f_opts));
}

			TaskDetail_Controller.prototype.addGetObject = function(){
	TaskDetail_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		