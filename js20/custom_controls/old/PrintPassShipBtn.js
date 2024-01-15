/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function PrintPassShipBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Паспорт ";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-print";
	options.title="Напечатать паспорт на одну отрузку";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	PrintPassShipBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(PrintPassShipBtn,Button);

/* Constants */


/* private members */

/* protected*/
PrintPassShipBtn.prototype.m_grid;

/* public methods */
PrintPassShipBtn.prototype.onClick = function(){
	var id;
	pm = (new Shipment_Controller()).getPublicMethod("get_passport_ship");
	if(this.m_cmd){
		this.m_grid.setModelToCurrentRow();
		id = this.m_grid.getModel().getFieldValue("id");
		//pm = this.m_grid.getReadPublicMethod().getController().getPublicMethod("get_passport_ship");
	}
	else{
		//var keys = CommonHelper.unserialize(this.gridColumn.gridCell.m_row.getAttr("keys"));
		var tr = DOMHelper.getParentByTagName(this.m_node,"tr");
		if(!tr){
			throw new Error("TR tag not found!");
		}
		var keys = CommonHelper.unserialize(tr.getAttribute("keys"));
		id = keys.id;
		//pm = this.gridColumn.getGrid().getReadPublicMethod().getController().getPublicMethod("get_passport_ship");
	}
	
	var offset = 0;
	pm.setFieldValue("id",id);	
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;
	pm.openHref("ViewPDF","location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);
}
