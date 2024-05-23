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

function RawMaterialTicketList_Model(options){
	var id = 'RawMaterialTicketList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Перевозчик';
	filed_options.autoInc = false;	
	
	options.fields.carrier_id = new FieldInt("carrier_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Перевозчик';
	filed_options.autoInc = false;	
	
	options.fields.carriers_ref = new FieldJSON("carriers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Материал';
	filed_options.autoInc = false;	
	
	options.fields.raw_material_id = new FieldInt("raw_material_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Материал';
	filed_options.autoInc = false;	
	
	options.fields.raw_materials_ref = new FieldJSON("raw_materials_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Карьер';
	filed_options.autoInc = false;	
	
	options.fields.quarry_id = new FieldInt("quarry_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Карьер';
	filed_options.autoInc = false;	
	
	options.fields.quarries_ref = new FieldJSON("quarries_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Штрихкод';
	filed_options.autoInc = false;	
	
	options.fields.barcode = new FieldString("barcode",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вес, т';
	filed_options.autoInc = false;	
	
	options.fields.quant = new FieldInt("quant",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.issue_date_time = new FieldDateTimeTZ("issue_date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.close_date_time = new FieldDateTimeTZ("close_date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Кто выпустил';
	filed_options.autoInc = false;	
	
	options.fields.issue_users_ref = new FieldJSON("issue_users_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.issue_user_id = new FieldInt("issue_user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Кто погасил';
	filed_options.autoInc = false;	
	
	options.fields.close_users_ref = new FieldJSON("close_users_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.close_user_id = new FieldInt("close_user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата окончания срока';
	filed_options.autoInc = false;	
	
	options.fields.expire_date = new FieldDate("expire_date",filed_options);
	
		RawMaterialTicketList_Model.superclass.constructor.call(this,id,options);
}
extend(RawMaterialTicketList_Model,ModelXML);

