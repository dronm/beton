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

function ClientSpecificationFlow_Controller(options){
	options = options || {};
	options.listModelClass = ClientSpecificationFlowList_Model;
	ClientSpecificationFlow_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
		
}
extend(ClientSpecificationFlow_Controller,ControllerObjServer);

			ClientSpecificationFlow_Controller.prototype.addGetList = function(){
	ClientSpecificationFlow_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("client_specification_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("shipment_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Спецификация";
	pm.addField(new FieldJSON("client_specifications_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Отгрузка";
	pm.addField(new FieldJSON("shipments_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Количество";
	pm.addField(new FieldFloat("quant",f_opts));
}

		