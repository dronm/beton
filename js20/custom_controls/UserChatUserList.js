/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends ControlContainer
 * @requires core/extend.js
 * @requires js20/controls/ViewTemplate.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function UserChatUserList(id,options){
	options = options || {};	
	
	options.publicMethod = (new UserChat_Controller()).getPublicMethod("get_user_list");
	options.autoRefresh = true;
	options.modelId = "UserChatUserList_Model";

	this.m_onSelectUser = options.onSelectUser;
	this.m_selectedUserClassId = options.selectedUserClassId;
	this.m_onSetSelectedUserNode = options.onSetSelectedUserNode;

	UserChatUserList.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(UserChatUserList, ViewTemplate);

/* Constants */


/* private members */
UserChatUserList.prototype.m_onSelectUser;

/* protected*/


/* public methods */

UserChatUserList.prototype.onAfterUpdateHTML = function(resp){
	let self = this;
	$(".chat_user").click(function(e){
		self.m_onSelectUser(e.target);
	});
	
	//restore selection
	if(this.m_selectedUserId){
		let users_n = DOMHelper.getElementsByAttr(this.m_selectedUserId, this.getNode(), "user_id", true);
		if(users_n && users_n.length){
			DOMHelper.addClass(users_n[0], this.m_selectedUserClassId);
			this.m_onSetSelectedUserNode(users_n[0]);
		}		
	}
}

//overridden
UserChatUserList.prototype.onBeforeUpdateHTML = function(resp){
	if(!this.m_modelId){
		return;
	}
	//get new model
	this.m_model = resp.getModel(this.m_modelId);
	if(!this.m_model){
		return;
	}
	
	//remember selected chat if any
	this.m_selectedUserId = undefined;
	let selected_users_n = DOMHelper.getElementsByAttr(this.m_selectedUserClassId, this.getNode(), "class", true);
	if(selected_users_n && selected_users_n.length){
		this.m_selectedUserId = selected_users_n[0].getAttribute("user_id");
	}
		
	//all rows/fields to template parameters
	let app = window.getApp();
	this.m_templateOptions = {"rows": []};
	while(this.m_model.getNextRow()){	
		let row = [];
		let fields = this.m_model.getFields();
		row["name"] = fields["name_short"].getValue();
		row["user_id"] = fields["id"].getValue();
		row["status"] = fields["chat_statuses_ref"].getValue().getDescr();
		
		row["unviewed_msg_cnt"] = fields["unviewed_msg_cnt"].getValue();
		if(!row["unviewed_msg_cnt"]){
			row["no_unviewed"] = true;
		}
		
		let is_online =  fields["is_online"].getValue();
		let role = app.getEnum("role_types", fields["role_id"].getValue());
		row["user_title"] = fields["name"].getValue() + ", " + role;
		if(is_online){
			row["user_title"] += ", в сети"; 
			row["user_img"] = "img/dot_green.png";
		}else{
			row["user_title"] += ", не в сети"; 
			row["user_img"] = "img/dot_red.png";
		}
		if(row["status"]){
			row["user_title"] += ", " + row["status"];
		}
		this.m_templateOptions.rows.push(row);
	}	
}	

