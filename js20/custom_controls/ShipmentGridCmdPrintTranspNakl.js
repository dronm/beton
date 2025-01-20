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
	
	this.m_btn = new PrintTranspNaklBtn(id+"btn",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]
	
	ShipmentGridCmdPrintTranspNakl.superclass.constructor.call(this,id,options);
}
extend(ShipmentGridCmdPrintTranspNakl,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintTranspNakl.prototype.setGrid = function(v){
	ShipmentGridCmdPrintTranspNakl.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}
