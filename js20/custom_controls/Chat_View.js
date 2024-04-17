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
	
	options.template = options.template || window.getApp().getTemplate("Chat_View");
	
	this.m_opened = false;
	
	Chat_View.superclass.constructor.call(this, id, options);
	
	window.getApp().addVideoPlayerSupport(); //video messages support
}
//ViewObjectAjx,ViewAjxList
extend(Chat_View, View);

/* Constants */


/* private members */
Chat_View.prototype.m_opened;
Chat_View.prototype.m_msgInEventId;
Chat_View.prototype.m_msgOutEventId;
Chat_View.prototype.m_msgInEventId;
Chat_View.prototype.m_msgOutEventId;


//TChat_View.prototype.TOP_OFFSET = 20;
/* protected*/

//common function called on recieving a new message
Chat_View.prototype.onAddNewMessage = function(msgType, json){
	let pm, model_id;
	if(msgType == 'in'){
		pm = (new this.m_newMsgInControllerClass()).getPublicMethod("get_object");
		model_id = this.m_newMsgInModelId;
	}else{
		pm = (new this.m_newMsgOutControllerClass()).getPublicMethod("get_object");
		model_id = this.m_newMsgOutModelId;
	}

	//retrieve all message fields
	pm.setFieldValue("id", json.params.msg_id);
	var self = this;
	pm.run({
		"ok":function(resp){
			var m = resp.getModel(model_id);
			if(!m){
				throw new Error("Model: " + model_id + " not found!");
			}
			if(m.getNextRow()){
				self.onAddNewMessageCont(msgType, json, m.getFieldValue("message"));
			}
		}
	});
}


Chat_View.prototype.msgBeep = function(){
	(new Audio("img/new_msg.mp3")).play();
}

Chat_View.prototype.addMsgToActiveContact = function(msgType, text, contactId, senderDescr, mediaType, message){
	//if(!this.m_opened){
	//	this.show();		
	//}
	
	var hist_cont = this.getElement("activeChat");
	if(hist_cont){
		hist_cont.getElement("notif").addMessage(senderDescr, text, msgType, DateHelper.time(), mediaType, message);
	}
}

Chat_View.prototype.setTotUnviewdMsg = function(cnt){
	let n = document.getElementById(this.m_statusNodeId);
	if(!n){
		return;
	}
	if(isNaN(cnt) || cnt < 0){
		cnt = 0;
	}
	let n_cnt = DOMHelper.getElementsByAttr("msg_unviewed", n, "class", true);
	if(cnt && (!n_cnt || !n_cnt.length)){
		//add node
		let n_cnt = document.createElement("SPAN");
		n_cnt.className = "badge bg-warning-400 msg_unviewed";
		n_cnt.title = "Непрсмотренные сообщения";
		n_cnt.textContent = cnt;
		n.appendChild(n_cnt);	
		
	}else if(cnt){
		n_cnt[0].textContent = cnt;
		
	}else if(!cnt){
		DOMHelper.delNode(n_cnt[0]);
	}
}

Chat_View.prototype.getTotUnviewdMsg = function(){
	let n = document.getElementById(this.m_statusNodeId);
	if(!n){
		return 0;
	}
	let n_cnt = DOMHelper.getElementsByAttr("msg_unviewed", n, "class", true);
	if(!n_cnt || !n_cnt.length){
		return 0;
	}
	let r = (n_cnt[0].textContent && n_cnt[0].textContent.length)? parseInt(n_cnt[0].textContent, 10) : 0;
	return r;
}

//hides control from view, collapses, changes position
//Common Control hide method is used instead
Chat_View.prototype.hide = function(){
	Chat_View.superclass.hide.call(this);
	this.m_opened = false;	
}
/*
Chat_View.prototype.hide = function(){
	var n = this.getNode();
	n.style = n.style || {};
	this.m_lastTop = n.style.top;
	this.m_lastLeft = n.style.left;
	
	DOMHelper.hide(document.getElementById(this.getId()+":body"));
	DOMHelper.addClass(n, "chatInactive");

	n.style.left = (document.documentElement.clientWidth - n.offsetWidth - 5)+"px";
	n.style.top = (document.documentElement.clientHeight - n.offsetHeight - 50)+"px";

	this.m_opened = false;
}
*/

Chat_View.prototype.show = function(){
	//screen top
	if(!this.m_lastTop || this.m_lastTop.length==0){
		this.m_lastTop = "0px"; 
	}
	if(!this.m_lastLeft || this.m_lastLeft.length==0){
		this.m_lastLeft = this.getLeftPos();
	}	

	var n = this.getNode();
	n.style = n.style || {};
	n.style.left = this.m_lastLeft;
	n.style.top = this.m_lastTop;

	DOMHelper.delClass(n, "chatInactive");
	DOMHelper.show(document.getElementById(this.getId()+":body"));	
	this.m_opened = true;
}

Chat_View.prototype.onToggleClick = function(e){
	e.preventDefault();
	e.stopPropagation();
	
	if(this.m_opened){
		this.hide();
		// this.delDOM();
	}else{
		// this.toDOM(document.getElementById("windowData"));
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

//stub
Chat_View.prototype.getLeftPos = function(){
}

