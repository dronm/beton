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

function ProductionSite_Model(options){
	var id = 'ProductionSite_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.name = new FieldString("name",filed_options);
	options.fields.name.getValidator().setMaxLength('100');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.elkon_connection = new FieldJSONB("elkon_connection",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.elkon_params = new FieldJSONB("elkon_params",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Активен';
	filed_options.autoInc = false;	
	
	options.fields.active = new FieldBool("active",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.last_elkon_production_id = new FieldInt("last_elkon_production_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.missing_elkon_production_ids = new FieldArray("missing_elkon_production_ids",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Зона';
	filed_options.autoInc = false;	
	
	options.fields.destination_id = new FieldInt("destination_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид завода';
	filed_options.autoInc = false;	
	
	options.fields.production_plant_type = new FieldEnum("production_plant_type",filed_options);
	filed_options.enumValues = 'elkon,ammann';
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'База';
	filed_options.autoInc = false;	
	
	options.fields.production_base_id = new FieldInt("production_base_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Диспетчер (ТТН)';
	filed_options.autoInc = false;	
	
	options.fields.dispatcher_id = new FieldInt("dispatcher_id",filed_options);
	
		ProductionSite_Model.superclass.constructor.call(this,id,options);
}
extend(ProductionSite_Model,ModelXML);

