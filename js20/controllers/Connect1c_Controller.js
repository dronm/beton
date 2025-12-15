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

function Connect1c_Controller(options){
	options = options || {};
	Connect1c_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_complete_user();
		
}
extend(Connect1c_Controller,ControllerObjServer);

			Connect1c_Controller.prototype.add_complete_user = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_user',opts);
	
				
	
	var options = {};
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("search",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
			
	this.addPublicMethod(pm);
}

		