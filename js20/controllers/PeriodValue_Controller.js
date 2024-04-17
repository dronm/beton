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

function PeriodValue_Controller(options){
	options = options || {};
	options.listModelClass = PeriodValue_Model;
	options.objModelClass = PeriodValue_Model;
	PeriodValue_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_get_last_val();
		
}
extend(PeriodValue_Controller,ControllerObjServer);

			PeriodValue_Controller.prototype.addInsert = function(){
	PeriodValue_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид значения";options.required = true;	
	options.enumValues = 'destination_price,destination_price_for_driver,demurrage_cost_per_hour,water_ship_cost';
	var field = new FieldEnum("period_value_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ключ";options.required = true;
	var field = new FieldInt("key",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("val",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			PeriodValue_Controller.prototype.addUpdate = function(){
	PeriodValue_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид значения";	
	options.enumValues = 'destination_price,destination_price_for_driver,demurrage_cost_per_hour,water_ship_cost';
	options.enumValues+= (options.enumValues=='')? '':',';
	options.enumValues+= 'null';
	
	var field = new FieldEnum("period_value_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ключ";
	var field = new FieldInt("key",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("val",options);
	
	pm.addField(field);
	
	
}

			PeriodValue_Controller.prototype.addDelete = function(){
	PeriodValue_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			PeriodValue_Controller.prototype.addGetList = function(){
	PeriodValue_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Вид значения";
	pm.addField(new FieldEnum("period_value_type",f_opts));
	var f_opts = {};
	f_opts.alias = "Ключ";
	pm.addField(new FieldInt("key",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("val",f_opts));
}

			PeriodValue_Controller.prototype.addGetObject = function(){
	PeriodValue_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			PeriodValue_Controller.prototype.add_get_last_val = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_last_val',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldEnum("period_value_type",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("key",options));
	
			
	this.addPublicMethod(pm);
}

		