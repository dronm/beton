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

function Client1c_Controller(options){
	options = options || {};
	Client1c_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addComplete();
		
}
extend(Client1c_Controller,ControllerObjServer);

			Client1c_Controller.prototype.addComplete = function(){
	Client1c_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldText("search",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("search");	
}

		