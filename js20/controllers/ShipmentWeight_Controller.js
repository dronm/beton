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

function ShipmentWeight_Controller(options){
	options = options || {};
	options.listModelClass = ShipmentWeightList_Model;
	options.objModelClass = ShipmentWeightList_Model;
	ShipmentWeight_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
		
}
extend(ShipmentWeight_Controller,ControllerObjServer);

			ShipmentWeight_Controller.prototype.addGetList = function(){
	ShipmentWeight_Controller.superclass.addGetList.call(this);
	
	
	
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
	pm.addField(new FieldInt("shipment_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Код";
	pm.addField(new FieldInt("quant",f_opts));
	var f_opts = {};
	f_opts.alias = "ТС";
	pm.addField(new FieldJSON("vehicles_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Объект";
	pm.addField(new FieldJSON("destinations_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Заявка";
	pm.addField(new FieldJSON("orders_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата";
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Брутто";
	pm.addField(new FieldFloat("quant_gross",f_opts));
	var f_opts = {};
	f_opts.alias = "Нетто";
	pm.addField(new FieldFloat("quant_net",f_opts));
}

			ShipmentWeight_Controller.prototype.addGetObject = function(){
	ShipmentWeight_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("shipment_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		