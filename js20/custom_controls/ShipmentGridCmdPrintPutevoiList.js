/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2021

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintPutevoiList(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new PrintPutevoiListBtn(id+"btn",{
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
	ShipmentGridCmdPrintPutevoiList.superclass.constructor.call(this,id,options);
		
}
extend(ShipmentGridCmdPrintPutevoiList,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintPutevoiList.prototype.setGrid = function(v){
	ShipmentGridCmdPrintPutevoiList.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

