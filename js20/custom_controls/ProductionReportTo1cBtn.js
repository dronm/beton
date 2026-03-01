/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function ProductionReportTo1cBtn(id,options){
	options = options || {};	
		
	options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
	options.className = "btn "+options.colorClass+" btn-cmd prod-report-export";
	options.caption = " Продукция ";

	options.glyph = "glyphicon-download-alt";
	options.title="Экспортировать отчет производства в 1с";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_grid = options.grid;
	
	PrintInvoiceBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(ProductionReportTo1cBtn,Button);

/* Constants */


/* private members */

// ProductionReportTo1cBtn.prototype.afterExport = function(ref1c, cellNode){
// 	//delete button, add ref1c description
// 	DOMHelper.delNode(this.getId());
// 	const span = document.createTextNode(ref1c.descr);
// 	cellNode.appendChild(span);
// 	window.showTempNote("Отчет производства за смену экспортирован в 1с", null, 5000);
// }

/* public methods */
ProductionReportTo1cBtn.prototype.onClick = function(){
	var tr = DOMHelper.getParentByTagName(this.m_node,"tr");
	if(!tr){
		throw new Error("TR tag not found!");
	}
	var keys = CommonHelper.unserialize(tr.getAttribute("keys"));
	const id = keys.id;
	const pm = (new Connect1c_Controller()).getPublicMethod("production_report_export");
	pm.setFieldValue("id", id);
	window.setGlobalWait(true);
	this.setEnabled(false);

	const self = this;
	pm.run({
		ok: function(resp){
			self.m_grid.onRefresh(function(){
				window.showTempNote("Отчет производства за смену экспортирован в 1с", null, 5000);
			});
			// const m = resp.getModel("Result1c_Model");
			// if(!m || !m.getNextRow()){
			// 	throw new Error("response model 'Result1c_Model' not found");
			// }
			// self.afterExport(m.getFieldValue("obj"), DOMHelper.getParentByTagName(this.m_node,"td"));
		},
		all: function(){
			self.setEnabled(true);
			window.setGlobalWait(false);
		}
	})
}

