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

function ConnectElkonCheck_Controller(options){
	options = options || {};
	ConnectElkonCheck_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_connected();
		
}
extend(ConnectElkonCheck_Controller,ControllerObjServer);

			ConnectElkonCheck_Controller.prototype.add_connected = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('connected',opts);
	
	this.addPublicMethod(pm);
}

		