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

function RoleViewRestriction_Controller(options){
	options = options || {};
	options.listModelClass = RoleViewRestriction_Model;
	options.objModelClass = RoleViewRestriction_Model;
	RoleViewRestriction_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(RoleViewRestriction_Controller,ControllerObjServer);

			RoleViewRestriction_Controller.prototype.addInsert = function(){
	RoleViewRestriction_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.alias = "Роль";options.primaryKey = true;	
	options.enumValues = 'admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing';
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сколько дней разрешено для просмотра назад";
	var field = new FieldInt("back_days_allowed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сколько дней разрешено для просмотра вперед";
	var field = new FieldInt("front_days_allowed",options);
	
	pm.addField(field);
	
	
}

			RoleViewRestriction_Controller.prototype.addUpdate = function(){
	RoleViewRestriction_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.alias = "Роль";options.primaryKey = true;	
	options.enumValues = 'admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing';
	
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	field = new FieldEnum("old_role_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Сколько дней разрешено для просмотра назад";
	var field = new FieldInt("back_days_allowed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Сколько дней разрешено для просмотра вперед";
	var field = new FieldInt("front_days_allowed",options);
	
	pm.addField(field);
	
	
}

			RoleViewRestriction_Controller.prototype.addDelete = function(){
	RoleViewRestriction_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
	options.alias = "Роль";	
	pm.addField(new FieldEnum("role_id",options));
}

			RoleViewRestriction_Controller.prototype.addGetList = function(){
	RoleViewRestriction_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Роль";
	pm.addField(new FieldEnum("role_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Сколько дней разрешено для просмотра назад";
	pm.addField(new FieldInt("back_days_allowed",f_opts));
	var f_opts = {};
	f_opts.alias = "Сколько дней разрешено для просмотра вперед";
	pm.addField(new FieldInt("front_days_allowed",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("role_id");
	
}

			RoleViewRestriction_Controller.prototype.addGetObject = function(){
	RoleViewRestriction_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Роль";	
	pm.addField(new FieldEnum("role_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		