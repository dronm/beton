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

function ConcreteCostHeader_Controller(options){
	options = options || {};
	options.listModelClass = ConcreteCostHeader_Model;
	options.objModelClass = ConcreteCostHeader_Model;
	ConcreteCostHeader_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_get_client_price_list();
		
}
extend(ConcreteCostHeader_Controller,ControllerObjServer);

			ConcreteCostHeader_Controller.prototype.addInsert = function(){
	ConcreteCostHeader_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldDate("date",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldArray("clients_ar",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("clients_list",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ConcreteCostHeader_Controller.prototype.addUpdate = function(){
	ConcreteCostHeader_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldDate("date",options);
	
	pm.addField(field);
	
	field = new FieldDate("old_date",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldArray("clients_ar",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("clients_list",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	
}

			ConcreteCostHeader_Controller.prototype.addDelete = function(){
	ConcreteCostHeader_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
	var options = {"required":true};
		
	pm.addField(new FieldDate("date",options));
}

			ConcreteCostHeader_Controller.prototype.addGetList = function(){
	ConcreteCostHeader_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDate("date",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldArray("clients_ar",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("clients_list",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("comment_text",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date");
	
}

			ConcreteCostHeader_Controller.prototype.addGetObject = function(){
	ConcreteCostHeader_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
		
	pm.addField(new FieldDate("date",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ConcreteCostHeader_Controller.prototype.add_get_client_price_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_client_price_list',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("client_id",options));
	
			
	this.addPublicMethod(pm);
}

		