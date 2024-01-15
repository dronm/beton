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

function DestinationProdBaseDriverPrice_Controller(options){
	options = options || {};
	options.listModelClass = DestinationProdBaseDriverPriceList_Model;
	options.objModelClass = DestinationProdBaseDriverPriceList_Model;
	DestinationProdBaseDriverPrice_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(DestinationProdBaseDriverPrice_Controller,ControllerObjServer);

			DestinationProdBaseDriverPrice_Controller.prototype.addInsert = function(){
	DestinationProdBaseDriverPrice_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Объект";
	var field = new FieldInt("destination_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "База";
	var field = new FieldInt("production_base_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			DestinationProdBaseDriverPrice_Controller.prototype.addUpdate = function(){
	DestinationProdBaseDriverPrice_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Объект";
	var field = new FieldInt("destination_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "База";
	var field = new FieldInt("production_base_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	
}

			DestinationProdBaseDriverPrice_Controller.prototype.addDelete = function(){
	DestinationProdBaseDriverPrice_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("id",options));
}

			DestinationProdBaseDriverPrice_Controller.prototype.addGetList = function(){
	DestinationProdBaseDriverPrice_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("destination_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("production_base_id",f_opts));
	var f_opts = {};
	f_opts.alias = "База";
	pm.addField(new FieldJSON("production_bases_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата";
	pm.addField(new FieldDateTimeTZ("date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Цена";
	pm.addField(new FieldFloat("price",f_opts));
}

			DestinationProdBaseDriverPrice_Controller.prototype.addGetObject = function(){
	DestinationProdBaseDriverPrice_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		