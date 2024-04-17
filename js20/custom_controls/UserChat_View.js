/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends View
 * @requires core/extend.js
 * @requires controls/.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function UserChat_View(id,options){
	options = options || {};	
	
	options.template = window.getApp().getTemplate("UserChat_View");
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEADER = "Чат с сотрудниками";
	
	this.m_newMsgInControllerClass = UserChat_Controller;
	this.m_newMsgOutControllerClass = UserChat_Controller;
	this.m_newMsgInModelId = "UserChat_Model";
	this.m_newMsgOutModelId = "UserChat_Model";
	this.m_msgInEventId = "UserChat.insert";
	this.m_msgOutEventId = null;
	this.m_statusNodeId = "user_chat_status";

	let self = this;
	options.addElement = function(){
		
		this.addElement(new UserChatUserList(id+":contacts", {
			"onSelectUser": function(userNode){
				self.onSelectChat(userNode, true);				
			},
			"onSetSelectedUserNode": function(userNode){
				self.setSelectedUserNode(userNode);
			},
			"selectedUserClassId": this.SELECTED_USER_CLASS			
		}));	
		this.addElement(new ChatStatusEdit(id+":status", {
			"value": window.getApp().getChatStatusRef(),
			"contClassName": "recipEditCont", //no form-group	
			"onSelect":function(fields){
				let new_id = fields.id.getValue();
				if(!new_id){
					return;
				}
				let old_ref = window.getApp().getChatStatusRef();
				if(old_ref && old_ref.getKey && old_ref.getKey() == new_id){
					return;
				}
				self.setUserStatus(new RefType({"keys":{"id": new_id}, "descr": fields.name.getValue()}));
			}
		}));	

		this.addElement(new ControlContainer(id+":activeChat","DIV", {
		}));	

		this.addElement(new Control(id+":toggle","TEMPLATE", {
			"events":{
				"click":function(e){
					self.onToggleClick(e);
				}
			}
		}));
	}
	
	UserChat_View.superclass.constructor.call(this, id, options);
	
	//open common chat
	this.showChatHistory();
	
}
//ViewObjectAjx,ViewAjxList
extend(UserChat_View, Chat_View);

/* Constants */
UserChat_View.prototype.SELECTED_USER_CLASS = "selected_chat_user";

Chat_View.prototype.m_msgInEventId;
Chat_View.prototype.m_msgOutEventId;
/* private members */
UserChat_View.prototype.m_userList;
UserChat_View.prototype.m_selectedUserId; //if selected - opend private chat wiht the user
UserChat_View.prototype.m_selectedUserNode; //if selected - opend private chat wih the user


/* protected*/

UserChat_View.prototype.showChatHistory = function(recipient) {
	var hist_cont = this.getElement("activeChat");
	hist_cont.clear();
	let self = this;
	hist_cont.addElement(
		new UserChatNotification_View(this.getId() + ":notif", {
			"ref": recipient,
			"chatMode":true,
			"onClearContactUnviewdMsg": function(userId){
				self.clearContactUnviewdMsg(userId);
			},
			"onDecTotUnviewdMsg": function(unviewedMsgCnt){
				let tot = self.getTotUnviewdMsg() - unviewedMsgCnt;
				if(tot < 0){
					tot = 0;
				}
				self.setTotUnviewdMsg(tot);
			},
			"afterMessageSend":(function(histCont){
				return function(res){
					if(res===true){
						var nt = histCont.getElement("notif");
						nt.getElement("message").reset();
					}			
				}
			})(hist_cont)
		})
	);
	hist_cont.elementsToDOM();
	var notif = hist_cont.getElement("notif");
	if(notif){
		notif.getElement("message").focus();
	}
}

//called on selecting a new chat (private chat)
//or unselecting all chats (common)
UserChat_View.prototype.onSelectChat = function(userNode, interactive) {
	let user_id = userNode.getAttribute("user_id");
	let recipient;
	if(user_id == this.m_selectedUserId){
		//unselect, open common chat
		DOMHelper.delClass(userNode, this.SELECTED_USER_CLASS);
		this.m_selectedUserNode = undefined;
		this.m_selectedUserId = undefined;

	}else{
		if(this.m_selectedUserNode){
			DOMHelper.delClass(this.m_selectedUserNode, this.SELECTED_USER_CLASS);
		}

		//open private chat with user
		DOMHelper.addClass(userNode, this.SELECTED_USER_CLASS);
		this.m_selectedUserNode = userNode;
		this.m_selectedUserId = user_id;
		recipient = new RefType({"keys": {"id": user_id}, "descr": ""});
	}

	this.showChatHistory(recipient);
	
	//if(interactive && recipient){
		var notif = this.getElement("activeChat").getElement("notif");
		notif.setMsgViewedFromContact(recipient);
	//}
}

