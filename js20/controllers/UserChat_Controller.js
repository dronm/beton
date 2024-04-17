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

function UserChat_Controller(options){
	options = options || {};
	options.objModelClass = UserChat_Model;
	UserChat_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetObject();
	this.add_get_user_list();
	this.add_send();
	this.add_send_media();
	this.add_get_history();
		
}
extend(UserChat_Controller,ControllerObjServer);

			UserChat_Controller.prototype.addGetObject = function(){
	UserChat_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			UserChat_Controller.prototype.add_get_user_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_user_list',opts);
	
	this.addPublicMethod(pm);
}

			UserChat_Controller.prototype.add_send = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("recipient",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("message",options));
	
			
	this.addPublicMethod(pm);
}

			UserChat_Controller.prototype.add_send_media = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send_media',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("recipient",options));
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("caption",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("media_file",options));
	
			
	this.addPublicMethod(pm);
}

			UserChat_Controller.prototype.add_get_history = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_history',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("recipient",options));
	
			
	this.addPublicMethod(pm);
}

		