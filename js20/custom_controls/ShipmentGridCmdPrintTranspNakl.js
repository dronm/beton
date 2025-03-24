/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2024

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintTranspNakl(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;	
	options.glyph = "glyphicon-print";
	options.title="Напечатать транспортную накладную";
	options.caption = " Транс.накл. ";

	// this.m_grid = options.grid;
	// this.m_btn = new PrintTranspNaklBtn(id+"btn",{ "cmd":true });
	// options.controls = [ this.m_btn ]
	
	ShipmentGridCmdPrintTranspNakl.superclass.constructor.call(this,id,options);
}
extend(ShipmentGridCmdPrintTranspNakl,GridCmd);

/* Constants */


/* private members */

/* protected*/
//"shipment_transp_nakl"
ShipmentGridCmdPrintTranspNakl.prototype.onCommand = function(e){
	var self = this;
	var p = new PopUpMenu({
		"elements":[
			new Button(this.getId()+":stamp_ship", {
				"caption":"На одну отгрузку с печатью",
				"onClick":function(){
					self.onCommandCont("shipment_transp_nakl", true);
				}
			})
			,new Button(this.getId()+":stamp_order", {
				"caption":"На все отгрузки с печатью",
				"onClick":function(){
					self.onCommandCont("shipment_transp_nakl_all", true);
				}
			})
			,new Button(this.getId()+":ship", {
				"caption":"На одну отгрузку без печати",
				"onClick":function(){
					self.onCommandCont("shipment_transp_nakl", false);
				}
			})
			,new Button(this.getId()+":order", {
				"caption":"На все отгрузки без печати",
				"onClick":function(){
					self.onCommandCont("shipment_transp_nakl_all", false);
				}
			})
		],
		"caption":"Печать транспортных накладных"
	});
	var btn = DOMHelper.getParentByAttrValue(e.target, "name", "printTranspNakl");
	if(!btn){
		throw new Error("parent button not found");
	}
	p.show(e, btn);
}

ShipmentGridCmdPrintTranspNakl.prototype.onCommandCont = function(pmId, faksim){
	var self = this;
	this.m_grid.setModelToCurrentRow();
	var shipment_id = this.m_grid.getModel().getFieldValue("id");		
	var pm = (new Shipment_Controller).getPublicMethod(pmId);
	pm.setFieldValue("id", shipment_id);
	pm.setFieldValue("faksim", faksim);
	pm.download("ViewXML", 0, function(){
		window.showTempNote("Файл загружен", null, 5000);
	});
}

/* public methods */
