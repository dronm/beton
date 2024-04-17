/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 * @param {function} options.getRef Contact ref
 */
function SendNotificationBtn(id,options){
	options = options || {};	
		
	options.glyph = "glyphicon-send";
	options.title="Отправить сообщение (СМС, Telegram)";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_getRef = options.getRef;
	
	this.m_cmd = options.cmd;
	
	SendNotificationBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(SendNotificationBtn,Button);

/* Constants */


/* private members */

/* protected*/
SendNotificationBtn.prototype.m_grid;

/* public methods */
/*
SendNotificationBtn.prototype.onClickCont = function(ref){
	this.m_view = new Notification_View("notification:cont",{
		"ref":ref
	});
	var self = this;
	this.m_form = new WindowFormModalBS("notification",{
		"content":this.m_view,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Отправка сообщения: "+ref.getDescr(),
		"onClickCancel":function(){
			self.closeForm();
		},
		"onClickOk":(function(self){
			return function(){
				self.m_view.onSubmit(function(res){
					if(res==true){
						self.closeForm();
					}
				});				
			}
		})(self)
	});
	this.m_form.open();
}
*/
SendNotificationBtn.prototype.onClick = function(){
	var self = this;
	this.m_getRef(function(ref){
		window.getApp().sendNotification(ref);
	});
}
/*
SendNotificationBtn.prototype.closeForm = function(){
	this.m_view.delDOM()
	this.m_form.delDOM();
	delete this.m_view;
	delete this.m_form;			
}
*/
