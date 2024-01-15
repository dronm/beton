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

function GornyiCarrierMatch_Controller(options){
	options = options || {};
	options.listModelClass = GornyiCarrierMatchList_Model;
	options.objModelClass = GornyiCarrierMatchList_Model;
	GornyiCarrierMatch_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(GornyiCarrierMatch_Controller,ControllerObjServer);

			GornyiCarrierMatch_Controller.prototype.addInsert = function(){
	GornyiCarrierMatch_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Перевозчик";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("plate",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			GornyiCarrierMatch_Controller.prototype.addUpdate = function(){
	GornyiCarrierMatch_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.alias = "Код";options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Перевозчик";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("plate",options);
	
	pm.addField(field);
	
	
}

			GornyiCarrierMatch_Controller.prototype.addDelete = function(){
	GornyiCarrierMatch_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Код";	
	pm.addField(new FieldInt("id",options));
}

			GornyiCarrierMatch_Controller.prototype.addGetList = function(){
	GornyiCarrierMatch_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Перевозчик";
	pm.addField(new FieldInt("carrier_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Перевозчик";
	pm.addField(new FieldJSON("carriers_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("plate",f_opts));
}

			GornyiCarrierMatch_Controller.prototype.addGetObject = function(){
	GornyiCarrierMatch_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		