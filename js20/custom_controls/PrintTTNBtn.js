/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2021

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function PrintTTNBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " ТТН ";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-print";
	options.title="Напечатать ТТН";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	PrintTTNBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(PrintTTNBtn,Button);

/* Constants */


/* private members */

/* protected*/
PrintTTNBtn.prototype.m_grid;

/* public methods */
PrintTTNBtn.prototype.onClick = function(){
	var id, pm;
	if(this.m_cmd){
		this.m_grid.setModelToCurrentRow();
		id = this.m_grid.getModel().getFieldValue("id");
		pm = this.m_grid.getReadPublicMethod().getController().getPublicMethod("shipment_ttn");
	}
	else{
		//var keys = CommonHelper.unserialize(this.gridColumn.gridCell.m_row.getAttr("keys"));
		var tr = DOMHelper.getParentByTagName(this.m_node,"tr");
		if(!tr){
			throw new Error("TR tag not found!");
		}
		var keys = CommonHelper.unserialize(tr.getAttribute("keys"));
		id = keys.id;
		pm = this.gridColumn.getGrid().getReadPublicMethod().getController().getPublicMethod("shipment_ttn");
	}
	
	pm.setFieldValue("id",id);	
	pm.download();
}
