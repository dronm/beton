/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2026

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ClientSpecificationGridCmdAllDog(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;

	this.m_getClientId = options.getClientId;
	
	var self = this;
	this.m_btn = new ButtonCmd(id+"btn",{
		"caption":" Все договоры ",
		"glyph":"glyphicon-list-alt",
		"title":"Заполнить всеми договорами",
		"onClick":function(){
			self.getDogAll();
		}
	});
	
	options.controls = [
		this.m_btn
	]
	ClientSpecificationGridCmdAllDog.superclass.constructor.call(this,id,options);
}
extend(ClientSpecificationGridCmdAllDog, GridCmd);

/* Constants */


/* private members */

/* protected*/
ClientSpecificationGridCmdAllDog.prototype.getDogAll = function(){
	//execute command and refresh list
	const clientId = this.m_getClientId();
	if(!clientId){
		throw Error("client id not set");
	}

	const pm = (new ClientContract1c_Controller()).getPublicMethod("get_dog_all");
	pm.setFieldValue("client_id", clientId);

	const self = this;
	window.setGlobalWait(true);
	pm.run({
		"ok": function(){
			self.getGrid().onRefresh(function(){
				window.showTempNote("Обновлен список договоров из 1с",null,5000);
			});
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	});
}


