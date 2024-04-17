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

function VehicleTotRepItem_Controller(options){
	options = options || {};
	options.listModelClass = VehicleTotRepItemList_Model;
	options.objModelClass = VehicleTotRepItem_Model;
	VehicleTotRepItem_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(VehicleTotRepItem_Controller,ControllerObjServer);

			VehicleTotRepItem_Controller.prototype.addInsert = function(){
	VehicleTotRepItem_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Текст запроса SQL, если задан рассчитывается автоматически";
	var field = new FieldText("query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("is_income",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("info",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			VehicleTotRepItem_Controller.prototype.addUpdate = function(){
	VehicleTotRepItem_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Текст запроса SQL, если задан рассчитывается автоматически";
	var field = new FieldText("query",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("is_income",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("info",options);
	
	pm.addField(field);
	
	
}

			VehicleTotRepItem_Controller.prototype.addDelete = function(){
	VehicleTotRepItem_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			VehicleTotRepItem_Controller.prototype.addGetList = function(){
	VehicleTotRepItem_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("code",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("is_income",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("info",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("is_income,code");
	
}

			VehicleTotRepItem_Controller.prototype.addGetObject = function(){
	VehicleTotRepItem_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		