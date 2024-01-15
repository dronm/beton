/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2023

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintPassShip(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new PrintPassShipBtn(id+"btn",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]	
	ShipmentGridCmdPrintPassShip.superclass.constructor.call(this,id,options);
		
}
extend(ShipmentGridCmdPrintPassShip,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintPassShip.prototype.setGrid = function(v){
	ShipmentGridCmdPrintPassShip.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

