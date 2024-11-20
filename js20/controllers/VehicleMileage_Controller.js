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

function VehicleMileage_Controller(options){
	options = options || {};
	options.listModelClass = VehicleMileageList_Model;
	options.objModelClass = VehicleMileageList_Model;
	VehicleMileage_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(VehicleMileage_Controller,ControllerObjServer);

			VehicleMileage_Controller.prototype.addInsert = function(){
	VehicleMileage_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ТС";options.required = true;
	var field = new FieldInt("vehicle_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTimeTZ("for_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пробег";
	var field = new FieldInt("mileage",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Who set value";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			VehicleMileage_Controller.prototype.addUpdate = function(){
	VehicleMileage_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "ТС";
	var field = new FieldInt("vehicle_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTimeTZ("for_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пробег";
	var field = new FieldInt("mileage",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Who set value";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	
}

			VehicleMileage_Controller.prototype.addDelete = function(){
	VehicleMileage_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			VehicleMileage_Controller.prototype.addGetList = function(){
	VehicleMileage_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "ТС";
	pm.addField(new FieldInt("vehicle_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата";
	pm.addField(new FieldDateTimeTZ("for_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Пробег";
	pm.addField(new FieldInt("mileage",f_opts));
	var f_opts = {};
	f_opts.alias = "Who set value";
	pm.addField(new FieldJSON("users_ref",f_opts));
}

			VehicleMileage_Controller.prototype.addGetObject = function(){
	VehicleMileage_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "ТС";	
	pm.addField(new FieldInt("vehicle_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		