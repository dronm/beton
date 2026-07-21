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

function ShipmentWeight_Model(options){
	var id = 'ShipmentWeight_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Код';
	filed_options.autoInc = false;	
	
	options.fields.shipment_id = new FieldInt("shipment_id",filed_options);
	options.fields.shipment_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.date_time = new FieldDateTime("date_time",filed_options);
	options.fields.date_time.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Брутто';
	filed_options.autoInc = false;	
	
	options.fields.quant_gross = new FieldFloat("quant_gross",filed_options);
	options.fields.quant_gross.getValidator().setMaxLength('19');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Нетто';
	filed_options.autoInc = false;	
	
	options.fields.quant_net = new FieldFloat("quant_net",filed_options);
	options.fields.quant_net.getValidator().setMaxLength('19');
	
		ShipmentWeight_Model.superclass.constructor.call(this,id,options);
}
extend(ShipmentWeight_Model,ModelXML);

