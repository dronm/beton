/* Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function SupplierDialog_View(id,options){	

	options = options || {};
	options.controller = new Supplier_Controller();
	options.model = options.models.Supplier_Model;
	
	options.addElement = function(){
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:",
			"required":true,
			"maxLength":100
		}));	
		
		this.addElement(new ClientNameFullEdit(id+":name_full",{
		}));	
		
		this.addElement(new LangEditRef(id+":lang"));
		
		this.addElement(new EditCheckBox(id+":order_notification",{
			"labelCaption":"Отправлять уведомление о заказе:"
		}));		
	
		this.addElement(new EntityContactList_View(id+":contacts_list",{
			"detail":true
		}));		
	}	
	
	SupplierDialog_View.superclass.constructor.call(this,id,options);	
	//****************************************************		
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("name_full")})
		,new DataBinding({"control":this.getElement("lang"),"fieldId":"lang_id"})
		,new DataBinding({"control":this.getElement("order_notification")})
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("name_full")})
		,new CommandBinding({"control":this.getElement("lang"),"fieldId":"lang_id"})
		,new CommandBinding({"control":this.getElement("order_notification")})
	]);
	var self = this;
	this.addDetailDataSet({
		"control":this.getElement("contacts_list").getElement("grid"),
		"controlFieldId": ["entity_type", "entity_id"],
		"value": ["suppliers", function(){
			return self.m_model.getFieldValue("id");
		}]
	});			
}
extend(SupplierDialog_View,ViewObjectAjx);
