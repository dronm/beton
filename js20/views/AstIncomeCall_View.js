/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2019

 * @extends ViewObjectAjx
 * @requires core/extend.js
 * @requires controls/ViewObjectAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function AstIncomeCall_View(id,options){

	options = options || {};
	options.controller = new AstCall_Controller();
	options.model = options.models.AstCallCurrent_Model;

	var client_id;
	if (options.model.getRowCount()){
		var pm = options.controller.getPublicMethod("update");
		pm.setFieldValue("unique_id",options.model.getFieldValue("unique_id"));
		client_id = options.model.getFieldValue("client_id");
	}
	options.template = window.getApp().getTemplate("AstIncomeCall_View");
	options.templateOptions = {};
	options.templateOptions.isClient = client_id? true:false;

	this.m_onMakeOrder = options.onMakeOrder;

	var self = this;
	options.addElement = function(){
		this.addElement(new EditPhone(id+":contact_tel",{
			"labelCaption":"Телефон:",
			"enabled":false,
			"cmdClear":false
		}));	
	
		this.addElement(new EditString(id+":contact_name",{
			"labelCaption":"Контактное лицо:",
			"maxLength":200
		}));	

		this.addElement(new EditText(id+":manager_comment",{
			"labelCaption":"Комментарий звонка:",
			"rows":"2",
			"maxLength":1000,
			"cmdClear":false
		}));	

		this.addElement(new ClientEdit(id+":client",{
			"cmdInsert":true
		}));	

		if(client_id){
			this.addElement(new AstCallClientCallHistoryList_View(id+":client_call_history",{
				"detail":true,
				"models":{
					"AstCallClientCallHistoryList_Model":options.models.AstCallClientCallHistoryList_Model
				}
			}));			

			this.addElement(new AstCallClientShipHistoryList_View(id+":client_ship_history",{
				"detail":true,
				"models":{
					"AstCallClientShipHistoryList_Model":options.models.AstCallClientShipHistoryList_Model
				}			
			}));			
		}
		
		this.addElement(new ButtonCmd(id+":cmdUpdate",{
			"caption":" Изменить",
			"glyph":"glyphicon-pencil",
			"onClick":function(){
				
				self.getElement("cmdUpdate").setEnabled(false);
				self.onSave(
					/*
					function(){
						var client_id = self.getElement("client").getValue().getKey();
						if(!client_id||client_id=="null"){
							self.getElement("client").setKeys(self.getElement("client").getInitKeys());
						}
					}
					*/
					null,
					function(resp,errCode,errStr){						
						self.setError(window.getApp().formatError(errCode,errStr));
					},
					function(){
						self.getElement("cmdUpdate").setEnabled(true);
					}
				);
			}
		})
		);			

		this.addElement(new OrderCalc_View(id+":calc",{
			"calc":true,
			"dialogContext":this,
			"getPayCash":function(){
				return true;
			}
		}));			
	
		this.addElement(new ButtonCmd(id+":cmdMakeOrder",{
			"caption":" Оформить заявку",
			"glyph":"glyphicon-plus",
			"onClick":function(){
					//update first
					self.onSave(function(){
						self.m_onMakeOrder();
					});					
				}
			})
		);			
	}
	
	options.cmdOk = false;
	options.cmdCancel = false;
	options.cmdSave = false;

	AstIncomeCall_View.superclass.constructor.call(this,id,options);

	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("contact_name")})
		,new DataBinding({"control":this.getElement("contact_tel")})
		//,new DataBinding({"control":this.getElement("client_manager_descr")})
		,new DataBinding({"control":this.getElement("manager_comment")})
		,new DataBinding({"control":this.getElement("client"), "fieldId":"clients_ref"})
		//,new DataBinding({"control":this.getElement("client_kind")})
		//,new DataBinding({"control":this.getElement("client_type"),"fieldId":"client_types_ref"})
		//,new DataBinding({"control":this.getElement("client_come_from"),"fieldId":"client_come_from_ref"})
		//,new DataBinding({"control":this.getElement("client_debt")})
	];
	this.setDataBindings(r_bd);
	
	var write_b = [
		new CommandBinding({"control":this.getElement("contact_name")})
		,new CommandBinding({"control":this.getElement("manager_comment")})		
		,new CommandBinding({"control":this.getElement("client"),"fieldId":"client_id"})
		//,new CommandBinding({"control":this.getElement("client_come_from"),"fieldId":"client_come_from_id"})
		//,new CommandBinding({"control":this.getElement("client_type"),"fieldId":"client_type_id"})
		//,new CommandBinding({"control":this.getElement("client_kind")})
		,new CommandBinding({
			"func":function(pm){
				var client_id = self.getElement("client").getValue().getKey();
				if(self.m_model.getFieldValue("clients_ref").getDescr()!=self.getElement("client").getNode().value){
					pm.setFieldValue("client_name",self.getElement("client").getNode().value);
					if(!client_id||client_id=="null"){
						self.getElement("client").setKeys(self.getElement("client").getInitKeys());
						DOMHelper.delClass(self.getElement("client").getNode(),"null-ref");
						client_id = self.getElement("client").getInitKeys().id;
					}
				}
				else{
					pm.unsetFieldValue("client_name");
				}
				pm.setFieldValue("client_id",client_id);
			}
		})
	];
	this.setWriteBindings(write_b);

	if(client_id){
		this.addDetailDataSet({
			"control":this.getElement("client_call_history").getElement("grid"),
			"controlFieldId":"client_id",
			"value":client_id
		});

		this.addDetailDataSet({
			"control":this.getElement("client_ship_history").getElement("grid"),
			"controlFieldId":"client_id",
			"value":client_id
		});
		
		//debts 500000;
		var client_debt = options.model.getFieldValue("debt");	
		if(client_debt != undefined && client_debt != 0){
			var debt_n = document.getElementById(id+":client_debt");
			var client_debt_pref = "";
			if(client_debt){
				DOMHelper.addClass(debt_n, "text-danger");
				client_debt_pref = "Долг: ";
				
			}else if (client_debt < 0){
				DOMHelper.addClass(debt_n, "text-success");
			}
			var client_debt_s = CommonHelper.numberFormat(client_debt, 2, ",", " " );
			DOMHelper.setText(debt_n, client_debt_pref + client_debt_s + " руб.");
		}
		
	}	
}
//ViewObjectAjx,ViewAjxList
extend(AstIncomeCall_View,ViewObjectAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */
