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
function Notification_View(id,options){
	options = options || {};	
	
	options.template = window.getApp().getTemplate("Notification_View");

	this.m_ref = options.ref;
	this.m_msgOutControllerClass = options.msgOutControllerClass;

	this.m_chatControllerClass = options.chatControllerClass;
	this.m_chatModelId = options.chatModelId;
	this.m_chatFolder = options.chatFolder;
	
	this.m_afterMessageSend = options.afterMessageSend;

	this.m_addElement = options.addElement;

	var self = this;
	options.addElement = function(){
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
			"caption": " Отправить файл",
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
					self.onSubmit(function(res){
						if(self.m_afterMessageSend){
							self.m_afterMessageSend(res);
						}
					});
				},
				"rows":3,
				"required":true
			}));	
		}
	}
	
	Notification_View.superclass.constructor.call(this,id,options);	
}
//ViewObjectAjx,ViewAjxList
extend(Notification_View, View);

/* Constants */
Notification_View.prototype.SEND_MSG_PM = "send"; //message
Notification_View.prototype.SEND_ATT_PM = "send_media"; //attachments

Notification_View.prototype.WIN_MAX_HEIGHT = 400;

/* private members */
Notification_View.prototype.m_ref;
Notification_View.prototype.m_msgOutControllerClass;

/* protected*/

Notification_View.prototype.sendFileToServer = function(files, caption){
	let rec = this.getRecipientForQuery();
	let pm = (new this.m_msgOutControllerClass()).getPublicMethod(this.SEND_ATT_PM);
	pm.setFieldValue("recipient", rec);
	pm.setFieldValue("caption", caption);
	pm.setFieldValue("media_file", files);
	pm.run({
		"ok":function() {
			window.showTempNote("Файлы отправлены", null, 5000);
		}
	});
}

Notification_View.prototype.addAttachment = function(){
	let self = this;
	var input = document.createElement('input');
	input.type = 'file';
	input.onchange = e => { 
		self.addAttachmentCont(e.target.files);
	}
	input.click();
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

//tp = in/out
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
			tag = app.htmlTagVideo(msg, this.m_chatFolder);
			
		}else if(mediaType == "audio"){
			tag = window.getApp().htmlTagAudio(msg, "audio", this.m_chatFolder);
			
		}else if(mediaType == "voice"){
			tag = window.getApp().htmlTagAudio(msg, "voice", this.m_chatFolder);
			
		}else if(mediaType == "document"){
			tag = app.htmlTagDocument(msg, this.m_chatFolder);
			
		}else if(mediaType == "photo" && msg.photo && CommonHelper.isArray(msg.photo) && msg.photo.length){
			tag = app.htmlTagPhoto(msg, this.m_chatFolder);
			
		}else if(mediaType == "animation"){
			tag = app.htmlTagVideo(msg, this.m_chatFolder);
			
		}else if(mediaType == "sticker"){
			tag = app.htmlTagSticker(msg, this.m_chatFolder);
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
			//tp=="out"? :null,
			new Control(cont_id+":from", "DIV", {
				"attrs":{"class":"chatMsg_from"},
				"value":fromUser
			}),
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

Notification_View.prototype.getHistory = function(callBack){
	this.m_TM = true;
	var pm = (new this.m_chatControllerClass()).getPublicMethod("get_history");
	if(this.m_ref){
		pm.setFieldValue("recipient", JSON.stringify(this.m_ref.toJSON()));
	}else{
		pm.unsetFieldValue("recipient");
	}
	
	var self = this;
	pm.run({
		"ok":function(resp){			
			var m = resp.getModel(self.m_chatModelId);
			if(!m){
				return;
			}
			var cont = self.getElement("history");
			cont.clear();
			while(m.getNextRow()){
				var from = m.getFieldValue("from_user");
				if(typeof(from) == "string"){
					from = CommonHelper.unserialize(from);
				}
				var from_descr = (from && from.m_descr)? from.m_descr : "";
				self.addMsgToCont(cont, m.getFieldValue("text"), m.getFieldValue("tp"), m.getFieldValue("date_time"), from_descr, false, m.getFieldValue("media_type"), m.getFieldValue("message"));
			}
			cont.setAttr("style", "max-height: " + self.WIN_MAX_HEIGHT+ "px;")
			cont.elementsToDOM();			
			cont.setVisible(true);			
			var chat_n = $(cont.getNode());
			chat_n.scrollTop(chat_n[0].scrollHeight);
			if(callBack){
				callBack.call(self);
			}
		}
	});	
}

//stub
Notification_View.prototype.updateInf = function(refStr){
}

//Returns recipient for sending in request
//if not filled raises error.
Notification_View.prototype.getRecipientForQuery = function(){	
	if(!this.m_ref || this.m_ref.isNull()){
		throw new Error("Не заполнен получатель!");
	}
	return CommonHelper.serialize(this.m_ref); 
}

Notification_View.prototype.onSubmit = function(callBack){
	var rec = this.m_ref;
	if(!rec || rec.isNull()){
		if(callBack){
			callBack(false);
		}
		return;
	}
	rec.m_dataType = "client_tels";
	
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

