/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2023

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdPrintPassAll(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new PrintPassAllBtn(id+"btn",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]	
	ShipmentGridCmdPrintPassAll.superclass.constructor.call(this,id,options);
		
}
extend(ShipmentGridCmdPrintPassAll,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
ShipmentGridCmdPrintPassAll.prototype.setGrid = function(v){
	ShipmentGridCmdPrintPassAll.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

