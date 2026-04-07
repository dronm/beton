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
function MAXShowQRBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-qrcode glyphicon-before";
	options.caption = " MAX QR ";
	options.title="Показать QR код для регистрации в MAX";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	MAXShowQRBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(MAXShowQRBtn,Button);

/* Constants */


/* private members */

/* protected*/

/* public methods */
MAXShowQRBtn.prototype.onClick = function(){
	const h = $( window ).width()/3*2;
	const left = $( window ).width()/2;
	const w = left - 20;
	const offset = 10;

	window.open(
		"maxqr.html",
		"_blank",
		"popup,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h
	);
}

