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

function Attachment_Controller(options){
	options = options || {};
	Attachment_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_delete_file();
	this.add_get_file();
	this.add_add_file();
		
}
extend(Attachment_Controller,ControllerObjServer);

			Attachment_Controller.prototype.add_delete_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('delete_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("ref",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("content_id",options));
	
			
	this.addPublicMethod(pm);
}

			Attachment_Controller.prototype.add_get_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("ref",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "36";
	
		pm.addField(new FieldString("content_id",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("inline",options));
	
			
	this.addPublicMethod(pm);
}

			Attachment_Controller.prototype.add_add_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('add_file',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("ref",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("content_data",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("content_info",options));
	
			
	this.addPublicMethod(pm);
}

		