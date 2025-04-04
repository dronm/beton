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

function ExcelTemplate_Controller(options){
	options = options || {};
	options.listModelClass = ExcelTemplateList_Model;
	options.objModelClass = ExcelTemplateDialog_Model;
	ExcelTemplate_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_download_excel_file();
	this.add_delete_excel_file();
		
}
extend(ExcelTemplate_Controller,ControllerObjServer);

			ExcelTemplate_Controller.prototype.addInsert = function(){
	ExcelTemplate_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Описание шаблона";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("file_content",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("file_info",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("sql_query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("cell_matching",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("image_sql",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("update_dt",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
		var options = {};
				
		pm.addField(new FieldText("excel_file",options));
	
	
}

			ExcelTemplate_Controller.prototype.addUpdate = function(){
	ExcelTemplate_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Описание шаблона";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("file_content",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("file_info",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("sql_query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("cell_matching",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("image_sql",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("update_dt",options);
	
	pm.addField(field);
	
		var options = {};
				
		pm.addField(new FieldText("excel_file",options));
	
	
}

			ExcelTemplate_Controller.prototype.addDelete = function(){
	ExcelTemplate_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("id",options));
}

			ExcelTemplate_Controller.prototype.addGetList = function(){
	ExcelTemplate_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Код";
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	f_opts.alias = "Описание шаблона";
	pm.addField(new FieldText("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("file_info",f_opts));
}

			ExcelTemplate_Controller.prototype.addGetObject = function(){
	ExcelTemplate_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ExcelTemplate_Controller.prototype.add_download_excel_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('download_excel_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("excel_template_id",options));
	
			
	this.addPublicMethod(pm);
}

			ExcelTemplate_Controller.prototype.add_delete_excel_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('delete_excel_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("excel_template_id",options));
	
			
	this.addPublicMethod(pm);
}

		