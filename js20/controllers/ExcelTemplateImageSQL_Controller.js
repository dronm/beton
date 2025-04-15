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

function ExcelTemplateImageSQL_Controller(options){
	options = options || {};
	options.listModelClass = ExcelTemplateImageSQL_Model;
	options.objModelClass = ExcelTemplateImageSQL_Model;
	ExcelTemplateImageSQL_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(ExcelTemplateImageSQL_Controller,ControllerObjClient);

			ExcelTemplateImageSQL_Controller.prototype.addInsert = function(){
	ExcelTemplateImageSQL_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("sql_query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("w",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("h",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("comment_text",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ExcelTemplateImageSQL_Controller.prototype.addUpdate = function(){
	ExcelTemplateImageSQL_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("sql_query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("w",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("h",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("comment_text",options);
	
	pm.addField(field);
	
	
}

			ExcelTemplateImageSQL_Controller.prototype.addDelete = function(){
	ExcelTemplateImageSQL_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ExcelTemplateImageSQL_Controller.prototype.addGetList = function(){
	ExcelTemplateImageSQL_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("sql_query",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("w",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("h",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("comment_text",f_opts));
}

			ExcelTemplateImageSQL_Controller.prototype.addGetObject = function(){
	ExcelTemplateImageSQL_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		