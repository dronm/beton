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

function PeriodValue_Model(options){
	var id = 'PeriodValue_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид значения';
	filed_options.autoInc = false;	
	
	options.fields.period_value_type = new FieldEnum("period_value_type",filed_options);
	filed_options.enumValues = 'destination_price,destination_price_for_driver,demurrage_cost_per_hour,water_ship_cost';
	options.fields.period_value_type.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Ключ';
	filed_options.autoInc = false;	
	
	options.fields.key = new FieldInt("key",filed_options);
	options.fields.key.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	
	filed_options.autoInc = false;	
	
	options.fields.date_time = new FieldDateTimeTZ("date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.val = new FieldText("val",filed_options);
	
			
		PeriodValue_Model.superclass.constructor.call(this,id,options);
}
extend(PeriodValue_Model,ModelXML);

