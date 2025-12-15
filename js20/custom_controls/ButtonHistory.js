/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2025

 * @class
 * @classdesc Basic command button

 * @extends ButtonHistory

 * @requires core/extend.js  
 * @requires controls/ButtonHistory.js

 * @param {string} id Object identifier
 * @param {namespace} options
 * @param {string} [options.caption=this.DEF_CAPTION]
 * @param {string} [options.title=this.DEF_HINT]
*/
function ButtonHistory(id,options){
	options = options || {};
	options.colorClass = "btn-info";
	
	options.caption = "История";
	options.title = "Показать историю изменений объекта";

	this.m_getRecordId = options.getRecordId;
	this.m_tableName = options.tableName;

	const self = this;
	options.onClick = function(){
		self.onClick();
	}

	ButtonHistory.superclass.constructor.call(this,id,options);
}
extend(ButtonHistory, ButtonCmd);

ButtonHistory.prototype.onClick = function() {
	const contr = new AuditLog_Controller();
	const pm = contr.getPublicMethod("get_list");

	const sep = contr.PARAM_FIELD_SEP_VAL;
	pm.setFieldValue("field_sep", sep);
	pm.setFieldValue(contr.PARAM_COND_FIELDS, "table_name"+sep+"record_id");
	pm.setFieldValue(contr.PARAM_COND_SGNS, "e"+sep+"e");
	pm.setFieldValue(contr.PARAM_COND_VALS, this.m_tableName+sep+this.m_getRecordId());
	pm.setFieldValue(contr.PARAM_COND_ICASE, "1"+sep+"1");
	const self = this;
	pm.run({
		ok: function(resp){
			console.log("resp:",resp)
			const model = resp.getModel("AuditLogList_Model");
			self.onClickCont(model);
		}
	});
}

ButtonHistory.prototype.onClickCont = function(model) {
	const self = this;
	this.m_view = new AuditLogList_View("dialog:cont", {
		detail: true,
		models: {
			AuditLogList_Model: model
		}
	});

	this.m_form = new WindowFormModalBS("dialog",{
		"content":this.m_view,
		"dialogWidth":"60%",
		"cmdCancel":false,
		"cmdOk":false,
		"contentHead":"История изменений объекта",
		"onClickCancel":function(){
			self.doCloseForm();
		},
	});
	
	this.m_form.open();
}

ButtonHistory.prototype.doCloseForm = function(){
	if(this.m_view){
		this.m_view.delDOM()	
		delete this.m_view;
	}
	if(this.m_form){
		this.m_form.delDOM();	
		delete this.m_form;
	}	
	
}
