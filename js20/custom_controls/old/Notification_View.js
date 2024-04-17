/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 * @param {function} options.afterMessageSend
 * @param {bool} options.tm_exists 
 */
function Notification_View(id,options){
	options = options || {};	
	
	options.template = window.getApp().getTemplate("Notification_View");
	
	this.m_afterMessageSend = options.afterMessageSend;
	
	var self = this;
	options.addElement = function(){
		//parent
		if(self.m_addElement){
			self.m_addElement();
		}
	
		//ClientTelEdit
		this.addElement(new ContactEdit(id+":recipient",{
			"visible":options.ref? false:true,
			"labelCaption":"Получатель:",
			"required":true,
			"tm_exists": options.tm_exists,			
			"value":options.ref,
			"onSelect":function(){
				var ctrl = self.getElement("recipient");
				if(ctrl){
					var v = ctrl.getValue();
					if(v && !v.isNull()){
						//v.m_dataType = "client_tels";
						self.updateInf(JSON.stringify(v.toJSON()));
					}
				}
			}
		}));	

		this.addElement(new ControlContainer(id+":history", "DIV", {
			"visible":false,
			"attrs":{
				"class":"chatCont"
			}
		}));
		
		this.addElement(new EditText(id+":message",{
			"labelCaption": ((options.chatMode===true)? null:"Сообщение:"),
			"editContClassName":"input-group " + window.getBsCol(12),
			"rows":3,
			"required":true,
			"focus":options.ref? true:false
		}));

		//add file button: to add attachments
		this.addElement(new ButtonCmd(id+":addAttachment",{
			"caption": "Отправить файл",
			"title": "Отправить фотографию, видео, документ и т.д. Можно также перетащить файл мышкой.", 
			"glyph": "glyphicon-plus",
			"onClick": function() {
				self.addAttachment();
			}
		}));	

		this.addElement(new Control(id+":inf","DIV",{
			"attrs":{"class":"text-inf"}			
		}));	
		this.addElement(new Control(id+":inf_tm","DIV",{
			"attrs":{"class":"text-danger"}			
		}));	

		if(!options.ref || options.chatMode===true){
			this.addElement(new ButtonCmd(id+":submit",{
				"glyph":"glyphicon-send",
				"caption":" Отправить сообщение",
				"onClick":function(e){
					if(!self.m_afterMessageSend){
						self.onSubmit();
					}else{
						self.onSubmit(function(res){
							self.m_afterMessageSend(res);
						});
					}
				},
				"rows":3,
				"required":true
			}));	
		}
	}	
	
	Notification_View.superclass.constructor.call(this,id,options);
	
	if(options.ref){
		this.updateInf(JSON.stringify(options.ref.toJSON()));
	}
}
//ViewObjectAjx,ViewAjxList
extend(Notification_View,View);

/* Constants */
Notification_View.prototype.WIN_MAX_HEIGHT = 400;

/* private members */
Notification_View.prototype.m_TM; //Telegram

/* protected*/

//add new attachments
Notification_View.prototype.addAttachment = function(){
	let self = this;
	var input = document.createElement('input');
	input.type = 'file';
	input.onchange = e => { 
		self.addAttachmentCont(e.target.files);
	}
	input.click();
}

Notification_View.prototype.sendFileToServer = function(files, caption){
	let pm = (new TmOutMessage_Controller().getPublicMethod("send_media"));
	let rec = this.getRecipientForQuery();
	pm.setFieldValue("recipient", rec);
	pm.setFieldValue("caption", caption);
	pm.setFieldValue("media_file", files);
	pm.run({
		"ok":function() {
			window.showTempNote("Файлы отправлены", null, 5000);
		}
	});
}

Notification_View.prototype.closeCaptDialog = function(dlgCont, files, caption){
	this.sendFileToServer(files, caption);
	dlgCont.close();
	document.getElementById("Chat").style.zIndex = "99999";
}

Notification_View.prototype.addAttachmentCont = function(files){
	//first get caption
	//
	//set chat window z index to back 
	document.getElementById("Chat").style.zIndex = "1";

	var self = this;
	let id = this.getId() + ":cpt";
	this.m_dlgCont = new WindowFormModalBS(id,{
		"dialogWidth":"20%",
		"cmdOk":true,
		"cmdCancel":true,		
		"onClickOk":function(){
			self.closeCaptDialog(this, files, this.getContent().getElement("txt").getValue());
		},
		"onClickCancel":function(){
			self.closeCaptDialog(this, files, null);
		},
		"cmdClose":true,
		"content":new ControlContainer(id + ":view", "DIV", {
			"elements":[
				new EditText(id + ":view:txt", {
					"focus":true,
					"rows": 2,
					"labelCaption": "Подпись:",
					"events":{
						"keyup": function(e) {
							if(e.code === 'Enter'){
								self.closeCaptDialog(self.m_dlgCont, files, this.getValue());

								e.preventDefault();
								return false;
							}
						}
					}
				})
			]
		})
	});
	this.m_dlgCont.open();
	
}

