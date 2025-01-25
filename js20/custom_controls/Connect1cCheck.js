/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2025

 * @extends Control
 * @requires core/extend.js
 * @requires controls/Control.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Connect1cCheck(id,options){
	options = options || {};	
	
	this.m_refreshInterval = (options.refreshInterval||this.DEF_REFRESH)*1000;
	this.m_lastValue = false;
	
	Connect1cCheck.superclass.constructor.call(this,id,"IMG",
		{"attrs": {
			"src": this.PIC_ERR,
			"width": "10",
			"height": "10",
			"title": "Статус соединения с 1с"
		}
	});
}
//ViewObjectAjx,ViewAjxList
extend(Connect1cCheck,Control);

/* Constants */
Connect1cCheck.prototype.DEF_REFRESH = 1*60;//every 1 minute
Connect1cCheck.prototype.m_lastValue;
Connect1cCheck.prototype.PIC_OK = "./img/dot_green.png";
Connect1cCheck.prototype.PIC_ERR = "./img/dot_red.png";

/* private members */

/* protected*/


/* public methods */
Connect1cCheck.prototype.toDOM = function(p){
	Connect1cCheck.superclass.toDOM.call(this,p);
	var self = this;
	this.m_timer = setInterval(function(){
		self.refresh();
	}, this.m_refreshInterval);	
	
	this.refresh();
}

Connect1cCheck.prototype.delDOM = function(){
	if(this.m_timer)
		clearInterval(this.m_timer);
	
	Connect1cCheck.superclass.delDOM.call(this);
}

Connect1cCheck.prototype.updateConnectStatus = function(connected){
}

Connect1cCheck.prototype.refresh = function(){
	var self = this;
	(new Connect1cCheck_Controller()).getPublicMethod("connected").run({
		"ok":function(resp){
			const modelData = resp.getModelData("Connect1c_Model");
			const f = new FieldBool("pong");
			const model = new ModelXML("Connect1c_Model", {
				data: modelData, 
				fields: [f]
			});
			let connected = false;
			if(model.getNextRow()){
				connected = model.getFieldValue("pong"); 
			}
			if(connected!==self.m_lastValue){ 
				self.m_lastValue = connected;
				self.setAttr("src", connected? self.PIC_OK:self.PIC_ERR);
			}
		}
	});
}

