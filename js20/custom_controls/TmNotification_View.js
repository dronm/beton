/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022-2024

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
function TmNotification_View(id,options){
	options = options || {};	
	
	options.msgOutControllerClass = TmOutMessage_Controller;
	options.msgControllerClass = TmOutMessage_Controller;
	options.chatControllerClass = Chat_Controller;
	options.chatModelId = "Chat_Model";
	options.chatFolder = "tm";
	
	options.addElement = function(){
		this.addElement(new Control(id+":inf","DIV",{
			"attrs":{"class":"text-inf"}			
		}));	
		this.addElement(new Control(id+":inf_tm","DIV",{
			"attrs":{"class":"text-danger"}			
		}));	
	}
	
	TmNotification_View.superclass.constructor.call(this,id,options);
	
	if(options.ref){
		this.updateInf(JSON.stringify(options.ref.toJSON()));
	}		
}
//ViewObjectAjx,ViewAjxList
extend(TmNotification_View, Notification_View);

/* Constants */


/* private members */
TmNotification_View.prototype.m_TM; //Telegram

/* protected*/

TmNotification_View.prototype.showTMInvite = function(){
	var tm_ctrl = this.getElement("inf_tm");
	tm_ctrl.setValue("Пригласить в Telegram", "info");
	DOMHelper.addClass(tm_ctrl.getNode(), "tmInvite");
	if(!this.m_onTMInviteClick){			
		var self = this;
		this.m_onTMInviteClick = function(){
			self.onTMInviteClick();
		}
	}
	EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);

}

TmNotification_View.prototype.hideTMInvite = function(){
	var tm_ctrl = this.getElement("inf_tm");
	tm_ctrl.setValue("");
	if(this.m_onTMInviteClick){
		EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);
	}	
}

TmNotification_View.prototype.onTMInviteClick = function(){
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

TmNotification_View.prototype.updateInf = function(refStr){
	var pm = (new TmOutMessage_Controller()).getPublicMethod("get_recipient_inf");
	pm.setFieldValue("recipient", refStr);
	
	this.hideTMInvite();
	
	var self = this;
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

