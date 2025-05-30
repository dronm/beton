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

function RawMaterialConsRateDate_Controller(options){
	options = options || {};
	options.listModelClass = RawMaterialConsRateDateList_Model;
	options.objModelClass = RawMaterialConsRateDateList_Model;
	RawMaterialConsRateDate_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_recalc_consumption();
	this.addComplete();
		
}
extend(RawMaterialConsRateDate_Controller,ControllerObjServer);

			RawMaterialConsRateDate_Controller.prototype.addInsert = function(){
	RawMaterialConsRateDate_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";options.required = true;
	var field = new FieldDateTime("dt",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер подбора";
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Элемент-основание";
	var field = new FieldInt("base_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Завод";
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			RawMaterialConsRateDate_Controller.prototype.addUpdate = function(){
	RawMaterialConsRateDate_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("dt",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер подбора";
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Элемент-основание";
	var field = new FieldInt("base_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Завод";
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	
}

			RawMaterialConsRateDate_Controller.prototype.addDelete = function(){
	RawMaterialConsRateDate_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			RawMaterialConsRateDate_Controller.prototype.addGetList = function(){
	RawMaterialConsRateDate_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDateTime("dt",f_opts));
	var f_opts = {};
	f_opts.alias = "Период";
	pm.addField(new FieldText("period",f_opts));
	var f_opts = {};
	f_opts.alias = "Комментарий";
	pm.addField(new FieldText("name",f_opts));
	var f_opts = {};
	f_opts.alias = "№ подбора";
	pm.addField(new FieldInt("code",f_opts));
	var f_opts = {};
	f_opts.alias = "Завод";
	pm.addField(new FieldJSON("production_sites_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Завод ID";
	pm.addField(new FieldInt("production_site_id",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("dt");
	
}

			RawMaterialConsRateDate_Controller.prototype.addGetObject = function(){
	RawMaterialConsRateDate_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			RawMaterialConsRateDate_Controller.prototype.add_recalc_consumption = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('recalc_consumption',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("period_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("production_site_id",options));
	
			
	this.addPublicMethod(pm);
}

			RawMaterialConsRateDate_Controller.prototype.addComplete = function(){
	RawMaterialConsRateDate_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	f_opts.alias = "";
	var pm = this.getComplete();
	pm.addField(new FieldInt("code",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("code");	
}

		