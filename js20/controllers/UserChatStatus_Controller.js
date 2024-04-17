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

function UserChatStatus_Controller(options){
	options = options || {};
	UserChatStatus_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_set();
	this.add_get_select_list();
		
}
extend(UserChatStatus_Controller,ControllerObjServer);

			UserChatStatus_Controller.prototype.add_set = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("chat_status_id",options));
	
			
	this.addPublicMethod(pm);
}

			UserChatStatus_Controller.prototype.add_get_select_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_select_list',opts);
	
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

	this.addPublicMethod(pm);
}

		