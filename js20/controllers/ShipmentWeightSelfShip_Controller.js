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

function ShipmentWeightSelfShip_Controller(options){
	options = options || {};
	options.listModelClass = ShipmentWeightSelfShipList_Model;
	options.objModelClass = ShipmentWeightSelfShipList_Model;
	ShipmentWeightSelfShip_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(ShipmentWeightSelfShip_Controller,ControllerObjServer);

			ShipmentWeightSelfShip_Controller.prototype.addInsert = function(){
	ShipmentWeightSelfShip_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.required = true;
	var field = new FieldInt("shipment_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";options.required = true;
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Брутто";
	var field = new FieldFloat("quant_gross",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Нетто";
	var field = new FieldFloat("quant_net",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Груз";
	var field = new FieldText("material",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ПунктОтправления";
	var field = new FieldText("sender_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отправитель";
	var field = new FieldText("sender_client",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Склад разгрузки";
	var field = new FieldText("unloading_warehouse",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'self_ship,redirection';
	var field = new FieldEnum("ship_weighing_cause",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер";
	var field = new FieldText("number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("uploaded_at",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	
}

			ShipmentWeightSelfShip_Controller.prototype.addUpdate = function(){
	ShipmentWeightSelfShip_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;
	var field = new FieldInt("shipment_id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_shipment_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Брутто";
	var field = new FieldFloat("quant_gross",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Нетто";
	var field = new FieldFloat("quant_net",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Груз";
	var field = new FieldText("material",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ПунктОтправления";
	var field = new FieldText("sender_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отправитель";
	var field = new FieldText("sender_client",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Склад разгрузки";
	var field = new FieldText("unloading_warehouse",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'self_ship,redirection';
	
	var field = new FieldEnum("ship_weighing_cause",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер";
	var field = new FieldText("number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTime("uploaded_at",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	
}

			ShipmentWeightSelfShip_Controller.prototype.addDelete = function(){
	ShipmentWeightSelfShip_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("shipment_id",options));
}

			ShipmentWeightSelfShip_Controller.prototype.addGetList = function(){
	ShipmentWeightSelfShip_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldFloat("vehicles_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("vehicle_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата";
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Номер";
	pm.addField(new FieldText("number",f_opts));
	var f_opts = {};
	f_opts.alias = "Груз";
	pm.addField(new FieldText("material",f_opts));
	var f_opts = {};
	f_opts.alias = "ПунктОтправления";
	pm.addField(new FieldText("sender_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Брутто";
	pm.addField(new FieldFloat("quant_gross",f_opts));
	var f_opts = {};
	f_opts.alias = "Нетто";
	pm.addField(new FieldFloat("quant_net",f_opts));
	var f_opts = {};
	f_opts.alias = "Комментарий";
	pm.addField(new FieldText("comment_text",f_opts));
}

			ShipmentWeightSelfShip_Controller.prototype.addGetObject = function(){
	ShipmentWeightSelfShip_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("shipment_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		