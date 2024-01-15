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

function ProgUpdateDetail_Model(options){
	var id = 'ProgUpdateDetail_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Код сортирвки';
	filed_options.autoInc = false;	
	
	options.fields.code = new FieldInt("code",filed_options);
	options.fields.code.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Обновление';
	filed_options.autoInc = false;	
	
	options.fields.prog_update_id = new FieldInt("prog_update_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Описание';
	filed_options.autoInc = false;	
	
	options.fields.description = new FieldText("description",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Техническое описание';
	filed_options.autoInc = false;	
	
	options.fields.description_tech = new FieldText("description_tech",filed_options);
	
			
		ProgUpdateDetail_Model.superclass.constructor.call(this,id,options);
}
extend(ProgUpdateDetail_Model,ModelXML);

