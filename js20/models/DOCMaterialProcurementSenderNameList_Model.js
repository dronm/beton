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

function DOCMaterialProcurementSenderNameList_Model(options){
	var id = 'DOCMaterialProcurementSenderNameList_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Пункт отправления';
	filed_options.autoInc = false;	
	
	options.fields.sender_name = new FieldString("sender_name",filed_options);
	
		DOCMaterialProcurementSenderNameList_Model.superclass.constructor.call(this,id,options);
}
extend(DOCMaterialProcurementSenderNameList_Model,ModelXML);

