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

function MaxOutMessage_Controller(options){
	options = options || {};
	options.listModelClass = MaxOutMessageList_Model;
	options.objModelClass = MaxOutMessageList_Model;
	MaxOutMessage_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
	this.add_send();
	this.add_send_media();
	this.add_invite();
	this.add_invite_contact();
	this.add_get_recipient_inf();
		
}
extend(MaxOutMessage_Controller,ControllerObjServer);

			MaxOutMessage_Controller.prototype.addGetList = function(){
	MaxOutMessage_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldJSONB("message",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("created_at",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("sent_at",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("max_chat_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("contact_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("contacts_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("errors_str",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("created_at");
	
}

			MaxOutMessage_Controller.prototype.addGetObject = function(){
	MaxOutMessage_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			MaxOutMessage_Controller.prototype.add_send = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("message",options));
	
			
	this.addPublicMethod(pm);
}

			MaxOutMessage_Controller.prototype.add_send_media = function(){
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

			MaxOutMessage_Controller.prototype.add_invite = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('invite',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
			
	this.addPublicMethod(pm);
}

			MaxOutMessage_Controller.prototype.add_invite_contact = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('invite_contact',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("contact_id",options));
	
			
	this.addPublicMethod(pm);
}

			MaxOutMessage_Controller.prototype.add_get_recipient_inf = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_recipient_inf',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
			
	this.addPublicMethod(pm);
}

		