Notification_View.prototype.showTMInvite = function(){
	var tm_ctrl = this.getElement("inf_tm");
	tm_ctrl.setValue("Пригласить в Telegram","info");
	DOMHelper.addClass(tm_ctrl.getNode(), "tmInvite");
	if(!this.m_onTMInviteClick){			
		var self = this;
		this.m_onTMInviteClick = function(){
			self.onTMInviteClick();
		}
	}
	EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);

}

Notification_View.prototype.hideTMInvite = function(){
	var tm_ctrl = this.getElement("inf_tm");
	tm_ctrl.setValue("");
	if(this.m_onTMInviteClick){
		EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);
	}	
}

//Returns recipient for sending in request
//if not filled raises error.
Notification_View.prototype.getRecipientForQuery = function(){
	var ctrl_rec = this.getElement("recipient");
	var rec = ctrl_rec.getValue();
	if(!rec || rec.isNull()){
		if(ctrl_rec.getVisible()){
			ctrl_rec.setNotValid("Не заполнено");
			return;
		}else{
			throw new Error("Не заполнен получатель!");
		}
	}
	ctrl_rec.setValid();
	return CommonHelper.serialize(rec); 
}

Notification_View.prototype.onTMInviteClick = function(){
	let rec = this.getRecipientForQuery();
	var pm = (new TmOutMessage_Controller()).getPublicMethod("tm_invite");
	pm.setFieldValue("recipient", rec);
	window.setGlobalWait(true);
	var self = this;
	pm.run({
		"all":function(){
			window.setGlobalWait(false);
		}
		,"ok":function(){
			window.showTempNote("Отправлено приглашение в Telegram",null,5000);
			self.hideTMInvite();
		}
	});
}


/* public methods */

Notification_View.prototype.addMsgToCont = function(cont, text, tp, dt, fromUser, show, mediaType, msg){
	var cont_id = cont.getId()+":msg"+(cont.getCount()+1);
	
	var app = window.getApp();
	var msg_ctrl;
	if(!mediaType || mediaType == "text"){
		//text message
		msg_ctrl = new Control(cont_id+":t", "DIV", {
			"attrs": {"class": "chatMsg_text"},
			"value": text
		});
	}else{
		var tag;
		if(mediaType == "video"){
			tag = app.htmlTagVideo(msg);
			
		}else if(mediaType == "audio"){
			tag = window.getApp().htmlTagAudio(msg, "audio");
			
		}else if(mediaType == "voice"){
			tag = window.getApp().htmlTagAudio(msg, "voice");
			
		}else if(mediaType == "document"){
			tag = app.htmlTagDocument(msg);
			
		}else if(mediaType == "photo" && msg.photo && CommonHelper.isArray(msg.photo) && msg.photo.length){
			tag = app.htmlTagPhoto(msg);
			
		}else if(mediaType == "animation"){
			tag = app.htmlTagVideo(msg);
			
		}else if(mediaType == "sticker"){
			tag = app.htmlTagSticker(msg);
		}
		
		msg_ctrl = new ControlContainer(cont_id+":t", "DIV", {
			"attrs": {"class": "chatMsg_cont"},
			"elements": [
				new Control(cont_id+":t:msg", null, {
					"node": tag
				})
			]
		});		
	}	
	
	cont.addElement(new ControlContainer(cont_id, "DIV", {					
		"attrs":{
			"class":"chatMsg chatMsg_"+tp
		},
		"elements":[
			tp=="out"? new Control(cont_id+":from", "DIV", {
				"attrs":{"class":"chatMsg_from"},
				"value":fromUser
			}):null,		
			msg_ctrl,
			new Control(cont_id+":d", "DIV", {
				"attrs":{"class":"chatMsg_date"},
				"value":DateHelper.format(dt,"d F H:i")
			})
		]
	}));
	if(show){
		cont.elementsToDOM();
		var chat_n = $(cont.getNode());
		chat_n.scrollTop(chat_n[0].scrollHeight);
	}
}

