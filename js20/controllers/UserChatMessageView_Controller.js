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

function UserChatMessageView_Controller(options){
	options = options || {};
	UserChatMessageView_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_set_all_viewed();
		
}
extend(UserChatMessageView_Controller,ControllerObjServer);

			UserChatMessageView_Controller.prototype.add_set_all_viewed = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set_all_viewed',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}

		