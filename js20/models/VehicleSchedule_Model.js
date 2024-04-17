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

function VehicleSchedule_Model(options){
	var id = 'VehicleSchedule_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Код';
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.schedule_date = new FieldDate("schedule_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Автомобиль';
	filed_options.autoInc = false;	
	
	options.fields.vehicle_id = new FieldInt("vehicle_id",filed_options);
	options.fields.vehicle_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Водитель';
	filed_options.autoInc = false;	
	
	options.fields.driver_id = new FieldInt("driver_id",filed_options);
	options.fields.driver_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'База';
	filed_options.autoInc = false;	
	
	options.fields.production_base_id = new FieldInt("production_base_id",filed_options);
	options.fields.production_base_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Кто внес данные';
	filed_options.autoInc = false;	
	
	options.fields.edit_user_id = new FieldInt("edit_user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Когда внес данные';
	filed_options.autoInc = false;	
	
	options.fields.edit_date_time = new FieldDateTimeTZ("edit_date_time",filed_options);
	
			
			
			
		VehicleSchedule_Model.superclass.constructor.call(this,id,options);
}
extend(VehicleSchedule_Model,ModelXML);

