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

function ShipmentTimeNorm_Model(options){
	var id = 'ShipmentTimeNorm_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Объем';
	filed_options.autoInc = false;	
	
	options.fields.id = new FieldInt("id",filed_options);
	options.fields.id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Норма минут';
	filed_options.autoInc = false;	
	
	options.fields.norm_min = new FieldInt("norm_min",filed_options);
	options.fields.norm_min.getValidator().setRequired(true);
	
		ShipmentTimeNorm_Model.superclass.constructor.call(this,id,options);
}
extend(ShipmentTimeNorm_Model,ModelXML);

