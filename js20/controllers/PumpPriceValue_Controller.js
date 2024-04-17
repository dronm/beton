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

function PumpPriceValue_Controller(options){
	options = options || {};
	options.listModelClass = PumpPriceValue_Model;
	options.objModelClass = PumpPriceValue_Model;
	PumpPriceValue_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(PumpPriceValue_Controller,ControllerObjServer);

			PumpPriceValue_Controller.prototype.addInsert = function(){
	PumpPriceValue_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.autoInc = true;
	var field = new FieldInt("pump_price_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("quant_from",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("quant_to",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("price_m",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("price_fixed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Гарантированная сумма (если установлено, и объем превышает, то сначала эта сумма, а потом по шкале остаток кубов)";
	var field = new FieldBool("price_garanteed",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			PumpPriceValue_Controller.prototype.addUpdate = function(){
	PumpPriceValue_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.autoInc = true;
	var field = new FieldInt("pump_price_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("quant_from",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("quant_to",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("price_m",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldFloat("price_fixed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Гарантированная сумма (если установлено, и объем превышает, то сначала эта сумма, а потом по шкале остаток кубов)";
	var field = new FieldBool("price_garanteed",options);
	
	pm.addField(field);
	
	
}

			PumpPriceValue_Controller.prototype.addDelete = function(){
	PumpPriceValue_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			PumpPriceValue_Controller.prototype.addGetList = function(){
	PumpPriceValue_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("pump_price_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("quant_from",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("quant_to",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("price_m",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldFloat("price_fixed",f_opts));
	var f_opts = {};
	f_opts.alias = "Гарантированная сумма (если установлено, и объем превышает, то сначала эта сумма, а потом по шкале остаток кубов)";
	pm.addField(new FieldBool("price_garanteed",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("quant_from");
	
}

			PumpPriceValue_Controller.prototype.addGetObject = function(){
	PumpPriceValue_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		