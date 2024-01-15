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

function Firm1c_Model(options){
	var id = 'Firm1c_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Ссылка на справочник 1с';
	filed_options.autoInc = false;	
	
	options.fields.ref_1c = new FieldJSONB("ref_1c",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'ИНН';
	filed_options.autoInc = false;	
	
	options.fields.inn = new FieldString("inn",filed_options);
	options.fields.inn.getValidator().setMaxLength('12');
	
			
		Firm1c_Model.superclass.constructor.call(this,id,options);
}
extend(Firm1c_Model,ModelXML);

