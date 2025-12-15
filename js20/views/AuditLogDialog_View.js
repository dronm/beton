/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2025
 
 * @extends ViewObjectAjx.js
 * @requires core/extend.js  
 * @requires controls/ViewObjectAjx.js 
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {object} options
 * @param {object} options.models All data models
 * @param {object} options.variantStorage {name,model}
 */	
function AuditLogDialog_View(id,options){	

	options = options || {};

	options.cmdOk = false;
	options.cmdSave = false;
	options.cmdCancel = false;
	
	// console.log("options:",options)
	options.controller = new AuditLog_Controller();

	const model = options.detailFilters?.AuditLogDialog_Model;
	if( model && model.length){
		//from common list
		this.m_detailId = model[0].val;
		options.keys = {id: this.m_detailId};
	}

	options.model = options.model || (
		(options?.models?.AuditLogForObject_Model) 
		?options.models.AuditLogForObject_Model
		: new AuditLogForObject_Model()
	);
	
	var self = this;
	options.addElement = function(){
		// this.addElement(new EditString(id+":table_name",{
		// 	"enabled": false,
		// 	"labelCaption": "Таблица базы данных:"
		// }));	

		// this.addElement(new EditString(id+":record_id",{
		// 	"enabled": false,
		// 	"labelCaption": "Идентификатор базы данных:"
		// }));	
		// this.addElement(new EditString(id+":type_descr",{
		// 	"enabled": false,
		// 	"labelCaption": "Представление типа:"
		// }));	
		// this.addElement(new EditString(id+":object_ref",{
		// 	"enabled": false,
		// 	"labelCaption": "Объект:"
		// }));	
		this.addElement(new EditDateTime(id+":changed_at",{
			"enabled": false,
			"labelCaption": "Время:"
		}));	
		this.addElement(new EditString(id+":changed_by",{
			"enabled": false,
			"labelCaption": "Пользователь:"
		}));	
		this.addElement(new EditString(id+":operation_descr",{
			"enabled": false,
			"labelCaption": "Операция:"
		}));	

		this.addElement(new AuditLogChangeGrid(id+":changes",{
		}));	
	}
	
	AuditLogDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		// new DataBinding({"control":this.getElement("table_name")})
		// ,new DataBinding({"control":this.getElement("record_id")})
		// ,new DataBinding({"control":this.getElement("type_descr")})		
		// ,new DataBinding({"control":this.getElement("object_ref")})
		new DataBinding({"control":this.getElement("changed_at")})
		,new DataBinding({"control":this.getElement("changed_by")})
		,new DataBinding({"control":this.getElement("operation_descr")})
		,new DataBinding({"control":this.getElement("changes")})
	]);
	
	//write
	this.setWriteBindings([]);

}
extend(AuditLogDialog_View,ViewObjectAjx);

AuditLogDialog_View.prototype.onGetData = function(resp, cmd){
	AuditLogDialog_View.superclass.onGetData.call(this,resp,cmd);

	var m = this.getModel();
	console.log("changes:",m.getFieldValue("changes"));

	this.getElement("changes").onRefresh();
}

AuditLogDialog_View.prototype.toDOM = function(parent){
	AuditLogDialog_View.superclass.toDOM.call(this,parent,this.getCmd());

	if( this.m_detailId){
		//from common list
		console.log("retrieving id:",this.m_detailId)
		const pm = this.getController().getPublicMethod("get_object");
		pm.setFieldValue("id", this.m_detailId);
		const self = this;
		pm.run({
			"ok":function(resp){
				self.onGetData(resp,"get_object");
			}
		});

	}

}
