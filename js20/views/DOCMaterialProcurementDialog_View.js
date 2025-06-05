/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2021

 * @extends ViewObjectAjx
 * @requires core/extend.js
 * @requires controls/ViewObjectAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function DOCMaterialProcurementDialog_View(id,options){
	options = options || {};	
	
	options.controller = new DOCMaterialProcurement_Controller();
	options.model = options.models.DOCMaterialProcurementDialog_Model;
	
	var self = this;

	var constants = {
		"first_shift_start_time":null
	};
	window.getApp().getConstantManager().get(constants);
	var st_time = constants.first_shift_start_time.getValue();
	
	options.addElement = function(){

		this.addElement(new ProductionBaseEdit(id+":production_bases_ref",{
			"value":new RefType({"keys":{"id":1}, "descr":"Утяшево"})
		}));	
		
		this.addElement(new EditString(id+":number",{
			"labelCaption":"Номер:",
			"placeholder":"Номер накладной",
			"length":"11"
		}));	

		this.addElement(new SupplierEdit(id+":suppliers_ref",{
			"placeholder":"Поставщик материала",
			"labelCaption":"Поставщик:"
		}));	
	
		this.addElement(new SupplierEdit(id+":carriers_ref",{
			"placeholder":"Перевозчик материала",
			"labelCaption":"Перевозчик:"
		}));	

		this.addElement(new EditDateTime(id+":date_time",{
			"labelCaption":"Дата:",
			"placeholder":"Дата поступления",
			"title":"Если оставить пустым будет проставлено текущее время",
			"editMask":"99/99/9999 99:99",
			"dateFormat":"d/m/Y H:i",
			"timeValueStr":st_time
		}));	

		var ac_model_dr = new DOCMaterialProcurementDriverList_Model();
		this.addElement(new EditString(id+":driver",{
			"placeholder":"ФИО водителя",
			"labelCaption":"Водитель:",
			"maxLength":"50",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":1,
			"acController":options.controller,
			"acModel":ac_model_dr,
			"acPublicMethod":options.controller.getPublicMethod("complete_driver"),
			"acPatternFieldId": "driver",
			"acKeyFields":[ac_model_dr.getField("driver")],
			"acDescrFields":[ac_model_dr.getField("driver")],
			"acICase":"1",
			"acMid": "1"			
		}));			
		
		var ac_model_v = new DOCMaterialProcurementVehicleList_Model();
		this.addElement(new EditString(id+":vehicle_plate",{
			"placeholder":"Гос.номер ТС",
			"labelCaption":"Гос.номер:",
			"maxLength":"10",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":1,
			"acController":options.controller,
			"acModel":ac_model_v,
			"acPublicMethod":options.controller.getPublicMethod("complete_vehicle_plate"),
			"acPatternFieldId": "vehicle_plate",
			"acKeyFields":[ac_model_v.getField("vehicle_plate")],
			"acDescrFields":[ac_model_v.getField("vehicle_plate")],
			"acICase":"1",
			"acMid": "1"			
		}));			
		
		this.addElement(new MaterialSelect(id+":materials_ref",{
			"labelCaption":"Материал:"
		}));	

		this.addElement(new CementSiloEdit(id+":cement_silos_ref",{
			"labelCaption":"Силос (для цемента):",
			"title":"Указывается только для материалов, учитываемых в силосах (цемент,добавки)"
		}));	
		
		var ac_model_sender = new DOCMaterialProcurementSenderNameList_Model();
		this.addElement(new EditString(id+":sender_name",{
			"labelCaption":"Пункт отправления:",
			"title":"Наименование пункта отправления материала",
			"placeholder":"Наименование пункта отправления материала",
			"maxLength":200,
			"cmdAutoComplete":true,
			"acMinLengthForQuery":1,
			"acController":options.controller,
			"acModel":ac_model_sender,
			"acPublicMethod":options.controller.getPublicMethod("complete_sender_name"),
			"acPatternFieldId": "sender_name",
			"acKeyFields":[ac_model_sender.getField("sender_name")],
			"acDescrFields":[ac_model_sender.getField("sender_name")],
			"acICase":"1",
			"acMid": "1"			
		}));	
		
		var ac_model_st = new DOCMaterialProcurementStoreList_Model();
		this.addElement(new EditString(id+":store",{
			"placeholder":"Место хранения материала",
			"labelCaption":"Склад:",
			"maxLength":"100",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":1,
			"acController":options.controller,
			"acModel":ac_model_st,
			"acPublicMethod":options.controller.getPublicMethod("complete_store"),
			"acPatternFieldId": "store",
			"acKeyFields":[ac_model_st.getField("store")],
			"acDescrFields":[ac_model_st.getField("store")],
			"acICase":"1",
			"acMid": "1"			
		}));			

		this.addElement(new EditFloat(id+":quant_net",{
			"precision":"2",
			"length":"19",
			"labelCaption":"Вес нетто:",
			"title":"Вес нетто, чистый вес"
		}));	
		
		this.addElement(new EditFloat(id+":quant_gross",{
			"precision":"2",
			"length":"19",
			"labelCaption":"Вес брутто:",
			"title":"Вес брутто, общий вес"
		}));	
		this.addElement(new EditFloat(id+":doc_quant_net",{
			"precision":"2",
			"length":"19",
			"labelCaption":"Вес нетто по документам:",
			"title":"Вес нетто по документам, чистый вес по документам"
		}));	
		
		this.addElement(new EditFloat(id+":doc_quant_gross",{
			"precision":"2",
			"length":"19",
			"labelCaption":"Вес брутто по документам:",
			"title":"Вес брутто по документам, общий вес по документам"
		}));	
		
	}
		
	DOCMaterialProcurementDialog_View.superclass.constructor.call(this,id,options);
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("date_time")})
		,new DataBinding({"control":this.getElement("production_bases_ref")})
		,new DataBinding({"control":this.getElement("number")})
		,new DataBinding({"control":this.getElement("suppliers_ref")})
		,new DataBinding({"control":this.getElement("carriers_ref")})
		,new DataBinding({"control":this.getElement("cement_silos_ref")})
		,new DataBinding({"control":this.getElement("materials_ref")})
		,new DataBinding({"control":this.getElement("sender_name")})
		,new DataBinding({"control":this.getElement("driver")})
		,new DataBinding({"control":this.getElement("vehicle_plate")})
		,new DataBinding({"control":this.getElement("store")})		
		,new DataBinding({"control":this.getElement("quant_net")})
		,new DataBinding({"control":this.getElement("doc_quant_gross")})
		,new DataBinding({"control":this.getElement("doc_quant_net")})
		,new DataBinding({"control":this.getElement("quant_gross")})
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("date_time")})
		,new CommandBinding({"control":this.getElement("number")})
		,new CommandBinding({"control":this.getElement("production_bases_ref"),"fieldId":"production_base_id"})
		,new CommandBinding({"control":this.getElement("suppliers_ref"),"fieldId":"supplier_id"})
		,new CommandBinding({"control":this.getElement("carriers_ref"),"fieldId":"carrier_id"})
		,new CommandBinding({"control":this.getElement("cement_silos_ref"),"fieldId":"cement_silos_id"})
		,new CommandBinding({"control":this.getElement("materials_ref"),"fieldId":"material_id"})
		,new CommandBinding({"control":this.getElement("driver")})
		,new CommandBinding({"control":this.getElement("sender_name")})
		,new CommandBinding({"control":this.getElement("vehicle_plate")})
		,new CommandBinding({"control":this.getElement("store")})
		,new CommandBinding({"control":this.getElement("quant_net")})
		,new CommandBinding({"control":this.getElement("quant_gross")})
	]);
	
}
//ViewObjectAjx,ViewAjxList
extend(DOCMaterialProcurementDialog_View,ViewObjectAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */
/*
DOCMaterialProcurementDialog_View.prototype.toDOM = function(p){
	DOCMaterialProcurementDialog_View.superclass.toDOM.call(this, p)
	console.log("DOCMaterialProcurementDialog_View.prototype.toDOM", this.getElement("date_time").getValue());
}
*/
