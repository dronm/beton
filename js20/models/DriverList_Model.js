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

function DriverList_Model(options){
	var id = 'DriverList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Код';
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование';
	filed_options.autoInc = false;	
	
	options.fields.name = new FieldString("name",filed_options);
	options.fields.name.getValidator().setRequired(true);
	options.fields.name.getValidator().setMaxLength('50');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Водительское удостоверение';
	filed_options.autoInc = false;	
	
	options.fields.driver_licence = new FieldText("driver_licence",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Класс водительского удостоверения';
	filed_options.autoInc = false;	
	
	options.fields.driver_licence_class = new FieldString("driver_licence_class",filed_options);
	options.fields.driver_licence_class.getValidator().setMaxLength('10');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Контакты';
	filed_options.autoInc = false;	
	
	options.fields.contact_list = new FieldJSON("contact_list",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Контакты';
	filed_options.autoInc = false;	
	
	options.fields.contact_ids = new FieldText("contact_ids",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Официально устроен';
	filed_options.autoInc = false;	
	
	options.fields.employed = new FieldBool("employed",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'ИНН водителя';
	filed_options.autoInc = false;	
	
	options.fields.inn = new FieldText("inn",filed_options);
	
		DriverList_Model.superclass.constructor.call(this,id,options);
}
extend(DriverList_Model,ModelXML);

