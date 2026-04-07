/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function MAXInviteBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-send glyphicon-before";
	options.caption = " СМС для регистрации в MAX";
	options.title="Отправить контакту СМС с приглашением в MAX";

	this.m_self = options.self;
	this.m_getRef = options.getRef;

	var self = this;
	options.onClick = options.onClick || function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	MAXInviteBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(MAXInviteBtn,Button);

/* Constants */


/* private members */

/* protected*/

/* public methods */
MAXInviteBtn.prototype.onClick = function(){
	var b = this.m_self;
	b.setEnabled(false);
	window.getApp().MAXInviteContact(
		this.m_getRef(),
		function(){
			b.setEnabled(true);
		}
	);
}


