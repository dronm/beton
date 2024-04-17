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

function TmOutMessage_Controller(options){
	options = options || {};
	options.listModelClass = TmOutMessageList_Model;
	options.objModelClass = TmOutMessageList_Model;
	TmOutMessage_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
	this.add_send();
	this.add_send_media();
	this.add_tm_invite();
	this.add_tm_invite_contact();
	this.add_get_recipient_inf();
		
}
extend(TmOutMessage_Controller,ControllerObjServer);

			TmOutMessage_Controller.prototype.addGetList = function(){
	TmOutMessage_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("app_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("message",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTime("sent_date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("sent",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("ext_obj",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("first_name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("sent_date_time");
	
}

			TmOutMessage_Controller.prototype.addGetObject = function(){
	TmOutMessage_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			TmOutMessage_Controller.prototype.add_send = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("message",options));
	
			
	this.addPublicMethod(pm);
}

			TmOutMessage_Controller.prototype.add_send_media = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send_media',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("caption",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("media_file",options));
	
			
	this.addPublicMethod(pm);
}

			TmOutMessage_Controller.prototype.add_tm_invite = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_invite',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
			
	this.addPublicMethod(pm);
}

			TmOutMessage_Controller.prototype.add_tm_invite_contact = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_invite_contact',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("contact_id",options));
	
			
	this.addPublicMethod(pm);
}

			TmOutMessage_Controller.prototype.add_get_recipient_inf = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_recipient_inf',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
			
	this.addPublicMethod(pm);
}

		