UserChat_View.prototype.setUserStatus = function(newStatRef) {
	let pm = (new UserChatStatus_Controller()).getPublicMethod("set");
	pm.setFieldValue("chat_status_id", newStatRef.getKey());
	let self = this;
	pm.run({
		"ok":function(resp){
			window.getApp().m_chatStatusRef = newStatRef;
			window.showTempWarn("Статус обновлен", null, 5000);
		}
	})

}


UserChat_View.prototype.clearContactUnviewdMsg = function(userId){
	//clear all unviewed from contact, dec total message count
	let user_node = document.getElementById("unviewd_msg_for_" + userId);
	if(!user_node){
		return;
	}
	DOMHelper.hide(user_node);
	user_node.textContent = "";
}

UserChat_View.prototype.addUnviewdMsgToContact = function(userId){
	//find table row and add unviewed message count
	let user_node = document.getElementById("unviewd_msg_for_" + userId);
	if(!user_node){
		return;
	}
	let user_msg = DOMHelper.getText(user_node);
	if(user_msg && user_msg.length){
		user_msg = parseInt(user_msg, 10);
	}
	if(isNaN(user_msg)){
		user_msg = 0;
	}
	user_msg++;
	DOMHelper.setText(user_node, user_msg);
	DOMHelper.show(user_node);
}

UserChat_View.prototype.show = function(){
	UserChat_View.superclass.show.call(this);
	
	var hist_cont = this.getElement("activeChat");
	if(!hist_cont){
		return;
	}
	var notif = hist_cont.getElement("notif");
	if(!notif){						
		return;
	}
	let msg_ctrl = notif.getElement("message");
	if(msg_ctrl){
		msg_ctrl.focus();
	}
	var cont = notif.getElement("history");
	var chat_n = $(cont.getNode());
	chat_n.scrollTop(chat_n[0].scrollHeight);						
	
	notif.setMsgViewedFromContact(this.m_selectedUserId? (new RefType({"keys": {"id": this.m_selectedUserId}, "descr": ""})) : null );
	
}

UserChat_View.prototype.onNewMessage = function(json){
	//if sender is me - do not show message
	if(json.eventId && json.eventId == "UserChat.common" && json.params.sender_id && json.params.sender_id == window.getApp().getServVar("user_id")){
		return;
	}

	this.msgBeep();
		
	if(json.eventId && json.eventId == "UserChat.common" && json.params){			
		//in message for common chat
		if(!this.m_selectedUserId){
			//common chat is opened - show message
			this.onAddNewMessage("in", json);
			
			let tot = this.getTotUnviewdMsg();
			this.setTotUnviewdMsg(++tot);		
			
			if(this.m_opened){
				//mark as seen
				let hist_cont = this.getElement("activeChat");
				if(hist_cont){
					let notif = hist_cont.getElement("notif");
					if(notif){
						notif.setMsgViewedFromContact(null);
					}
				}
			}
		}else{
			//else if private chat is opened - increase total number
			let tot = this.getTotUnviewdMsg();
			this.setTotUnviewdMsg(++tot);		
		}
		
	}else if(json.eventId && json.eventId == window.getApp().getServVar("chat_private_id") && json.params){	
		//which contact is open?
		if(this.m_selectedUserId && this.m_selectedUserId == json.params.sender_id){
			//private chat with this user is opened
			this.onAddNewMessage("in", json);
			
			this.addUnviewdMsgToContact(json.params.sender_id);			
			let tot = this.getTotUnviewdMsg();
			this.setTotUnviewdMsg(++tot);		
			
			if(this.m_opened){
				//mark as seen
				//this.clearContactUnviewdMsg(this.m_selectedUserId);
				let hist_cont = this.getElement("activeChat");
				if(hist_cont){
					let notif = hist_cont.getElement("notif");
					if(notif){
						notif.setMsgViewedFromContact(new RefType({"keys":{"id":this.m_selectedUserId}}));
					}
				}				
			}
			
		}else{
			//common chat or private chat with different user is opened
			this.addUnviewdMsgToContact(json.params.sender_id);			
			let tot = this.getTotUnviewdMsg();
			this.setTotUnviewdMsg(++tot);		
		}
		
	}else if(json.eventId && json.eventId == window.getApp().getServVar("chat_out_id") && json.params){
		//out message
		this.onAddNewMessage("out", json);
	}
}

//30 percent for this chat
UserChat_View.prototype.getLeftPos = function(){
	return (document.documentElement.clientWidth - (document.documentElement.clientWidth*40/100) - 10) + "px";
}

UserChat_View.prototype.setSelectedUserNode = function(selectedUserNode) {
	this.m_selectedUserNode = selectedUserNode;
}

UserChat_View.prototype.onAddNewMessageCont = function(msgType, json, message){
	let from_user_descr, to_user_id;
	if(msgType == "out"){
		from_user_descr = window.getApp().getServVar("user_name");
		to_user_id = json.params.receiver_id;
	}else{
		to_user_id = window.getApp().getServVar("user_id");
		from_user_descr = json.params.sender_descr;
	}
	this.addMsgToActiveContact(msgType, json.params.text, to_user_id, from_user_descr, json.params.media_type, message);
}

