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

function ConcreteType_Controller(options){
	options = options || {};
	options.listModelClass = ConcreteTypeList_Model;
	options.objModelClass = ConcreteTypeList_Model;
	ConcreteType_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_get_list_for_lab();
	this.add_get_for_client_list();
	this.add_get_for_site_list();
		
}
extend(ConcreteType_Controller,ControllerObjServer);

			ConcreteType_Controller.prototype.addInsert = function(){
	ConcreteType_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование";options.required = true;
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Код 1С";options.required = true;
	var field = new FieldString("code_1c",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Норма давл.";options.required = true;
	var field = new FieldFloat("pres_norm",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Кф.МПА";
	var field = new FieldFloat("mpa_ratio",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Есть нормы расхода";
	var field = new FieldBool("material_cons_rates",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отображать на сайте";
	var field = new FieldBool("show_on_site",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Официальное наименование для накладной";
	var field = new FieldString("official_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Прочность для паспорта качества";
	var field = new FieldInt("prochnost",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "F";
	var field = new FieldInt("f_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "W";
	var field = new FieldInt("w_val",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ConcreteType_Controller.prototype.addUpdate = function(){
	ConcreteType_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование";
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Код 1С";
	var field = new FieldString("code_1c",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Норма давл.";
	var field = new FieldFloat("pres_norm",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Кф.МПА";
	var field = new FieldFloat("mpa_ratio",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Есть нормы расхода";
	var field = new FieldBool("material_cons_rates",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отображать на сайте";
	var field = new FieldBool("show_on_site",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Официальное наименование для накладной";
	var field = new FieldString("official_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Прочность для паспорта качества";
	var field = new FieldInt("prochnost",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "F";
	var field = new FieldInt("f_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "W";
	var field = new FieldInt("w_val",options);
	
	pm.addField(field);
	
	
}

			ConcreteType_Controller.prototype.addDelete = function(){
	ConcreteType_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("id",options));
}

			ConcreteType_Controller.prototype.addGetList = function(){
	ConcreteType_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Наименование";
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	f_opts.alias = "Код 1С";
	pm.addField(new FieldString("code_1c",f_opts));
	var f_opts = {};
	f_opts.alias = "Норма давл.";
	pm.addField(new FieldFloat("pres_norm",f_opts));
	var f_opts = {};
	f_opts.alias = "Кф.МПА";
	pm.addField(new FieldFloat("mpa_ratio",f_opts));
	var f_opts = {};
	f_opts.alias = "Цена";
	pm.addField(new FieldFloat("price",f_opts));
	var f_opts = {};
	f_opts.alias = "Есть нормы расхода";
	pm.addField(new FieldBool("material_cons_rates",f_opts));
	var f_opts = {};
	f_opts.alias = "Отображать на сайте";
	pm.addField(new FieldBool("show_on_site",f_opts));
	var f_opts = {};
	f_opts.alias = "Официальное наименование для накладной";
	pm.addField(new FieldString("official_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Прочность для паспорта качества";
	pm.addField(new FieldInt("prochnost",f_opts));
	var f_opts = {};
	f_opts.alias = "F";
	pm.addField(new FieldInt("f_val",f_opts));
	var f_opts = {};
	f_opts.alias = "W";
	pm.addField(new FieldInt("w_val",f_opts));
}

			ConcreteType_Controller.prototype.addGetObject = function(){
	ConcreteType_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ConcreteType_Controller.prototype.addComplete = function(){
	ConcreteType_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	f_opts.alias = "";
	var pm = this.getComplete();
	pm.addField(new FieldString("name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");	
}

			ConcreteType_Controller.prototype.add_get_list_for_lab = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_list_for_lab',opts);
	
	this.addPublicMethod(pm);
}

			ConcreteType_Controller.prototype.add_get_for_client_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_for_client_list',opts);
	
	this.addPublicMethod(pm);
}

			ConcreteType_Controller.prototype.add_get_for_site_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_for_site_list',opts);
	
	this.addPublicMethod(pm);
}

		