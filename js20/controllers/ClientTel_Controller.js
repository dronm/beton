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

function ClientTel_Controller(options){
	options = options || {};
	options.listModelClass = ClientTelList_Model;
	options.objModelClass = ClientTel_Model;
	ClientTel_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_complete_tel();
	this.add_upsert();
	this.add_get_ref();
		
}
extend(ClientTel_Controller,ControllerObjServer);

			ClientTel_Controller.prototype.addInsert = function(){
	ClientTel_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ФИО";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Телефон";options.required = true;
	var field = new FieldString("tel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Эл.почта";
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Должность";
	var field = new FieldString("post",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("search",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ClientTel_Controller.prototype.addUpdate = function(){
	ClientTel_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ФИО";
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Телефон";
	var field = new FieldString("tel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Эл.почта";
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Должность";
	var field = new FieldString("post",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("search",options);
	
	pm.addField(field);
	
	
}

			ClientTel_Controller.prototype.addDelete = function(){
	ClientTel_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ClientTel_Controller.prototype.addGetList = function(){
	ClientTel_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "ФИО";
	pm.addField(new FieldText("name",f_opts));
	var f_opts = {};
	f_opts.alias = "Телефон";
	pm.addField(new FieldString("tel",f_opts));
	var f_opts = {};
	f_opts.alias = "Эл.почта";
	pm.addField(new FieldString("email",f_opts));
	var f_opts = {};
	f_opts.alias = "Должность";
	pm.addField(new FieldString("post",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("search",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("tm_exists",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("tm_activated",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("search");
	
}

			ClientTel_Controller.prototype.addGetObject = function(){
	ClientTel_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ClientTel_Controller.prototype.addComplete = function(){
	ClientTel_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("search",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("search");	
}

			ClientTel_Controller.prototype.add_complete_tel = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_tel',opts);
	
				
	
	var options = {};
	
		options.maxlength = "200";
	
		pm.addField(new FieldString("search",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldBool("tm_exists",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
			
	this.addPublicMethod(pm);
}

			ClientTel_Controller.prototype.add_upsert = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('upsert',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("client_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "250";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("tel",options));
	
			
	this.addPublicMethod(pm);
}

			ClientTel_Controller.prototype.add_get_ref = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_ref',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("tel",options));
	
			
	this.addPublicMethod(pm);
}

		