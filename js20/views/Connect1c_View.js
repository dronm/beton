/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Connect1c_View(id,options){
	options = options || {};	

	options.HEAD_TITLE = "Управление состоянием коннектора 1с";
	
	var self = this;

	options.addElement = function(){
		this.addElement(new ButtonCmd(id+":stop",{
			caption: "Stop servie",
			onClick: function(){
				self.cmdStop();
			}
		}));	

		this.addElement(new ButtonCmd(id+":start",{
			caption: "Start service",
			onClick: function(){
				self.cmdStart();
			}
		}));	

		this.addElement(new ButtonCmd(id+":health",{
			caption: "Health",
			onClick: function(){
				self.cmdHealth();
			}
		}));	

		this.addElement(new ButtonCmd(id+":status",{
			caption: "Status",
			onClick: function(){
				self.cmdStatus();
			}
		}));	
		this.addElement(new EditText(id+":response",{
			labelCaption: "Ответ:"
		}));	
	}

	Connect1c_View.superclass.constructor.call(this,id,options);
	
}
extend(Connect1c_View, View);

Connect1c_View.prototype.cmdExec = function(command){
	const pm = (new Connect1c_Controller()).getPublicMethod(command);
	window.setGlobalWait(true);
	const self = this;
	pm.run({
		ok: function(resp){
			const m = new ModelXML("Result1c_Model", {data: resp.getModelData("Result1c_Model")});
			if(!m.getNextRow()){
				throw new Error("Model: Result1c_Model has no rows");
			}
			self.getElement("response").setValue(m.getFieldValue("obj"));
		},
		all: function(){
			window.setGlobalWait(false);
		}
	})
}

Connect1c_View.prototype.cmdStop = function(){
	this.cmdExec("service_stop");
}

Connect1c_View.prototype.cmdStart = function(){
	this.cmdExec("service_start");
}

Connect1c_View.prototype.cmdHealth = function(){
	this.cmdExec("service_health");
}

Connect1c_View.prototype.cmdStatus = function(){
	this.cmdExec("service_status");
}
