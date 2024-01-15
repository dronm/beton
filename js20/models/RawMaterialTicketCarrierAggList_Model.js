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

function RawMaterialTicketCarrierAggList_Model(options){
	var id = 'RawMaterialTicketCarrierAggList_Model';
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
	
	options.fields.carriers_ref = new FieldJSON("carriers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Материал';
	filed_options.autoInc = false;	
	
	options.fields.raw_materials_ref = new FieldJSON("raw_materials_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вес, т';
	filed_options.autoInc = false;	
	
	options.fields.quant = new FieldInt("quant",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Количество';
	filed_options.autoInc = false;	
	
	options.fields.ticket_count = new FieldInt("ticket_count",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вес, т';
	filed_options.autoInc = false;	
	
	options.fields.quant_tot = new FieldInt("quant_tot",filed_options);
	
		RawMaterialTicketCarrierAggList_Model.superclass.constructor.call(this,id,options);
}
extend(RawMaterialTicketCarrierAggList_Model,ModelXML);

