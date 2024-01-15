/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2022

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
 * @param {function} options.entityType
*/
function SendNotificationCmd(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	options.glyph = "glyphicon-send";
	options.title="Отправить сообщение (СМС, Telegram)";
	options.caption = " Сообщение ";
	
	//this.m_getNotifRef = options.getNotifRef;
	this.m_entityType = options.entityType;
	this.m_getEntityId = options.getEntityId;
	
	SendNotificationCmd.superclass.constructor.call(this,id,options);
		
}
extend(SendNotificationCmd,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
SendNotificationCmd.prototype.onCommand = function(e){

	this.m_grid.setModelToCurrentRow();
	if(e && e.stopPropagatio){
		e.stopPropagation();
	}
	if(e && e.preventDefault){
		e.preventDefault();
	}
	window.getApp().sendNotificationToEntity(this.m_entityType, this.m_getEntityId(), this.m_grid.getSelectedRow());
}

