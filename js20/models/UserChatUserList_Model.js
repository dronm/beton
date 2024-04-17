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

function UserChatUserList_Model(options){
	var id = 'UserChatUserList_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Пользователь';
	filed_options.autoInc = false;	
	
	options.fields.name = new FieldString("name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Пользователm ФИО';
	filed_options.autoInc = false;	
	
	options.fields.name_short = new FieldString("name_short",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Статус';
	filed_options.autoInc = false;	
	
	options.fields.chat_statuses_ref = new FieldJSON("chat_statuses_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Роль';
	filed_options.autoInc = false;	
	
	options.fields.role_id = new FieldString("role_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'В сети';
	filed_options.autoInc = false;	
	
	options.fields.is_online = new FieldBool("is_online",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Непрочитанные сообщения';
	filed_options.autoInc = false;	
	
	options.fields.unviewed_msg_cnt = new FieldInt("unviewed_msg_cnt",filed_options);
	
		UserChatUserList_Model.superclass.constructor.call(this,id,options);
}
extend(UserChatUserList_Model,ModelXML);

