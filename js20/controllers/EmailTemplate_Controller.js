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

function EmailTemplate_Controller(options){
	options = options || {};
	options.listModelClass = EmailTemplateList_Model;
	options.objModelClass = EmailTemplateList_Model;
	EmailTemplate_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(EmailTemplate_Controller,ControllerObjServer);

			EmailTemplate_Controller.prototype.addInsert = function(){
	EmailTemplate_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тип email";options.required = true;	
	options.enumValues = 'new_account,reset_pwd';
	var field = new FieldEnum("email_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Шаблон";options.required = true;
	var field = new FieldText("template",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";options.required = true;
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тема";options.required = true;
	var field = new FieldText("mes_subject",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поля";options.required = true;
	var field = new FieldText("fields",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			EmailTemplate_Controller.prototype.addUpdate = function(){
	EmailTemplate_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Тип email";	
	options.enumValues = 'new_account,reset_pwd';
	options.enumValues+= (options.enumValues=='')? '':',';
	options.enumValues+= 'null';
	
	var field = new FieldEnum("email_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Шаблон";
	var field = new FieldText("template",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тема";
	var field = new FieldText("mes_subject",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поля";
	var field = new FieldText("fields",options);
	
	pm.addField(field);
	
	
}

			EmailTemplate_Controller.prototype.addDelete = function(){
	EmailTemplate_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			EmailTemplate_Controller.prototype.addGetList = function(){
	EmailTemplate_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("email_type",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("email_type_descr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("template",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("fields",f_opts));
}

			EmailTemplate_Controller.prototype.addGetObject = function(){
	EmailTemplate_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		