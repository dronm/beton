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

function Driver_Controller(options){
	options = options || {};
	options.listModelClass = DriverList_Model;
	options.objModelClass = DriverList_Model;
	Driver_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_driver_cheat_report();
		
}
extend(Driver_Controller,ControllerObjServer);

			Driver_Controller.prototype.addInsert = function(){
	Driver_Controller.superclass.addInsert.call(this);
	
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
	options.alias = "Водительское удостоверение";
	var field = new FieldText("driver_licence",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Класс водительского удостоверения";
	var field = new FieldString("driver_licence_class",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Официально устроен";
	var field = new FieldBool("employed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Person inn";
	var field = new FieldText("inn",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			Driver_Controller.prototype.addUpdate = function(){
	Driver_Controller.superclass.addUpdate.call(this);
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
	options.alias = "Водительское удостоверение";
	var field = new FieldText("driver_licence",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Класс водительского удостоверения";
	var field = new FieldString("driver_licence_class",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Официально устроен";
	var field = new FieldBool("employed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Person inn";
	var field = new FieldText("inn",options);
	
	pm.addField(field);
	
	
}

			Driver_Controller.prototype.addDelete = function(){
	Driver_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("id",options));
}

			Driver_Controller.prototype.addGetList = function(){
	Driver_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Водительское удостоверение";
	pm.addField(new FieldText("driver_licence",f_opts));
	var f_opts = {};
	f_opts.alias = "Класс водительского удостоверения";
	pm.addField(new FieldString("driver_licence_class",f_opts));
	var f_opts = {};
	f_opts.alias = "Контакты";
	pm.addField(new FieldJSON("contact_list",f_opts));
	var f_opts = {};
	f_opts.alias = "Контакты";
	pm.addField(new FieldText("contact_ids",f_opts));
	var f_opts = {};
	f_opts.alias = "Официально устроен";
	pm.addField(new FieldBool("employed",f_opts));
	var f_opts = {};
	f_opts.alias = "ИНН водителя";
	pm.addField(new FieldText("inn",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");
	
}

			Driver_Controller.prototype.addGetObject = function(){
	Driver_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			Driver_Controller.prototype.addComplete = function(){
	Driver_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	f_opts.alias = "";
	var pm = this.getComplete();
	pm.addField(new FieldString("name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");	
}

			Driver_Controller.prototype.add_driver_cheat_report = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('driver_cheat_report',opts);
	
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

				
	
	var options = {};
	
		pm.addField(new FieldString("templ",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldTime("stop_duration",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("stop_spot_offset",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldDateTime("cheat_end_date_time",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("vehicle_id",options));
	
			
	this.addPublicMethod(pm);
}

		