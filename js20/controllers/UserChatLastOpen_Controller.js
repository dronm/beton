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

function UserChatLastOpen_Controller(options){
	options = options || {};
	UserChatLastOpen_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addUpdate();
		
}
extend(UserChatLastOpen_Controller,ControllerObjServer);

			UserChatLastOpen_Controller.prototype.addUpdate = function(){
	UserChatLastOpen_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	
}

		