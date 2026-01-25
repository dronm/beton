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
	this.add_complete_item();
	this.add_service_stop();
	this.add_service_start();
	this.add_service_health();
	this.add_service_status();
	this.add_production_report_export();
		
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

			Connect1c_Controller.prototype.add_complete_item = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_item',opts);
	
				
	
	var options = {};
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("search",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
			
	this.addPublicMethod(pm);
}

			Connect1c_Controller.prototype.add_service_stop = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('service_stop',opts);
	
	this.addPublicMethod(pm);
}

			Connect1c_Controller.prototype.add_service_start = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('service_start',opts);
	
	this.addPublicMethod(pm);
}

			Connect1c_Controller.prototype.add_service_health = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('service_health',opts);
	
	this.addPublicMethod(pm);
}

			Connect1c_Controller.prototype.add_service_status = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('service_status',opts);
	
	this.addPublicMethod(pm);
}

			Connect1c_Controller.prototype.add_production_report_export = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('production_report_export',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("id",options));
	
			
	this.addPublicMethod(pm);
}

		