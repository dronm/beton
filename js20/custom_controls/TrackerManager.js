
/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends Control
 * @requires core/extend.js
 * @requires controls/Control.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options.getTrackerId
 */
function TrackerManager(id,options){
	options = options || {};	

	this.m_getTrackerId = options.getTrackerId;
	
	const self = this;
	options.addElement = function(){

		this.addElement(new ButtonCmd(id+":cmdImeiStatus",{
			"caption":"Состояние",
			"onClick":function(){
				self.cmdImeiStatus();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdTransmitCoords",{
			"caption":"Отправить координаты",
			"onClick":function(){
				self.cmdTransmitCoords();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdUpdateSoftware",{
			"caption":"Обновить ПО",
			"onClick":function(){
				self.cmdUpdateSoftware();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdUpdateSoftwareForce",{
			"caption":"Обновить ПО принудительно",
			"onClick":function(){
				self.cmdUpdateSoftwareForce();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdReset",{
			"caption":"Выполнить сброс",
			"onClick":function(){
				self.cmdReset();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdDownloadSettingsFromWebConf",{
			"caption":"Записать настройки",
			"onClick":function(){
				self.cmdDownloadSettingsFromWebConf();
			}
		}));	
		this.addElement(new ButtonCmd(id+":cmdSendSettingsToWebConf",{
			"caption":"Прочитать настройки",
			"onClick":function(){
				self.cmdSendSettingsToWebConf();
			}
		}));	
		this.addElement(new EditText(id+":result",{
			"rows": "3"
		}));	
	};

	TrackerManager.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(TrackerManager, View);

TrackerManager.prototype.cmdRun = function(cmd){
	const trackerId = this.m_getTrackerId();
	const pm = (new Vehicle_Controller()).getPublicMethod("run_tracker_command");
	pm.setFieldValue("cmd", cmd);
	pm.setFieldValue("tracker_id", trackerId);
	const self = this;
	pm.run({
		"ok": function(resp){
			const model = resp.getModel("TelSrv");
			if(model.getNextRow()){
				const srvResp = model.getFieldValue("resp");
				// J(srvResp);
				self.getElement("result").setValue(srvResp);
			}
		}
	})
}

TrackerManager.prototype.cmdImeiStatus = function(){
	this.cmdRun("imeiStatus");
}

TrackerManager.prototype.cmdTransmitCoords = function(){
	this.cmdRun("transmitCoords");
}

TrackerManager.prototype.cmdUpdateSoftware = function(){
	this.cmdRun("updateSoftware");
}

TrackerManager.prototype.cmdUpdateSoftwareForce = function(){
	this.cmdRun("updateSoftwareForce");
}

TrackerManager.prototype.cmdReset = function(){
	this.cmdRun("reset");
}

TrackerManager.prototype.cmdDownloadSettingsFromWebConf = function(){
	this.cmdRun("downloadSettingsFromWebConf");
}

TrackerManager.prototype.cmdSendSettingsToWebConf = function(){
	this.cmdRun("sendSettingsToWebConf");
}
