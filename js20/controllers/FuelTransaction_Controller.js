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

function FuelTransaction_Controller(options){
	options = options || {};
	options.listModelClass = FuelTransactionList_Model;
	options.objModelClass = FuelTransactionList_Model;
	FuelTransaction_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_import_data();
		
}
extend(FuelTransaction_Controller,ControllerObjServer);

			FuelTransaction_Controller.prototype.addInsert = function(){
	FuelTransaction_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldText("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldText("card_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("vehicle_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("attrs",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("quant",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	
}

			FuelTransaction_Controller.prototype.addUpdate = function(){
	FuelTransaction_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldText("id",options);
	
	pm.addField(field);
	
	field = new FieldText("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("card_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("vehicle_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("attrs",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("quant",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	
}

			FuelTransaction_Controller.prototype.addDelete = function(){
	FuelTransaction_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldText("id",options));
}

			FuelTransaction_Controller.prototype.addGetList = function(){
	FuelTransaction_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldText("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("card_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("vehicle_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("vehicles_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("attrs",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("quant",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("total",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("id");
	
}

			FuelTransaction_Controller.prototype.addGetObject = function(){
	FuelTransaction_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldText("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			FuelTransaction_Controller.prototype.add_import_data = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('import_data',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("file_excel",options));
	
			
	this.addPublicMethod(pm);
}

		