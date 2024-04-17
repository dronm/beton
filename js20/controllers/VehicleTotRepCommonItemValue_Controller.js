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

function VehicleTotRepCommonItemValue_Controller(options){
	options = options || {};
	options.listModelClass = VehicleTotRepCommonItemValue_Model;
	options.objModelClass = VehicleTotRepCommonItemValue_Model;
	VehicleTotRepCommonItemValue_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_update_values();
		
}
extend(VehicleTotRepCommonItemValue_Controller,ControllerObjServer);

			VehicleTotRepCommonItemValue_Controller.prototype.addInsert = function(){
	VehicleTotRepCommonItemValue_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("vehicle_owner_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("vehicle_tot_rep_common_item_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "First date of month";options.primaryKey = true;
	var field = new FieldDate("period",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ручное значение";
	var field = new FieldFloat("value",options);
	
	pm.addField(field);
	
	
}

			VehicleTotRepCommonItemValue_Controller.prototype.addUpdate = function(){
	VehicleTotRepCommonItemValue_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("vehicle_owner_id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_vehicle_owner_id",{});
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("vehicle_tot_rep_common_item_id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_vehicle_tot_rep_common_item_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "First date of month";options.primaryKey = true;
	var field = new FieldDate("period",options);
	
	pm.addField(field);
	
	field = new FieldDate("old_period",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Ручное значение";
	var field = new FieldFloat("value",options);
	
	pm.addField(field);
	
	
}

			VehicleTotRepCommonItemValue_Controller.prototype.addDelete = function(){
	VehicleTotRepCommonItemValue_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("vehicle_owner_id",options));
	var options = {"required":true};
		
	pm.addField(new FieldInt("vehicle_tot_rep_common_item_id",options));
	var options = {"required":true};
	options.alias = "First date of month";	
	pm.addField(new FieldDate("period",options));
}

			VehicleTotRepCommonItemValue_Controller.prototype.addGetList = function(){
	VehicleTotRepCommonItemValue_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("vehicle_owner_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("vehicle_tot_rep_common_item_id",f_opts));
	var f_opts = {};
	f_opts.alias = "First date of month";
	pm.addField(new FieldDate("period",f_opts));
	var f_opts = {};
	f_opts.alias = "Ручное значение";
	pm.addField(new FieldFloat("value",f_opts));
}

			VehicleTotRepCommonItemValue_Controller.prototype.addGetObject = function(){
	VehicleTotRepCommonItemValue_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("vehicle_owner_id",f_opts));
	var f_opts = {};
		
	pm.addField(new FieldInt("vehicle_tot_rep_common_item_id",f_opts));
	var f_opts = {};
	f_opts.alias = "First date of month";	
	pm.addField(new FieldDate("period",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			VehicleTotRepCommonItemValue_Controller.prototype.add_update_values = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('update_values',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("values",options));
	
			
	this.addPublicMethod(pm);
}

		