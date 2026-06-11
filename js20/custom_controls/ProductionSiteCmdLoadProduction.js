/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2020

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ProductionSiteCmdLoadProduction(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	var self = this;
	this.m_btn = new ButtonCmd(id+"btn",{
		"caption":"Загрузить данные прозводства по номеру ",
		"glyph":"glyphicon-refresh",
		"title":"Загрузить данные производства из Elkon",
		"onClick":function(){
			self.downloadProduction();
		}
	});
	
	options.controls = [
		this.m_btn
	]
	
	ProductionSiteCmdLoadProduction.superclass.constructor.call(this,id,options);
		
}
extend(ProductionSiteCmdLoadProduction,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ProductionSiteCmdLoadProduction.prototype.setGrid = function(v){
	ProductionSiteCmdLoadProduction.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

ProductionSiteCmdLoadProduction.prototype.downloadProduction = function(){
	this.m_grid.setModelToCurrentRow();
	const f = this.m_grid.getModel().getFields();
	const productionSiteId = f.id.getValue();
	const active = f.active.getValue();

	var self = this;
	this.m_view = new View("dialog:cont",{
		"elements":[
			new EditNum("dialog:cont:production_id",{
				"labelCaption":"№ производства Elkon:",
				"focus":true
			})
		]
	});
	this.m_form = new WindowFormModalBS("dialog",{
		"content":this.m_view,
		"dialogWidth":"20%",
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Введите номер производства для загрузки",
		"onClickCancel":function(){
			self.closeSelect();
		},
		"onClickOk":(function(productionSiteId, newApp){
			return function(){	
				const productionId = self.m_view.getElement("production_id").getValue();
				if(!productionId){
					throw Error("Не задан номер производства!");
				}
				self.closeSelect(productionSiteId, productionId, newApp);
			}
		})(productionSiteId, (active===false))
	});
	
	this.m_form.open();

	
}

ProductionSiteCmdLoadProduction.prototype.closeSelect = function(productionSiteId, productionId, newApp){
	if(this.m_view){
		this.m_view.delDOM()	
		delete this.m_view;
	}
	if(this.m_form){
		this.m_form.delDOM();	
		delete this.m_form;
	}	
	
	if(!productionSiteId || !productionId){
		return;
	}

	if(newApp === true){
		const app = window.getApp();
		if(!app){
			throw new Error("app object not defined");
		}
		const srv = app.getAppSrv();
		if(!srv){
			throw new Error("Сервер событий не определен");
		}
		if(!srv.connActive()){
			throw new Error("Соединение с сервером не активно");
		}

		const cmd = {

		};
		srv.m_connection.send(
			JSON.stringify(cmd)
		);
		window.showTempNote("Отправлена команда на загрузку производства: "+productionId, null, 5000);

	}else{
		//for new client app just need to send web socket query
		const pm = (new Production_Controller()).getPublicMethod("check_production");
		
		pm.setFieldValue("production_site_id",productionSiteId);
		pm.setFieldValue("production_id",productionId);
		window.setGlobalWait(true);
		pm.run({
			"ok":function(){
				window.showTempNote("Данные производства загружены",null,5000);
			}
			,"all":function(){
				window.setGlobalWait(false);
			}
		});
	}
}

const normalizePath = (path) => {
	return path.startsWith("/") ? path : `/${path}`;
};

const buildHttpUrl = (config, path) => {
	return `${config.httpScheme}://${config.address}${normalizePath(path)}`;
};

ProductionSiteCmdLoadProduction.prototype.sendCommandToElkonApp = async function(cmd, queryId, body){
}
