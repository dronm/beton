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

function DOCMaterialMovement_Controller(options){
	options = options || {};
	options.listModelClass = DOCMaterialMovementList_Model;
	options.objModelClass = DOCMaterialMovementList_Model;
	DOCMaterialMovement_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(DOCMaterialMovement_Controller,ControllerObjServer);

			DOCMaterialMovement_Controller.prototype.addInsert = function(){
	DOCMaterialMovement_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Проведен";
	var field = new FieldBool("processed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер";
	var field = new FieldString("number",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("material_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_base_from_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_base_to_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Количество";
	var field = new FieldFloat("quant",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Автор";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Carrier";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Vehicle plate";
	var field = new FieldString("vehicle_plate",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Кто последний вносил изменения";
	var field = new FieldInt("last_modif_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Время последнего изменения";
	var field = new FieldDateTimeTZ("last_modif_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			DOCMaterialMovement_Controller.prototype.addUpdate = function(){
	DOCMaterialMovement_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Проведен";
	var field = new FieldBool("processed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер";
	var field = new FieldString("number",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("material_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_base_from_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_base_to_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Количество";
	var field = new FieldFloat("quant",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Автор";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Carrier";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Vehicle plate";
	var field = new FieldString("vehicle_plate",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Кто последний вносил изменения";
	var field = new FieldInt("last_modif_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Время последнего изменения";
	var field = new FieldDateTimeTZ("last_modif_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	
}

			DOCMaterialMovement_Controller.prototype.addDelete = function(){
	DOCMaterialMovement_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			DOCMaterialMovement_Controller.prototype.addGetList = function(){
	DOCMaterialMovement_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Дата";
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Номер";
	pm.addField(new FieldString("number",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("production_base_from_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("production_base_to_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("production_bases_from_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("production_bases_to_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("materials_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Количество";
	pm.addField(new FieldFloat("quant",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("users_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("carriers_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Vehicle plate";
	pm.addField(new FieldString("vehicle_plate",f_opts));
	var f_opts = {};
	f_opts.alias = "Кто последний вносил изменения";
	pm.addField(new FieldJSON("last_modif_users_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Время последнего изменения";
	pm.addField(new FieldDateTimeTZ("last_modif_date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("comment_text",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date_time");
	
}

			DOCMaterialMovement_Controller.prototype.addGetObject = function(){
	DOCMaterialMovement_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		