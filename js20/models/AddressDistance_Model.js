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

function AddressDistance_Model(options){
	var id = 'AddressDistance_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'address md5';
	filed_options.autoInc = false;	
	
	options.fields.hash = new FieldString("hash",filed_options);
	options.fields.hash.getValidator().setMaxLength('36');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Адрес';
	filed_options.autoInc = false;	
	
	options.fields.address = new FieldText("address",filed_options);
	options.fields.address.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.route = new Fieldgeometry("route",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Расстояние';
	filed_options.autoInc = false;	
	
	options.fields.distance = new FieldFloat("distance",filed_options);
	options.fields.distance.getValidator().setMaxLength('15');
	
		AddressDistance_Model.superclass.constructor.call(this,id,options);
}
extend(AddressDistance_Model,ModelXML);

