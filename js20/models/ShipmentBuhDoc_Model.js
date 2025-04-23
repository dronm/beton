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

function ShipmentBuhDoc_Model(options){
	var id = 'ShipmentBuhDoc_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.ref_1c = new FieldString("ref_1c",filed_options);
	options.fields.ref_1c.getValidator().setMaxLength('36');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.nomer = new FieldText("nomer",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Formatted document datetime';
	filed_options.autoInc = false;	
	
	options.fields.data = new FieldText("data",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.faktura_nomer = new FieldText("faktura_nomer",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Formatted document datetime';
	filed_options.autoInc = false;	
	
	options.fields.faktura_data = new FieldText("faktura_data",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.shipment_ids = new FieldArray("shipment_ids",filed_options);
	
		ShipmentBuhDoc_Model.superclass.constructor.call(this,id,options);
}
extend(ShipmentBuhDoc_Model,ModelXML);

