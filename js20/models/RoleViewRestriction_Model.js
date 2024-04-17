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

function RoleViewRestriction_Model(options){
	var id = 'RoleViewRestriction_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
			
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Роль';
	filed_options.autoInc = false;	
	
	options.fields.role_id = new FieldEnum("role_id",filed_options);
	filed_options.enumValues = 'admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing';
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Сколько дней разрешено для просмотра назад';
	filed_options.autoInc = false;	
	
	options.fields.back_days_allowed = new FieldInt("back_days_allowed",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Сколько дней разрешено для просмотра вперед';
	filed_options.autoInc = false;	
	
	options.fields.front_days_allowed = new FieldInt("front_days_allowed",filed_options);
	
		RoleViewRestriction_Model.superclass.constructor.call(this,id,options);
}
extend(RoleViewRestriction_Model,ModelXML);

