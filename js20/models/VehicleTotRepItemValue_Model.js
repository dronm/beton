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

function VehicleTotRepItemValue_Model(options){
	var id = 'VehicleTotRepItemValue_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.vehicle_id = new FieldInt("vehicle_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.vehicle_tot_rep_item_id = new FieldInt("vehicle_tot_rep_item_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'First date of month';
	filed_options.autoInc = false;	
	
	options.fields.period = new FieldDate("period",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Ручное значение';
	filed_options.autoInc = false;	
	
	options.fields.value = new FieldFloat("value",filed_options);
	options.fields.value.getValidator().setMaxLength('15');
	
			
		VehicleTotRepItemValue_Model.superclass.constructor.call(this,id,options);
}
extend(VehicleTotRepItemValue_Model,ModelXML);

