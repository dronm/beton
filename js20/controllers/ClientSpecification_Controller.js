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

function ClientSpecification_Controller(options){
	options = options || {};
	options.listModelClass = ClientSpecificationList_Model;
	options.objModelClass = ClientSpecificationList_Model;
	ClientSpecification_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_complete_for_client();
		
}
extend(ClientSpecification_Controller,ControllerObjServer);

			ClientSpecification_Controller.prototype.addInsert = function(){
	ClientSpecification_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Контрагент";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldDate("specification_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Договор";
	var field = new FieldText("contract",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Спецификация";
	var field = new FieldText("specification",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Марка";
	var field = new FieldInt("concrete_type_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Объект";
	var field = new FieldInt("destination_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Количество";
	var field = new FieldFloat("quant",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сумма";
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ClientSpecification_Controller.prototype.addUpdate = function(){
	ClientSpecification_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Контрагент";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("specification_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Договор";
	var field = new FieldText("contract",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Спецификация";
	var field = new FieldText("specification",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Марка";
	var field = new FieldInt("concrete_type_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Объект";
	var field = new FieldInt("destination_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Количество";
	var field = new FieldFloat("quant",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Цена";
	var field = new FieldFloat("price",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сумма";
	var field = new FieldFloat("total",options);
	
	pm.addField(field);
	
	
}

			ClientSpecification_Controller.prototype.addDelete = function(){
	ClientSpecification_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ClientSpecification_Controller.prototype.addGetList = function(){
	ClientSpecification_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDate("specification_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Договор";
	pm.addField(new FieldText("contract",f_opts));
	var f_opts = {};
	f_opts.alias = "Спецификация";
	pm.addField(new FieldText("specification",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("concrete_type_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("destination_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Контрагент";
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Марка";
	pm.addField(new FieldJSON("concrete_types_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Объект";
	pm.addField(new FieldJSON("destinations_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Количество";
	pm.addField(new FieldFloat("quant",f_opts));
	var f_opts = {};
	f_opts.alias = "Остаток";
	pm.addField(new FieldInt("quant_balance",f_opts));
	var f_opts = {};
	f_opts.alias = "Цена";
	pm.addField(new FieldFloat("price",f_opts));
	var f_opts = {};
	f_opts.alias = "Сумма";
	pm.addField(new FieldFloat("total",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("specification_date");
	
}

			ClientSpecification_Controller.prototype.addGetObject = function(){
	ClientSpecification_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ClientSpecification_Controller.prototype.add_complete_for_client = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_for_client',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("client_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("concrete_type_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("destination_id",options));
	
				
	
	var options = {};
	
		options.maxlength = "100";
	
		pm.addField(new FieldString("search",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

		