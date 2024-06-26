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

function ShipmentPumpForVehOwnerList_Model(options){
	var id = 'ShipmentPumpForVehOwnerList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.last_ship_id = new FieldInt("last_ship_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.date_time = new FieldDateTime("date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Объект';
	filed_options.autoInc = false;	
	
	options.fields.destinations_ref = new FieldJSON("destinations_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.destination_id = new FieldInt("destination_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Марка';
	filed_options.autoInc = false;	
	
	options.fields.concrete_types_ref = new FieldJSON("concrete_types_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.concrete_type_id = new FieldInt("concrete_type_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Количество';
	filed_options.autoInc = false;	
	
	options.fields.quant = new FieldFloat("quant",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Стоимость';
	filed_options.autoInc = false;	
	
	options.fields.pump_cost = new FieldFloat("pump_cost",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Автомобиль';
	filed_options.autoInc = false;	
	
	options.fields.pump_vehicles_ref = new FieldJSON("pump_vehicles_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.pump_vehicle_id = new FieldInt("pump_vehicle_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.pump_vehicle_owner_id = new FieldInt("pump_vehicle_owner_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Владелец';
	filed_options.autoInc = false;	
	
	options.fields.pump_vehicle_owners_ref = new FieldJSON("pump_vehicle_owners_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Комментарий бухгалетрии';
	filed_options.autoInc = false;	
	
	options.fields.acc_comment = new FieldText("acc_comment",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Согласовано насос';
	filed_options.autoInc = false;	
	
	options.fields.owner_pump_agreed = new FieldBool("owner_pump_agreed",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата согласования насос';
	filed_options.autoInc = false;	
	
	options.fields.owner_pump_agreed_date_time = new FieldDateTimeTZ("owner_pump_agreed_date_time",filed_options);
	
			
			
		ShipmentPumpForVehOwnerList_Model.superclass.constructor.call(this,id,options);
}
extend(ShipmentPumpForVehOwnerList_Model,ModelXML);