Notification_View.prototype.getHistory = function(){
	this.m_TM = true;
	var v = this.getElement("recipient").getValue();
	if(v.isNull()){
		return;
	}
	var pm = (new Chat_Controller).getPublicMethod("get_history");
	pm.setFieldValue("recipient", JSON.stringify(v.toJSON()));
	var self = this;
	pm.run({
		"ok":function(resp){			
			var m = resp.getModel("Chat_Model");
			if(!m){
				return;
			}
			var cont = self.getElement("history");
			cont.clear();
			while(m.getNextRow()){
				var from_o = CommonHelper.unserialize(m.getFieldValue("from_user"));
				var from = (from_o&&from_o.m_descr)? from_o.m_descr:"";
				self.addMsgToCont(cont, m.getFieldValue("text"), m.getFieldValue("tp"), m.getFieldValue("date_time"), from, false, m.getFieldValue("media_type"), m.getFieldValue("message"));
			}
			cont.setAttr("style", "max-height: " + self.WIN_MAX_HEIGHT+ "px;")
			cont.elementsToDOM();			
			cont.setVisible(true);			
			var chat_n = $(cont.getNode());
			chat_n.scrollTop(chat_n[0].scrollHeight);
		}
	});	
}

Notification_View.prototype.updateInf = function(refStr){
	var pm = (new TmOutMessage_Controller()).getPublicMethod("get_recipient_inf");
	pm.setFieldValue("recipient", refStr);
	var self = this;
	this.hideTMInvite();
	pm.run({
		"ok":function(resp){
			var tm_exists = false;
			var tm_activated = false;
			var tel = "";
			
			var m = resp.getModel("ContactDialog_Model");
			if(m.getNextRow()){
				tm_exists = m.getFieldValue("tm_exists");
				tm_activated = m.getFieldValue("tm_activated");
				tel = CommonHelper.maskFormat(m.getFieldValue("tel"), window.getApp().getPhoneEditMask())
			}
			var msg = "";
			var nd = self.getElement("inf").getNode();
			
			if(tm_exists && tm_activated){
				DOMHelper.delClass(nd, "text-danger");
				DOMHelper.addClass(nd, "text-info");			
				msg = "Сообщение будет отправлено в Telegram пользователю "+m.getFieldValue("tm_first_name");
				self.getHistory();				
				//add photo
				var n = document.getElementById("notification:cont:photo") || document.getElementById("notif:photo");
				if(n){
					n.src = "data:image/png;base64, "+m.getFieldValue("tm_photo");
					DOMHelper.show(n);
				}
			
			}else if(!tm_exists && tel && tel.length){
				DOMHelper.delClass(nd, "text-danger");
				DOMHelper.addClass(nd, "text-info");			
				msg = "Сообщение будет отправлено в виде СМС на номер: "+tel;
				self.showTMInvite();
				
			}else if(tm_exists && !tm_activated && tel.length){
				DOMHelper.delClass(nd, "text-danger");
				DOMHelper.addClass(nd, "text-info");			
				msg = "Telegram не активирован, сообщение будет отправлено в виде СМС на номер: "+tel;
				
			}else if(!tel || !tel.length){
				DOMHelper.addClass(nd, "text-danger");
				DOMHelper.delClass(nd, "text-info");				
				msg = "Telegram не активирован, телефон не задан, сообщение не будет отправлено";
				
			}
			self.getElement("inf").setValue(msg);
		}
	});

}

Notification_View.prototype.onSubmit = function(callBack){
	var rec = this.getElement("recipient").getValue();
	if(!rec || rec.isNull()){
		this.getElement("recipient").setNotValid("Не заполнено");
		if(callBack){
			callBack(false);
		}
		return;
	}
	rec.m_dataType = "client_tels";
	this.getElement("recipient").setValid();
	
	var msg = this.getElement("message").getValue();
	if(!msg || !msg.length){
		this.getElement("message").setNotValid("Не заполнено");
		if(callBack){
			callBack(false);
		}
		return;
	}
	this.getElement("message").setValid();
	
	var pm = (new TmOutMessage_Controller()).getPublicMethod("send");
	pm.setFieldValue("recipient", JSON.stringify(rec.toJSON()));
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

//************************
/**
 * @param {json} user
 * @param {string} text
 * @param {string} msType in/out
 *
 * adds new message
 */
Notification_View.prototype.addMessage = function(user, text, msType, dt, mediaType, message){
	var ctrl = this.getElement("history");
	this.addMsgToCont(ctrl, text, msType, dt, user, true, mediaType, message);
}
