/**	
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_js.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Model class. Created from template build/templates/models/Model_js.xsl. !!!DO NOT MODEFY!!!
 
 * @extends ModelXML
 
 * @requires core/extend.js
 * @requires core/ModelXML.js
 
 * @param {string} id 
 * @param {Object} options
 */

function ClientDestination_Model(options){
	var id = 'ClientDestination_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Клиент';
	filed_options.autoInc = false;	
	
	options.fields.client_id = new FieldInt("client_id",filed_options);
	options.fields.client_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Объект';
	filed_options.autoInc = false;	
	
	options.fields.destination_id = new FieldInt("destination_id",filed_options);
	options.fields.destination_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.lon = new FieldFloat("lon",filed_options);
	options.fields.lon.getValidator().setMaxLength('15');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.lat = new FieldFloat("lat",filed_options);
	options.fields.lat.getValidator().setMaxLength('15');
	
		ClientDestination_Model.superclass.constructor.call(this,id,options);
}
extend(ClientDestination_Model,ModelXML);

