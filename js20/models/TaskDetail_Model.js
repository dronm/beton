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

function TaskDetail_Model(options){
	var id = 'TaskDetail_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Шапка задачи';
	filed_options.autoInc = false;	
	
	options.fields.task_id = new FieldInt("task_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Сотрудник';
	filed_options.autoInc = false;	
	
	options.fields.user_id = new FieldInt("user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	
	filed_options.autoInc = false;	
	
	options.fields.create_date_time = new FieldDateTimeTZ("create_date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	filed_options.alias = 'Информировать по email';
	filed_options.autoInc = false;	
	
	options.fields.inform_email = new FieldBool("inform_email",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	filed_options.alias = 'Информировать по sms';
	filed_options.autoInc = false;	
	
	options.fields.inform_sms = new FieldBool("inform_sms",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	filed_options.alias = 'Информировать по whatsup';
	filed_options.autoInc = false;	
	
	options.fields.inform_whatsup = new FieldBool("inform_whatsup",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.defValue = true;
	filed_options.alias = 'Информировать по telegram';
	filed_options.autoInc = false;	
	
	options.fields.inform_telegram = new FieldBool("inform_telegram",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Содержимое';
	filed_options.autoInc = false;	
	
	options.fields.content = new FieldText("content",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Просмотрена';
	filed_options.autoInc = false;	
	
	options.fields.open_date_time = new FieldDateTimeTZ("open_date_time",filed_options);
	
		TaskDetail_Model.superclass.constructor.call(this,id,options);
}
extend(TaskDetail_Model,ModelXML);

