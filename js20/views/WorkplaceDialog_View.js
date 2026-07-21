/* Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function WorkplaceDialog_View(id,options){	

	options = options || {};
	options.HEADER = 'Рабочее место пользователя';
	options.controller = new Workplace_Controller();
	options.model = options.models.WorkplaceList_Model;
	
	
	options.addElement = function(){
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:",
			"maxLength":"500"
		}));	
		this.addElement(new EditString(id+":tel_ext",{
			"labelCaption":"Внутр.номер:",
			"maxLength":"6",
			"required":false
		}));	

		this.addElement(new UserEditRef(id+":users_ref",{ 
		}));	

		this.addElement(new MacAddressListGrid(id+":mac_addresses",{
		}));	

	}

	WorkplaceDialog_View.superclass.constructor.call(this,id,options);

	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("tel_ext")})
		,new DataBinding({"control":this.getElement("users_ref"), "fieldId": "user_id" })
		,new DataBinding({"control":this.getElement("mac_addresses"),"fieldId":"mac_addresses"})
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("tel_ext")})
		,new CommandBinding({"control":this.getElement("users_ref"),"fieldId":"user_id"})
		,new CommandBinding({"control":this.getElement("mac_addresses"),"fieldId":"mac_addresses"})
	]);
	
}
extend(WorkplaceDialog_View,ViewObjectAjx);

