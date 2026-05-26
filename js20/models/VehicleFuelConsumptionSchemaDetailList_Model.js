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

function VehicleFuelConsumptionSchemaDetailList_Model(options){
	var id = 'VehicleFuelConsumptionSchemaDetailList_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.vehicle_id = new FieldInt("vehicle_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.vehicles_ref = new FieldJSON("vehicles_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '1-12';
	filed_options.autoInc = false;	
	
	options.fields.month_from = new FieldInt("month_from",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '1-12';
	filed_options.autoInc = false;	
	
	options.fields.month_to = new FieldInt("month_to",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Расход на 100 км';
	filed_options.autoInc = false;	
	
	options.fields.quant_distance = new FieldFloat("quant_distance",filed_options);
	options.fields.quant_distance.getValidator().setMaxLength('15');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Расход на 1 час';
	filed_options.autoInc = false;	
	
	options.fields.quant_time = new FieldFloat("quant_time",filed_options);
	options.fields.quant_time.getValidator().setMaxLength('15');
	
		VehicleFuelConsumptionSchemaDetailList_Model.superclass.constructor.call(this,id,options);
}
extend(VehicleFuelConsumptionSchemaDetailList_Model,ModelXML);

