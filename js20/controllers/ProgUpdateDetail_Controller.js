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

function ProgUpdateDetail_Controller(options){
	options = options || {};
	options.listModelClass = ProgUpdateDetail_Model;
	options.objModelClass = ProgUpdateDetail_Model;
	ProgUpdateDetail_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_get_for_user();
		
}
extend(ProgUpdateDetail_Controller,ControllerObjServer);

			ProgUpdateDetail_Controller.prototype.addInsert = function(){
	ProgUpdateDetail_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Код сортирвки";options.required = true;
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Обновление";
	var field = new FieldInt("prog_update_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Описание";
	var field = new FieldText("description",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Техническое описание";
	var field = new FieldText("description_tech",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ProgUpdateDetail_Controller.prototype.addUpdate = function(){
	ProgUpdateDetail_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Код сортирвки";
	var field = new FieldInt("code",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Обновление";
	var field = new FieldInt("prog_update_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Описание";
	var field = new FieldText("description",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Техническое описание";
	var field = new FieldText("description_tech",options);
	
	pm.addField(field);
	
	
}

			ProgUpdateDetail_Controller.prototype.addDelete = function(){
	ProgUpdateDetail_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ProgUpdateDetail_Controller.prototype.addGetList = function(){
	ProgUpdateDetail_Controller.superclass.addGetList.call(this);
	
	
	
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
	f_opts.alias = "Код сортирвки";
	pm.addField(new FieldInt("code",f_opts));
	var f_opts = {};
	f_opts.alias = "Обновление";
	pm.addField(new FieldInt("prog_update_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Описание";
	pm.addField(new FieldText("description",f_opts));
	var f_opts = {};
	f_opts.alias = "Техническое описание";
	pm.addField(new FieldText("description_tech",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("code");
	
}

			ProgUpdateDetail_Controller.prototype.addGetObject = function(){
	ProgUpdateDetail_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ProgUpdateDetail_Controller.prototype.add_get_for_user = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_for_user',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("id",options));
	
			
	this.addPublicMethod(pm);
}

		