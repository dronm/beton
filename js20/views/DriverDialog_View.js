/* Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function DriverDialog_View(id,options){	

	options = options || {};
	options.controller = new Driver_Controller();
	options.model = options.models.DriverList_Model;
	
	options.addElement = function(){	
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:",
			"required":true,
			"maxLength":50
		}));	
		
		this.addElement(new EditString(id+":driver_licence",{
			"labelCaption":"Водительское удостоверение:",
			"required":false,
			"maxLength":150
		}));	

		this.addElement(new EditString(id+":driver_licence_class",{
			"labelCaption":"Категории:",
			"required":false,
			"maxLength":10
		}));	
		
		this.addElement(new EntityContactList_View(id+":contacts_list",{
			"detail":true
		}));		
	}	
	
	DriverDialog_View.superclass.constructor.call(this,id,options);	
	//****************************************************		
	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("driver_licence")})
		,new DataBinding({"control":this.getElement("driver_licence_class")})
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("driver_licence")})
		,new CommandBinding({"control":this.getElement("driver_licence_class")})
	]);
	var self = this;
	this.addDetailDataSet({
		"control":this.getElement("contacts_list").getElement("grid"),
		"controlFieldId": ["entity_type", "entity_id"],
		"value": ["drivers", function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
	
}
extend(DriverDialog_View,ViewObjectAjx);
