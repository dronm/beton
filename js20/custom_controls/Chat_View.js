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
function Chat_View(id,options){
	options = options || {};	
	
	options.template = window.getApp().getTemplate("Chat_View");
	var self = this;
	
	//options.visible = false;
	
	options.addElement = function(){
		this.addElement(new ContactEdit(id+":recipient",{
			"labelCaption":"Новый контакт:",
			"tm_activated": true,						
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
	this.m_opened = false;
	Chat_View.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Chat_View, View);

/* Constants */


/* private members */
Chat_View.prototype.m_currentContId;
Chat_View.prototype.m_opened;

/* protected*/

Chat_View.prototype.contactExists = function(keyId){
	var contacts = this.getElement("contacts").getElements();
	for(var id in contacts){
		if(id=="k_"+keyId && contacts[id]){
			return true;
		}
	}
	return false;
}

Chat_View.prototype.onNewMessage = function(json){
	if(json.eventId && json.eventId == "TmInMessage.insert"
	&& json.params && json.params.ext_obj && json.params.ext_obj.m_keys && json.params.ext_obj.m_keys.id){
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && !contact_active){
			this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			
		}else if(contact_exists && contact_active){
			this.addMsgToActiveContact("in", json.params.text, json.params.ext_obj.m_keys.id, json.params.sender.m_descr)
			
		}else if(!contact_exists){
			//no contact
			this.addContact(json.params.ext_obj, true);
			if(!this.m_opened){
				this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			}
		}
		
	}else if(json.eventId && json.eventId == "TmOutMessage.sent"
	&&json.params&&json.params.res!=undefined&&json.params.res===false&&json.params.errText&&json.params.errText.length){
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && contact_active){
			this.msgBeep();
			window.showError(json.params.errText,null,5000);
		}
	
	}else if(json.eventId && json.eventId == "TmOutMessage.sent"
	&&json.params&&json.params.res!=undefined&&json.params.res===true
	&& json.params.ext_obj && json.params.ext_obj.m_keys && json.params.ext_obj.m_keys.id){
		var contact_exists = this.contactExists(json.params.ext_obj.m_keys.id);
		var contact_active = (contact_exists && this.m_currentContId && "k_"+json.params.ext_obj.m_keys.id==this.m_currentContId);
		if(contact_exists && !contact_active){
			this.addUnviewdMsgToContact(json.params.ext_obj.m_keys.id);
			
		}else if(contact_exists && contact_active){
			this.addMsgToActiveContact("out", json.params.text, json.params.ext_obj.m_keys.id, json.params.sender.m_descr)
		}

	}	
}

Chat_View.prototype.msgBeep = function(){
	(new Audio("img/new_msg.mp3")).play();
}

Chat_View.prototype.addMsgToActiveContact = function(msgType,text, contactId, senderDescr){
	if(!this.m_opened){
		this.show();		
	}
	this.msgBeep();
	
	var hist_cont = this.getElement("activeChat");
	if(hist_cont){
		hist_cont.getElement("notif").addMessage(senderDescr, text, msgType, DateHelper.time());
	}
	//console.log("Chat_View.prototype.addMsgToActiveContact msgType=", msgType,"text=",text,"contactId=",contactId,"senderDescr=",senderDescr)
}

Chat_View.prototype.setTotUnviewdMsg = function(t_v){
	if(t_v<=0){
		t_v = "";
	}
	var tot_uv_ctrl = this.getElement("unviewedMsg");
	tot_uv_ctrl.setValue(t_v);
	if(t_v==""){
		tot_uv_ctrl.delAttr("class");
	}else{
		tot_uv_ctrl.setAttr("class", "badge badge-danger");
	}

}

Chat_View.prototype.decTotUnviewdMsg = function(v){
	var tot_uv_ctrl = this.getElement("unviewedMsg");
	var t_v = parseInt(tot_uv_ctrl.getValue(), 10);
	if(!t_v || isNaN(t_v)){
		t_v = 0;
	}
	t_v-= v;
	this.setTotUnviewdMsg(t_v);
}

Chat_View.prototype.clearContactUnviewdMsg = function(contactId){
	var ctrl = this.getElement("contacts");
	if(!ctrl)return;
	var contact_cont = ctrl.getElement("k_"+contactId);
	if(!contact_cont)return;
	var unv_ctrl = contact_cont.getElement("contact_unviewed");
	if(!unv_ctrl)return;
	var v = parseInt(unv_ctrl.getValue(),10);
	if(!v || isNaN(v)){
		v = 0;
	}
	unv_ctrl.setValue("");
	this.decTotUnviewdMsg(v);
}

Chat_View.prototype.addUnviewdMsgToContact = function(contactId){
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
	v++;
	unv_ctrl.setValue(v);
	
	var tot_uv_ctrl = this.getElement("unviewedMsg");
	var t_v = parseInt(tot_uv_ctrl.getValue(), 10);
	if(!t_v || isNaN()){
		t_v = 0;
	}
	t_v+= v;
	this.setTotUnviewdMsg(t_v);
	//console.log("Chat_View.prototype.addUnviewdMsgToContact contactId=",contactId)
}

Chat_View.prototype.hide = function(){
	var n = this.getNode();
	n.style = n.style || {};
	this.m_lastTop = n.style.top;
	this.m_lastLeft = n.style.left;
	
	DOMHelper.hide(document.getElementById(this.getId()+":body"));
	DOMHelper.addClass(n, "chatInactive");

	n.style.left = (document.documentElement.clientWidth - n.offsetWidth - 5)+"px";
	n.style.top = (document.documentElement.clientHeight - n.offsetHeight - 5)+"px";
	this.m_opened = false;
}

Chat_View.prototype.show = function(){
	var n = this.getNode();
	//screen center
	if(!this.m_lastTop||this.m_lastTop.length==0){
		this.m_lastTop = (document.documentElement.clientHeight/2 - n.offsetHeight/2) + "px";
	}
	if(!this.m_lastLeft||this.m_lastLeft.length==0){
		this.m_lastLeft = (document.documentElement.clientWidth/2 - n.offsetWidth/2) + "px";
	}	
	n.style = n.style || {};
	n.style.left = this.m_lastLeft;
	n.style.top = this.m_lastTop;

	DOMHelper.delClass(n, "chatInactive");
	DOMHelper.show(document.getElementById(this.getId()+":body"));	
	this.m_opened = true;
	
	if(this.m_currentContId && this.m_currentContId.length){
		var hist_cont = this.getElement("activeChat");
		if(hist_cont){
			var notif = hist_cont.getElement("notif");
			if(notif){
				notif.getElement("message").focus();
				var chat_n = $(notif.getNode());
				chat_n.scrollTop(chat_n[0].scrollHeight);						
			}
		}		
		this.clearContactUnviewdMsg(this.m_currentContId.substr(2));
		
	}else{
		this.getElement("recipient").focus();
	}
}

Chat_View.prototype.onToggleClick = function(e){
	e.preventDefault();
	e.stopPropagation();
	var n = this.getNode();
	
	if(this.m_opened){
		this.hide();
	}else{
		this.show();
	}
}

Chat_View.prototype.toDOM = function(p){
	
	Chat_View.superclass.toDOM.call(this, p);
	
	this.hide();
	
	var n = this.getNode();
	this.m_drag = new DragObject(n, {"offsetY": 50, "offsetX": 0});
	this.m_drag.onDragSuccess = function(dropTarget){
		//console.log("dropTarget=",dropTarget)
		//console.log("drag=",this)
	}
	this.m_drop = new DropTarget(document.body);
	//var self = this;
	this.m_drop.accept = function(dragObject) {
		return true;
	}
	
	
}

Chat_View.prototype.addContact = function(ref, makeCurrent, tmPhoto, tmId){
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
					self.contactClick(contId);
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
		this.contactClick(cont_id);		
	}
}

Chat_View.prototype.contactClick = function(contactContId){
	if(contactContId == this.m_currentContId){
		return;
	}
	var cont_cont_ctrl = this.getElement("contacts").getElement(contactContId);
	if(this.m_currentContId){
		DOMHelper.delClass(this.getElement("contacts").getElement(this.m_currentContId).getNode(),"chatContactActive");
	}
	this.m_currentContId = contactContId;	
	DOMHelper.addClass(cont_cont_ctrl.getNode(),"chatContactActive");
	
	//show chat history
	var hist_cont = this.getElement("activeChat");
	hist_cont.clear();
	hist_cont.addElement(
		new Notification_View("notif", {
			"tm_exists":true,
			"ref":cont_cont_ctrl.m_ref,
			"chatMode":true,
			"afterMessageSend":(function(histCont){
				return function(res){
					if(res===true){
						var nt = histCont.getElement("notif");
						nt.getElement("message").reset();
						//reread
						//nt.getHistory();
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
	this.clearContactUnviewdMsg(contactContId.substr(2));	
}

Chat_View.prototype.contactCloseClick = function(contactContId){
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
