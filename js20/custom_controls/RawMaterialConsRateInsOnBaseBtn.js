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
function RawMaterialConsRateInsOnBaseBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Добавить на основании ";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-repeat";
	options.title="Добавить на основании данного подбора";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	RawMaterialConsRateInsOnBaseBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(RawMaterialConsRateInsOnBaseBtn,Button);

/* Constants */


/* private members */

/* protected*/
RawMaterialConsRateInsOnBaseBtn.prototype.m_grid;

/* public methods */
RawMaterialConsRateInsOnBaseBtn.prototype.onClick = function(){
	var base_id;
	if(this.m_cmd){
		this.m_grid.setModelToCurrentRow();
		base_id = this.m_grid.getModel().getFieldValue("id");
	}
	else{
		var tr = DOMHelper.getParentByTagName(this.m_node,"tr");
		if(!tr){
			throw new Error("TR tag not found!");
		}
		var keys = CommonHelper.unserialize(tr.getAttribute("keys"));
		base_id = keys.id;
	}
	
	(this.m_grid.getInsertPublicMethod()).setFieldValue("base_id", base_id);
	this.m_grid.edit("insert");
}

