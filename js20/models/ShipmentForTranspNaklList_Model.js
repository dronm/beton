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

function ShipmentForTranspNaklList_Model(options){
	var id = 'ShipmentForTranspNaklList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Номер';
	filed_options.autoInc = false;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Order ID';
	filed_options.autoInc = false;	
	
	options.fields.order_id = new FieldInt("order_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.date_time = new FieldDateTime("date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Shipment';
	filed_options.autoInc = false;	
	
	options.fields.shipments_ref = new FieldJSON("shipments_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Production site';
	filed_options.autoInc = false;	
	
	options.fields.production_sites_ref = new FieldJSON("production_sites_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Vehicle';
	filed_options.autoInc = false;	
	
	options.fields.vehicles_ref = new FieldJSON("vehicles_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Driver';
	filed_options.autoInc = false;	
	
	options.fields.drivers_ref = new FieldJSON("drivers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Driver sig';
	filed_options.autoInc = false;	
	
	options.fields.driver_sig_exists = new FieldBool("driver_sig_exists",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Operator';
	filed_options.autoInc = false;	
	
	options.fields.operators_ref = new FieldJSON("operators_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Operator sig';
	filed_options.autoInc = false;	
	
	options.fields.operator_sig_exists = new FieldBool("operator_sig_exists",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Carrier';
	filed_options.autoInc = false;	
	
	options.fields.carriers_ref = new FieldJSON("carriers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.carrier_ref_1c_exists = new FieldBool("carrier_ref_1c_exists",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Кол-во,м3';
	filed_options.autoInc = false;	
	
	options.fields.quant = new FieldFloat("quant",filed_options);
	
			
		ShipmentForTranspNaklList_Model.superclass.constructor.call(this,id,options);
}
extend(ShipmentForTranspNaklList_Model,ModelXML);

