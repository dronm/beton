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
function ConnectElkonCheck(baseId){
	this.m_values = {};
	this.m_refreshInterval = 0;
	this.m_baseId = baseId;

	this.activate();
}

/* Constants */
ConnectElkonCheck.prototype.DEF_REFRESH = 5*60;//every minute for ws check
ConnectElkonCheck.prototype.DEF_REFRESH_AJX = 10*60;//every 10 minute

ConnectElkonCheck.prototype.m_lastValues; //[productionSiteID]: {node: htmlnode, lastValue: boolean}

ConnectElkonCheck.prototype.PIC_OK = "./img/dot_green.png";
ConnectElkonCheck.prototype.PIC_ERR = "./img/dot_red.png";
ConnectElkonCheck.prototype.TITLE_OK = "Есть соединение с Elkon";
ConnectElkonCheck.prototype.TITLE_ERR = "Ошибка соединения с Elkon";

//id: number|string, initValue: boolean
ConnectElkonCheck.prototype.addProductionSite = function(id, initValue){
	this.setValue(id, initValue);
}

/* private members */

/* protected*/

ConnectElkonCheck.prototype.setRefreshInterval = function(newInterval) {
	var self = this;

	this.m_refreshInterval = newInterval;
	if(this.m_timer !== undefined){
		clearInterval(this.m_timer);
		this.m_timer = undefined;
	}

	if(newInterval > 0){
		this.m_timer = setInterval(function(){
			self.refresh();
		}, this.m_refreshInterval);	
	}
}

/* public methods */
ConnectElkonCheck.prototype.activate = function(){
	const evSrv = window.getApp().getAppSrv();
	if(evSrv && evSrv.connActive()){
		//events
		const self = this;
		this.m_srvEvents = {
			events: [
				{"id": "ConnectElkonCheck.update"}
			],
			onEvent: function(params){
				self.onPingElkonChange(params);
			},
			onClose: function(params){
				self.srvEventsOnClose(params)
			},
			onSubscribed: function(){
				self.setRefreshInterval(0);
			}
		};
		this.setRefreshInterval(this.DEF_REFRESH * 1000);
	}else{
		this.setRefreshInterval(this.DEF_REFRESH_AJX * 1000);
	}

	this.refresh();
}

ConnectElkonCheck.prototype.deactivate = function(){
	if(this.m_timer){
		clearInterval(this.m_timer);
		this.m_timer = undefined;
	}
}

ConnectElkonCheck.prototype.refresh = function(){
	const self = this;
	const pm = new ConnectElkonCheck_Controller().getPublicMethod("connected");
	pm.setFieldValue("base_id", this.m_baseId);
	pm.run({
		"ok":function(resp){
			const modelData = resp.getModelData("ConnectElkon_Model");
			const fPong = new FieldBool("pong");
			const fProdSiteId = new FieldString("production_site_id");

			const model = new ModelXML("ConnectElkon_Model", {
				data: modelData, 
				fields: [fPong, fProdSiteId]
			});

			while(model.getNextRow()){
				const id = model.getFieldValue("production_site_id");
				const pong = model.getFieldValue("pong");
				self.setValue(id, pong);
			}
		}
	});
}

ConnectElkonCheck.prototype.setValue = function(id, pong){
	const idStr = id.toString();
	if(!this.m_values[idStr] ) {
		const imgNode = document.getElementById("production_site_conn_img_" + idStr);
		if(imgNode){
			this.m_values[idStr] = {node: imgNode, lastValue: !pong};
		}
	}
	if(this.m_values[idStr] && this.m_values[idStr].lastValue != pong){
		this.m_values[idStr].node.setAttribute("src", pong? this.PIC_OK : this.PIC_ERR);
		this.m_values[idStr].node.setAttribute("title", pong? this.TITLE_OK : this.TITLE_ERR);
		this.m_values[id].lastValue = pong;
	}
}

ConnectElkonCheck.prototype.onPingElkonChange = function(params){
	if(json.params 
		&& json.params.pong !== undefined
		&& json.params.production_site_id !== undefined
	){
		this.setValue(json.params.production_site_id.toString(), json.params.pong);
	}
}

ConnectElkonCheck.prototype.srvEventsOnClose = function(message){
	if(message && message.code>1000){
		this.setRefreshInterval(this.DEF_REFRESH * 1000);
	}
}

