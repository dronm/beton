/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 *	Gets all events TmOutMessage.sent,TmInMessage.insert
 
 * @param {string} id - Object identifier
 * @param {object} options

 * @param {function} options.afterMessageSend
 
 */
function TmChat_View(id,options){
	options = options || {};	
	
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEADER = "Чат Telegram";
	
	this.m_newMsgInControllerClass = TmInMessage_Controller;
	this.m_newMsgOutControllerClass = TmOutMessage_Controller;
	this.m_newMsgInModelId = "TmInMessageList_Model";
	this.m_newMsgOutModelId = "TmOutMessageList_Model";
	
	this.m_statusNodeId = "tm_status";
	
	var self = this;
	options.addElement = function(){
		this.addElement(new ContactEdit(id+":recipient",{
			"labelCaption":"Найти контакт:",
			"tm_activated": true,
			"contClassName": "recipEditCont", //no form-group	
			"onSelect":function(f){
				var ctrl = self.getElement("recipient");
				if(ctrl){
					var v = ctrl.getValue();
					if(v && !v.isNull()){
						v.m_dataType = "contacts";
						self.addContact(v, true, f.tm_photo.getValue(), f.ext_id.getValue());
						self.getElement("recipient").reset();
					}
				}
			}
		}));
		
		this.addElement(new ControlContainer(id+":contacts","DIV", {
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

		this.addElement(new Control(id+":unviewedMsg","TEMPLATE", {
		}));
		
	}
	TmChat_View.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(TmChat_View, Chat_View);

/* Constants */

TmChat_View.prototype.EVENT_ID_IN_MSG = "TmInMessage.insert";
TmChat_View.prototype.EVENT_ID_OUT_MSG =  "TmOutMessage.sent";

/* private members */
TmChat_View.prototype.m_currentContId; //selected container ID

/* protected*/

//checks if container with the given ID is present in the container
TmChat_View.prototype.contactExists = function(keyId){
	var contacts = this.getElement("contacts").getElements();
	for(var id in contacts){
		if(id == "k_"+keyId && contacts[id]){
			return true;
		}
	}
	return false;
}

//Event handler on new message
TmChat_View.prototype.onNewMessage = function(json){
	
	if(json.eventId && json.eventId == this.EVENT_ID_IN_MSG
	&& json.params && json.params.ext_obj && json.params.ext_obj.m_keys && json.params.ext_obj.m_keys.id){
		//in message
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && !contact_active){
			this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			this.msgBeep();
			
		}else if(contact_exists && contact_active){			
			//retrieve message by id	
			//TODO: add user photo
			this.onAddNewMessage("in", json);
			this.msgBeep();
			
		}else if(!contact_exists){
			//no contact
			this.addContact(json.params.ext_obj, true);
			if(!this.m_opened){
				this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			}
			this.msgBeep();
		}
		
	}else if(json.eventId && json.eventId == this.EVENT_ID_OUT_MSG
	&& json.params && json.params.res != undefined && json.params.res === false
	&& json.params.errText && json.params.errText.length){
		//error out message	
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && contact_active){
			this.msgBeep();
			window.showError(json.params.errText,null,5000);
		}
	
	}else if(json.eventId && json.eventId == this.EVENT_ID_OUT_MSG
	&& json.params && json.params.res !=undefined && json.params.res === true
	&& json.params.ext_obj && json.params.ext_obj.m_keys && json.params.ext_obj.m_keys.id){
		//out message ok
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && !contact_active){
			this.msgBeep();
			this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			
		}else if(contact_exists && contact_active){
			this.msgBeep();
			this.onAddNewMessage("out", json);
		}
	}	
}

TmChat_View.prototype.onAddNewMessageCont = function(msgType, json, message){
	this.addMsgToActiveContact(msgType, json.params.text, json.params.ext_obj.m_keys.id, json.params.sender.m_descr, json.params.media_type, message);
	if(!this.m_opened){
		this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
	}
}

TmChat_View.prototype.setTotUnviewdMsg = function(msgCount){
	TmChat_View.superclass.setTotUnviewdMsg.call(this, msgCount);
	
	if(isNaN(msgCount) || msgCount <= 0){
		msgCount = "";
	}
	var tot_uv_ctrl = this.getElement("unviewedMsg");
	tot_uv_ctrl.setValue(msgCount);
	
	if(msgCount == ""){
		tot_uv_ctrl.delAttr("class");
	}else{
		tot_uv_ctrl.setAttr("class", "badge badge-danger");
	}
}

TmChat_View.prototype.clearContactUnviewdMsg = function(contactId){
	var ctrl = this.getElement("contacts");
	if(!ctrl){
		return;
	}
	
	var contact_cont = ctrl.getElement("k_" + contactId);
	if(!contact_cont){
		return;
	}
	
	var unv_ctrl = contact_cont.getElement("contact_unviewed");
	if(!unv_ctrl){
		return;
	}
	var cont_cnt = parseInt(unv_ctrl.getValue(), 10);
	if(!cont_cnt || isNaN(cont_cnt)){
		cont_cnt = 0;
	}
	unv_ctrl.setValue(""); //clear
	
	let tot_cnt = this.getTotUnviewdMsg();
	this.setTotUnviewdMsg(tot_cnt - cont_cnt);
}

TmChat_View.prototype.addUnviewdMsgToContact = function(contactId){
	var ctrl = this.getElement("contacts");
	if(!ctrl)return;
	var contact_cont = ctrl.getElement("k_"+contactId);
	if(!contact_cont)return;
	var unv_ctrl = contact_cont.getElement("contact_unviewed");
	if(!unv_ctrl)return;
	var v = parseInt(unv_ctrl.getValue(), 10);
	if(!v || isNaN(v)){
		v = 0;
	}
	unv_ctrl.setValue(++v);
	
	let tot_cnt = this.getTotUnviewdMsg();
	this.setTotUnviewdMsg(++tot_cnt);
}

TmChat_View.prototype.show = function(){
	TmChat_View.superclass.show.call(this);
	
	if(this.m_currentContId && this.m_currentContId.length){
		var hist_cont = this.getElement("activeChat");
		if(hist_cont){
			var notif = hist_cont.getElement("notif");
			if(notif){
				let msg_ctrl = notif.getElement("message");
				if(msg_ctrl){
					msg_ctrl.focus();
				}
				var cont = notif.getElement("history");
				var chat_n = $(cont.getNode());
				chat_n.scrollTop(chat_n[0].scrollHeight);						
			}
		}		
		this.clearContactUnviewdMsg(this.m_currentContId.substr(2));
		
	}else{
		this.getElement("recipient").focus();
	}
}

//called on adding a new contact to list
TmChat_View.prototype.addContact = function(ref, makeCurrent, tmPhoto, tmId){
	var ctrl = this.getElement("contacts");
	if(!ctrl)return;
	
	var self = this;
	var cont_id = "k_"+ref.getKey("id");
	var cont = new ControlContainer(cont_id, "DIV",{
		"attrs":{"class":"chatContactCont"},
		"events":{
			"click":(function(contId){
				return function(e){
					e.stopPropagation();
					self.onSelectChat(contId, true);
				}
			})(cont_id)
		},		
		"elements":[
			//photo
			new Control(cont_id+":contact_photo", "IMG", {
				"attrs":{"class":"contactPhoto", "src": tmPhoto? "data:image/png;base64, "+tmPhoto : "#"}
			}),
			
			//contact name
			new Control(cont_id+":contact", "SPAN", {
				"attrs":{"class":"chatContact"},
				"value":ref.getDescr()
			}),
			
			//contact unviewed count
			new Control(cont_id+":contact_unviewed", "SPAN", {
				"attrs":{"class":"badge badge-danger"},
				"title":"Непрочитанные сообщения"
			}),
			
			//contact close button
			new Control(cont_id+":contact_cl", "SPAN", {
				"attrs":{"class":"chatContactClose"},
				"value":"X",
				"title":"Удалить контакт",
				"events":{
					"click":(function(contId){
						return function(e){
							e.stopPropagation();
							self.contactCloseClick(contId);
						}
					})(cont_id)
				}
			})
		]		
	});
	cont.m_ref = ref;
	ctrl.addElement(cont);
	ctrl.elementsToDOM();
	if(makeCurrent){
		this.onSelectChat(cont_id, false);		
	}
}

//new contact container ID is pessed in.
TmChat_View.prototype.onSelectChat = function(contactContId, interactive){
	if(contactContId == this.m_currentContId){
		return;
	}
	var cont_cont_ctrl = this.getElement("contacts").getElement(contactContId);
	if(this.m_currentContId){
		DOMHelper.delClass(this.getElement("contacts").getElement(this.m_currentContId).getNode(), "chatContactActive");
	}
	this.m_currentContId = contactContId;	
	DOMHelper.addClass(cont_cont_ctrl.getNode(),"chatContactActive");
	
	//show chat history
	var hist_cont = this.getElement("activeChat");
	hist_cont.clear();
	hist_cont.addElement(
		new TmNotification_View(this.getId() + ":notif", {
			"tm_exists": true,
			"ref": cont_cont_ctrl.m_ref,
			"chatMode": true,
			"msgOutControllerClass": this.m_newMsgOutControllerClass,
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
	if(interactive){
		this.clearContactUnviewdMsg(contactContId.substr(2));	
	}
}

TmChat_View.prototype.contactCloseClick = function(contactContId){
	this.clearContactUnviewdMsg(contactContId.substr(2));
	var cont = this.getElement("contacts");
	if(this.m_currentContId && this.m_currentContId == contactContId){
		var hist_cont = this.getElement("activeChat");
		hist_cont.clear();
		hist_cont.elementsToDOM();
		this.m_currentContId = undefined;
	}
	cont.delElement(contactContId);
	cont.elementsToDOM();
}

//screen senter for telegram
TmChat_View.prototype.getLeftPos = function(){
	return (document.documentElement.clientWidth/2 - this.getNode().offsetWidth/2) + "px";
}


