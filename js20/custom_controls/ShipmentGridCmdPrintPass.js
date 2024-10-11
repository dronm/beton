/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2023

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintPass(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;	
	options.glyph = "glyphicon-print";
	options.caption = " Паспорт";
	options.title = "Печать паспорта качества";
	
	this.m_grid = options.grid;
	
	ShipmentGridCmdPrintPass.superclass.constructor.call(this,id,options);
		
}
extend(ShipmentGridCmdPrintPass,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintPass.prototype.onCommand = function(e){
	var self = this;
	var p = new PopUpMenu({
		"elements":[
			new Button(this.getId()+":stamp_ship", {
				"caption":"На одну отгрузку с печатью",
				"onClick":function(){
					self.onCommandCont("get_passport_stamp_ship");
				}
			})
			,new Button(this.getId()+":stamp_order", {
				"caption":"На все отгрузки с печатью",
				"onClick":function(){
					self.onCommandCont("get_passport_stamp_all");
				}
			})
			,new Button(this.getId()+":ship", {
				"caption":"На одну отгрузку без печати",
				"onClick":function(){
					self.onCommandCont("get_passport_ship");
				}
			})
			,new Button(this.getId()+":order", {
				"caption":"На все отгрузки без печати",
				"onClick":function(){
					self.onCommandCont("get_passport_all");
				}
			})
		],
		"caption":"Печать паспорта"
	});
	var btn = DOMHelper.getParentByAttrValue(e.target, "name", "printPass");
	if(!btn){
		throw new Error("parent button not found");
	}
	p.show(e, btn);
}

ShipmentGridCmdPrintPass.prototype.onPrintCont = function(pmId, dlg, shipment_id){	
	dlg.close();
	
	var pm = (new Shipment_Controller()).getPublicMethod(pmId);
	var offset = 0;
	pm.setFieldValue("id", shipment_id);	
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;
	pm.openHref("ViewPDF","location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);	
}

ShipmentGridCmdPrintPass.prototype.onPrint = function(pmId, dlg, shipment_id){	
	var view = dlg.getContent();
	var self = this;
	view.execCommand(
		view.CMD_OK,
		function(resp){
			self.onPrintCont(pmId, dlg, shipment_id);
			
		},
		function(resp,erCode,erStr){
			throw new Error(erStr);
		}
	);			
	
}

ShipmentGridCmdPrintPass.prototype.onCommandContCont = function(pmId, model, shipment_id){	
	var self = this;
	model.getNextRow();
	var id = model.getFieldValue("id");
	var cmd = id? "edit":"insert";
	var params = {
		"models": {"QualityPassport_Model": model},
		"cmd": cmd,
		"cmdSave": false,
		"cmdOk": false,
		"cmdCancel": false,
		"noPrintBtn":true
	};
	(new WindowFormModalBS("qualityPassport",{
		"dialogWidth":"50%",
		"cmdOk":true,		
		"controlOkCaption":"Печать",
		"onClickOk":function(){
			self.onPrint(pmId, this, shipment_id);
		},
		"cmdCancel":true,
		"onClickCancel":function(){
			this.close();
		},
		"cmdClose":true,
		"content":new QualityPassport_View("qualityPassport:view", params)
	})).open();
}

ShipmentGridCmdPrintPass.prototype.onCommandCont = function(pmId){
	var self = this;
	this.m_grid.setModelToCurrentRow();
	var shipment_id = this.m_grid.getModel().getFieldValue("id");		
	var pm = (new QualityPassport_Controller).getPublicMethod("get_object_or_last");
	pm.setFieldValue("shipment_id", shipment_id);
	pm.run({
		"ok":function(resp){
			self.onCommandContCont(pmId, resp.getModel("QualityPassport_Model"), shipment_id);
		}
	});
}

