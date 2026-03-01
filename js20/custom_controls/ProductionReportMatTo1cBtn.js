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
function ProductionReportMatTo1cBtn(id,options){
	options = options || {};	
		
	options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
	options.className = "btn "+options.colorClass+" btn-cmd prod-report-export";
	options.caption = " Материалы ";

	options.glyph = "glyphicon-download-alt";
	options.title="Экспортировать требование-налкадную в 1с";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_grid = options.grid;
	
	PrintInvoiceBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(ProductionReportMatTo1cBtn,Button);

/* Constants */


/* private members */

/* public methods */
ProductionReportMatTo1cBtn.prototype.onClick = function(){
	var tr = DOMHelper.getParentByTagName(this.m_node,"tr");
	if(!tr){
		throw new Error("TR tag not found!");
	}
	var keys = CommonHelper.unserialize(tr.getAttribute("keys"));
	const id = keys.id;
	const pm = (new Connect1c_Controller()).getPublicMethod("production_report_mat_export");
	pm.setFieldValue("id", id);
	window.setGlobalWait(true);
	this.setEnabled(false);

	const self = this;
	pm.run({
		ok: function(resp){
			self.m_grid.onRefresh(function(){
				window.showTempNote("Документ Требование-накладная экспортирован в 1с", null, 5000);
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


