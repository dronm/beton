/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2023

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function RawMaterialTicketGridCmdIssue(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	this.m_btn = new RawMaterialTicketIssueBtn(id+"btn",{
		"cmd":true
	});
	
	options.controls = [
		this.m_btn
	]	
	RawMaterialTicketGridCmdIssue.superclass.constructor.call(this,id,options);
		
}
extend(RawMaterialTicketGridCmdIssue,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
RawMaterialTicketGridCmdIssue.prototype.setGrid = function(v){
	RawMaterialTicketGridCmdIssue.superclass.setGrid.call(this,v);
	
	this.m_btn.m_grid = v;
	this.m_grid = v;
}

