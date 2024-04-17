/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024

 * @extends Notification_View
 * @requires core/extend.js
 * @requires controls/Notification_View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 * @param {function} options.afterMessageSend
 * @param {bool} options.tm_exists 
 */
function UserChatNotification_View(id,options){
	options = options || {};	
	
	
	options.msgOutControllerClass = UserChat_Controller;
	options.chatControllerClass = UserChat_Controller;
	options.chatModelId = "UserChatHistory_Model";
	options.chatFolder = "chat";
	
	this.m_onClearContactUnviewdMsg = options.onClearContactUnviewdMsg;
	this.m_onDecTotUnviewdMsg = options.onDecTotUnviewdMsg;
	
	UserChatNotification_View.superclass.constructor.call(this,id,options);
	
	/*if(options.ref){
		this.updateInf(options.ref? JSON.stringify(options.ref.toJSON()) : null);
	}*/		
	//do not mark messages as read
	this.getHistory();
}
//ViewObjectAjx,ViewAjxList
extend(UserChatNotification_View, Notification_View);

UserChatNotification_View.prototype.updateInf = function(refStr){
	this.getHistory(function(){
		this.setMsgViewedFromContact(CommonHelper.unserialize(refStr));
	});
}

UserChatNotification_View.prototype.setMsgViewedFromContactCont = function(userId, userUnviewedCnt){	
	this.m_onClearContactUnviewdMsg(userId);
	this.m_onDecTotUnviewdMsg(userUnviewedCnt);
}

UserChatNotification_View.prototype.setMsgViewedFromContact = function(ref){
	//call server method only if there are unviewed messages
	//ref can be null if it is a common chat
	let user_id, user_unviewed_cnt;
	if(ref){
		user_id = ref.getKey("id");
		let user_node = document.getElementById("unviewd_msg_for_" + user_id);
		
		if(!user_node || !user_node.textContent.length){
			return;
		}
		user_unviewed_cnt = parseInt(user_node.textContent, 10);
		if(isNaN(user_unviewed_cnt) || !user_unviewed_cnt){
			return;
		}
	}
	
	let pm = (new UserChatMessageView_Controller()).getPublicMethod("set_all_viewed");
	if(user_id){
		pm.setFieldValue("user_id", user_id);
	}else{
		pm.unsetFieldValue("user_id");
	}
	let self = this;
	pm.run({
		"ok":function(resp){
			self.setMsgViewedFromContactCont(user_id, user_unviewed_cnt);
		}
	});
}

UserChatNotification_View.prototype.onSubmit = function(callBack){
	var msg = this.getElement("message").getValue();
	if(!msg || !msg.length){
		this.getElement("message").setNotValid("Не заполнено");
		if(callBack){
			callBack(false);
		}
		return;
	}
	this.getElement("message").setValid();
	
	var pm = (new this.m_msgOutControllerClass()).getPublicMethod(this.SEND_MSG_PM);
	if(this.m_ref){
		pm.setFieldValue("recipient", JSON.stringify(this.m_ref.toJSON()));
	}else{
		pm.unsetFieldValue("recipient");
	}
	pm.setFieldValue("message", msg);
	
	this.getElement("message").setEnabled(false);
	window.setGlobalWait(true);
	var self = this;
	pm.run({
		"all":function(){
			window.setGlobalWait(false);
			self.getElement("message").setEnabled(true);
		}
		,"ok":function(){			
			if(!self.m_TM){
				window.showTempNote("Собщение отправлено",null,5000);
			}
			if(callBack){
				callBack(true);
			}
			
		}
	});
}

UserChatNotification_View.prototype.sendFileToServer = function(files, caption){
	let rec;
	if(this.m_ref && !this.m_ref.isNull()){
		rec = CommonHelper.serialize(this.m_ref); 
	}
	let pm = (new this.m_msgOutControllerClass()).getPublicMethod(this.SEND_ATT_PM);
	if(rec){
		pm.setFieldValue("recipient", rec);
	}else{
		pm.unsetFieldValue("recipient");
	}
	pm.setFieldValue("caption", caption);
	pm.setFieldValue("media_file", files);
	pm.run({
		"ok":function() {
			window.showTempNote("Файлы отправлены", null, 5000);
		}
	});
}

