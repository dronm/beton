/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 
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

import {ViewObjectAjx} from '../controls/ViewObjectAjx.js';

import {ClientNameEdit} from '../custom_controls/ClientNameEdit.js';
import {ClientNameFullEdit} from '../custom_controls/ClientNameFullEdit.js';
import {Client_Controller} from '../controllers/Client_Controller.js';

function ClientDialog_View(id,options){	

	options = options || {};
	
	options.controller = new Client_Controller();
	options.model = options.models.ClientDialog_Model;
	
	var self = this;
	options.addElement = function(){
		this.addElement(new ClientNameEdit(id+":name",{
			"view":this,
			"required":true,
			"focus":true,
			"placeholder":"Краткое наименование",
			"title":"Краткое наименование для удобного поиска и представления"
		}));	

		this.addElement(new ClientNameFullEdit(id+":name_full",{
			"required":true,
			"placeholder":"Полное наименование",
			"title":"Полное наименование в соответствии с учредительными документами"
		}));	
			
		this.addElement(new EditEmail(id+":email",{
			"labelCaption":"Эл.почта:",
			"title":"Адрес электронной почты",
			"placeholder":"Адрес электронной почты"
		}));	

		/*this.addElement(new EditPhone(id+":phone_cel",{
			"labelCaption":"Телефон:",
			"title":"Телефон"
		}));*/

		this.addElement(new EditText(id+":manager_comment",{
			"labelCaption":"Комментарий:",
			"title":"Любой комментарий, связанный с контрагентом"
		}));	

		this.addElement(new Enum_client_kinds(id+":client_kind",{
			"labelCaption":"Тип клиента:"
		}));	

		this.addElement(new UserEditRef(id+":manager",{
			"labelCaption":"Менеджер:"
		}));	

		this.addElement(new ClientTypeEdit(id+":client_type"));	

		this.addElement(new ClientComeFromEdit(id+":client_come_from"));
		
		this.addElement(new EntityContactList_View(id+":contacts_list",{
			"detail":true
		}));		

		this.addElement(new ClientSpecificationList_View(id+":specification_list",{
			"detail":true
		}));		

		this.addElement(new EditNum(id+":inn",{
			"labelCaption":"ИНН:",
			"maxLength":"12",
			"title":"ИНН организации или предпринимателя",
			"placeholder":"ИНН организации/предпринимателя"
		}));		
		this.addElement(new EditNum(id+":kpp",{
			"labelCaption":"КПП:",
			"maxLength":"10",
			"title":"КПП организации",
			"placeholder":"КПП организации"
		}));		

		this.addElement(new EditString(id+":address_legal",{
			"labelCaption":"Адрес:",
			"maxLength":"500",
			"title":"Юридический адрес организации/предпринимателя",
			"placeholder":"Юридический адрес организации/предпринимателя"
		}));		
		
		this.addElement(new UserEditRef(id+":accounts_ref",{
			"labelCaption":"Аккаунт:"
		}));	
		this.addElement(new EditDate(id+":account_from_date",{
			"labelCaption":"Дата начала выборки данных для клиента:",
			"title":"Клиент будет видеть данные начиная с этой даты дальше"
		}));		
		this.addElement(new EditBankAcc(id+":bank_account",{
			"labelCaption":"Расчетный счет:",
			"title":"Расчетный счет",
			"placeholder":"Расчетный счет организации/предпринимателя"
		}));		
		this.addElement(new BankEditRef(id+":banks_ref",{
			"labelCaption":"Банк:"
		}));		

		this.addElement(new Client1cEdit(id+":ref_1c",{
			//"onSelect":function(f){
			//	self.m_ref1c = f.ref.getValue();
			//}
		}));		
						
	}
	
	ClientDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("name_full")})
		,new DataBinding({"control":this.getElement("email")})
		,new DataBinding({"control":this.getElement("client_kind")})
		,new DataBinding({"control":this.getElement("manager_comment")})
		,new DataBinding({"control":this.getElement("manager"),"fieldId":"users_ref"})
		,new DataBinding({"control":this.getElement("accounts_ref"),"fieldId":"accounts_ref"})
		,new DataBinding({"control":this.getElement("client_come_from"),"fieldId":"client_come_from_ref"})
		,new DataBinding({"control":this.getElement("client_type"),"fieldId":"client_types_ref"})
		,new DataBinding({"control":this.getElement("inn")})
		,new DataBinding({"control":this.getElement("account_from_date")})
		,new DataBinding({"control":this.getElement("bank_account")})
		,new DataBinding({"control":this.getElement("banks_ref"),"fieldId":"banks_ref"})
		,new DataBinding({"control":this.getElement("ref_1c"),"fieldId":"ref_1c"})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("name_full")})
		,new CommandBinding({"control":this.getElement("email")})
		,new CommandBinding({"control":this.getElement("client_kind")})
		,new CommandBinding({"control":this.getElement("manager_comment")})
		,new CommandBinding({"control":this.getElement("manager"),"fieldId":"manager_id"})
		,new CommandBinding({"control":this.getElement("accounts_ref"),"fieldId":"user_id"})
		,new CommandBinding({"control":this.getElement("client_come_from"),"fieldId":"client_come_from_id"})
		,new CommandBinding({"control":this.getElement("client_type"),"fieldId":"client_type_id"})
		,new CommandBinding({"control":this.getElement("inn")})
		,new CommandBinding({"control":this.getElement("account_from_date")})
		,new CommandBinding({"control":this.getElement("bank_account")})
		,new CommandBinding({"control":this.getElement("banks_ref"),"fieldId":"bank_bik"})
		,new CommandBinding({"control":this.getElement("ref_1c"),"fieldId":"ref_1c"})
		/*,new CommandBinding({"func":function(ctrl, pm){
			if(self.m_ref1c){
				pm.setFieldValue("ref_1c", self.m_ref1c);
			}
		}})*/
	]);
		
	this.addDetailDataSet({
		"control":this.getElement("contacts_list").getElement("grid"),
		"controlFieldId": ["entity_type", "entity_id"],
		"value": ["clients", function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
	
	this.addDetailDataSet({
		"control":this.getElement("specification_list").getElement("grid"),
		"controlFieldId": ["client_id"],
		"value": [function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
	
}
extend(ClientDialog_View, ViewObjectAjx);

//ref 1c
/*
ClientDialog_View.prototype.getModified = function(){
	if(ClientDialog_View.superclass.getModified.call(this)){
		return true;
	}
	return (this.m_ref1c!=undefined);
}
*/
