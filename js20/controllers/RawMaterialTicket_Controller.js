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

function RawMaterialTicket_Controller(options){
	options = options || {};
	options.listModelClass = RawMaterialTicketList_Model;
	options.objModelClass = RawMaterialTicketList_Model;
	RawMaterialTicket_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_generate();
	this.add_close_ticket();
	this.add_get_carrier_agg_list();
		
}
extend(RawMaterialTicket_Controller,ControllerObjServer);

			RawMaterialTicket_Controller.prototype.addInsert = function(){
	RawMaterialTicket_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Перевозчик";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Материал";
	var field = new FieldInt("raw_material_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Штрихкод";
	var field = new FieldString("barcode",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вес, т";options.required = true;
	var field = new FieldInt("quant",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("issue_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("close_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("close_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("issue_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания срока";
	var field = new FieldDate("expire_date",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			RawMaterialTicket_Controller.prototype.addUpdate = function(){
	RawMaterialTicket_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Перевозчик";
	var field = new FieldInt("carrier_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Материал";
	var field = new FieldInt("raw_material_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Штрихкод";
	var field = new FieldString("barcode",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вес, т";
	var field = new FieldInt("quant",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("issue_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("close_date_time",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("close_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("issue_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания срока";
	var field = new FieldDate("expire_date",options);
	
	pm.addField(field);
	
	
}

			RawMaterialTicket_Controller.prototype.addDelete = function(){
	RawMaterialTicket_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			RawMaterialTicket_Controller.prototype.addGetList = function(){
	RawMaterialTicket_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Перевозчик";
	pm.addField(new FieldInt("carrier_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Перевозчик";
	pm.addField(new FieldJSON("carriers_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Материал";
	pm.addField(new FieldInt("raw_material_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Материал";
	pm.addField(new FieldJSON("raw_materials_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Штрихкод";
	pm.addField(new FieldString("barcode",f_opts));
	var f_opts = {};
	f_opts.alias = "Вес, т";
	pm.addField(new FieldInt("quant",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("issue_date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("close_date_time",f_opts));
	var f_opts = {};
	f_opts.alias = "Кто выпустил";
	pm.addField(new FieldJSON("issue_users_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("issue_user_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Кто погасил";
	pm.addField(new FieldJSON("close_users_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("close_user_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата окончания срока";
	pm.addField(new FieldDate("expire_date",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("issue_date_time");
	
}

			RawMaterialTicket_Controller.prototype.addGetObject = function(){
	RawMaterialTicket_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			RawMaterialTicket_Controller.prototype.add_generate = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('generate',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("carrier_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("raw_material_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("quant",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("barcode_from",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("barcode_to",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldDate("expire_date",options));
	
			
	this.addPublicMethod(pm);
}

			RawMaterialTicket_Controller.prototype.add_close_ticket = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('close_ticket',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("barcode",options));
	
			
	this.addPublicMethod(pm);
}

			RawMaterialTicket_Controller.prototype.add_get_carrier_agg_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_carrier_agg_list',opts);
	
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

				
	
	var options = {};
	
		pm.addField(new FieldString("templ",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("inline",options));
	
			
	this.addPublicMethod(pm);
}

		