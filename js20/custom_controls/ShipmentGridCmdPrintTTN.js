/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2021

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintTTN(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new PrintTTNBtn(id+"btn",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]
	
	/*
	options.glyph = "glyphicon-print";
	options.title="Напечатать накладную";
	options.caption = "Накладная ";
	*/
	ShipmentGridCmdPrintTTN.superclass.constructor.call(this,id,options);
		
}
extend(ShipmentGridCmdPrintTTN,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintTTN.prototype.setGrid = function(v){
	ShipmentGridCmdPrintTTN.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

