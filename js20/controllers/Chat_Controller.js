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

function Chat_Controller(options){
	options = options || {};
	Chat_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_get_history();
		
}
extend(Chat_Controller,ControllerObjServer);

			Chat_Controller.prototype.add_get_history = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_history',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("recipient",options));
	
			
	this.addPublicMethod(pm);
}

		