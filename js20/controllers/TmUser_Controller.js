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

function TmUser_Controller(options){
	options = options || {};
	options.listModelClass = TmUserPhotoList_Model;
	options.objModelClass = TmUserDialog_Model;
	TmUser_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_get_full_photo();
	this.addComplete();
	this.addUpdate();
		
}
extend(TmUser_Controller,ControllerObjServer);

			TmUser_Controller.prototype.addDelete = function(){
	TmUser_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			TmUser_Controller.prototype.addGetList = function(){
	TmUser_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("tm_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tm_first_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("ext_contact_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("ext_contacts_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("ext_contacts_tel",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("app_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tm_photo",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date_time");
	
}

			TmUser_Controller.prototype.addGetObject = function(){
	TmUser_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			TmUser_Controller.prototype.add_get_full_photo = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_full_photo',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("id",options));
	
			
	this.addPublicMethod(pm);
}

			TmUser_Controller.prototype.addComplete = function(){
	TmUser_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("tm_first_name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("tm_first_name");	
}

			TmUser_Controller.prototype.addUpdate = function(){
	TmUser_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("ext_contact_id",options);
	
	pm.addField(field);
	
	
}

		