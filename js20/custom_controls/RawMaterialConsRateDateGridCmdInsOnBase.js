/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2019

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function RawMaterialConsRateDateGridCmdInsOnBase(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new RawMaterialConsRateInsOnBaseBtn(id+"btnIns",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]
	
	RawMaterialConsRateDateGridCmdInsOnBase.superclass.constructor.call(this,id,options);
		
}
extend(RawMaterialConsRateDateGridCmdInsOnBase,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
RawMaterialConsRateDateGridCmdInsOnBase.prototype.setGrid = function(v){
	RawMaterialConsRateDateGridCmdInsOnBase.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

