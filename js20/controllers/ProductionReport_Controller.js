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

function ProductionReport_Controller(options){
	options = options || {};
	options.listModelClass = ProductionReportList_Model;
	options.objModelClass = ProductionReportDialog_Model;
	ProductionReport_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_generate_docs();
		
}
extend(ProductionReport_Controller,ControllerObjServer);

			ProductionReport_Controller.prototype.addInsert = function(){
	ProductionReport_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldDateTime("shift_from",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldDateTime("shift_to",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ссылка на документ 1с";
	var field = new FieldJSONB("ref_1c",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("data_for_1c",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ProductionReport_Controller.prototype.addUpdate = function(){
	ProductionReport_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("shift_from",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("shift_to",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ссылка на документ 1с";
	var field = new FieldJSONB("ref_1c",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSON("data_for_1c",options);
	
	pm.addField(field);
	
	
}

			ProductionReport_Controller.prototype.addDelete = function(){
	ProductionReport_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ProductionReport_Controller.prototype.addGetList = function(){
	ProductionReport_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDateTime("shift_from",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTime("shift_to",f_opts));
	var f_opts = {};
	f_opts.alias = "Ссылка на документ 1с";
	pm.addField(new FieldJSONB("ref_1c",f_opts));
}

			ProductionReport_Controller.prototype.addGetObject = function(){
	ProductionReport_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ProductionReport_Controller.prototype.add_generate_docs = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('generate_docs',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldDateTime("shift_from",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldDateTime("shift_to",options));
	
			
	this.addPublicMethod(pm);
}

		