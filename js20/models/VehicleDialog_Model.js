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

function VehicleDialog_Model(options){
	var id = 'VehicleDialog_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Код';
	filed_options.autoInc = false;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Номер';
	filed_options.autoInc = false;	
	
	options.fields.plate = new FieldString("plate",filed_options);
	options.fields.plate.getValidator().setRequired(true);
	options.fields.plate.getValidator().setMaxLength('6');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Грузоподъемность';
	filed_options.autoInc = false;	
	
	options.fields.load_capacity = new FieldFloat("load_capacity",filed_options);
	options.fields.load_capacity.getValidator().setRequired(true);
	options.fields.load_capacity.getValidator().setMaxLength('15');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Марка';
	filed_options.autoInc = false;	
	
	options.fields.make = new FieldString("make",filed_options);
	options.fields.make.getValidator().setMaxLength('200');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.drivers_ref = new FieldJSONB("drivers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Свойство';
	filed_options.autoInc = false;	
	
	options.fields.feature = new FieldString("feature",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Трэкер';
	filed_options.autoInc = false;	
	
	options.fields.tracker_id = new FieldString("tracker_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Идентификатор SIM карты';
	filed_options.autoInc = false;	
	
	options.fields.sim_id = new FieldString("sim_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Номер телефона SIM карты';
	filed_options.autoInc = false;	
	
	options.fields.sim_number = new FieldString("sim_number",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.tracker_last_dt = new FieldDateTimeTZ("tracker_last_dt",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.tracker_sat_num = new FieldInt("tracker_sat_num",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Последний владелец';
	filed_options.autoInc = false;	
	
	options.fields.vehicle_owners_ref = new FieldJSONB("vehicle_owners_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Последний владелец';
	filed_options.autoInc = false;	
	
	options.fields.vehicle_owner_id = new FieldInt("vehicle_owner_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'История владелецев';
	filed_options.autoInc = false;	
	
	options.fields.vehicle_owners = new FieldJSONB("vehicle_owners",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.vehicle_owners_ar = new FieldArray("vehicle_owners_ar",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.ord_num = new FieldInt("ord_num",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Масса, тонн';
	filed_options.autoInc = false;	
	
	options.fields.weight_t = new FieldInt("weight_t",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'VIN';
	filed_options.autoInc = false;	
	
	options.fields.vin = new FieldString("vin",filed_options);
	options.fields.vin.getValidator().setMaxLength('17');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.leasor = new FieldText("leasor",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.leasing_contract_date = new FieldDate("leasing_contract_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.leasing_contract_num = new FieldText("leasing_contract_num",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.leasing_total = new FieldFloat("leasing_total",filed_options);
	options.fields.leasing_total.getValidator().setMaxLength('15');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Insurance osago data';
	filed_options.autoInc = false;	
	
	options.fields.insurance_osago = new FieldJSONB("insurance_osago",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Insurance kasko data';
	filed_options.autoInc = false;	
	
	options.fields.insurance_kasko = new FieldJSONB("insurance_kasko",filed_options);
	
			
		VehicleDialog_Model.superclass.constructor.call(this,id,options);
}
extend(VehicleDialog_Model,ModelXML);

