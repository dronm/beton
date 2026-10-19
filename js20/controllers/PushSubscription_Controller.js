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

function PushSubscription_Controller(options){
	options = options || {};
	PushSubscription_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_get_vapid_public_key();
	this.add_get_status();
	this.add_subscribe();
	this.add_unsubscribe();
		
}
extend(PushSubscription_Controller,ControllerObjServer);

			PushSubscription_Controller.prototype.add_get_vapid_public_key = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_vapid_public_key',opts);
	
	this.addPublicMethod(pm);
}


			PushSubscription_Controller.prototype.add_get_status = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_status',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("endpoint",options));
	
			
	this.addPublicMethod(pm);
}


			PushSubscription_Controller.prototype.add_subscribe = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('subscribe',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("endpoint",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("p256dh",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("auth",options));
	
			
	this.addPublicMethod(pm);
}


			PushSubscription_Controller.prototype.add_unsubscribe = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('unsubscribe',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("endpoint",options));
	
			
	this.addPublicMethod(pm);
}

		