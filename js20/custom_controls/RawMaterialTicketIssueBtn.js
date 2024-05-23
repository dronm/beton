/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function RawMaterialTicketIssueBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Выдать ";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-barcode";
	options.title="Выдать новые талоны";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_cmd = options.cmd;
	
	RawMaterialTicketIssueBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(RawMaterialTicketIssueBtn,Button);

/* Constants */


/* private members */

/* protected*/
RawMaterialTicketIssueBtn.prototype.m_grid;

/* public methods */
RawMaterialTicketIssueBtn.prototype.onClick = function(){
	this.m_grid.setModelToCurrentRow();
	var f = this.m_grid.getModel().getFields();
	var id = f.id.getValue();

	var self = this;
	this.m_view = new View("dialog:cont",{
		"elements":[
			new SupplierEdit("dialog:cont:carriers_ref",{
				"labelCaption":"Перевозчик:",
				"focus":true
			})

			,new QuarryEdit("dialog:cont:quarries_ref",{
				"labelCaption":"Карьер:"
			})

			,new MaterialSelect("dialog:cont:raw_materials_ref",{
				"labelCaption":"Материал:"
			})			

			,new EditInt("dialog:cont:quant",{
				"labelCaption":"Вес, т.:"
				,"cmdCalc":false
			})			
			,new EditDate("dialog:cont:expire_date",{
				"labelCaption":"Окончание срока:"
			})			
			
			,new EditInt("dialog:cont:barcode_from",{
				"labelCaption":"Номер с:",
				"onReset":function(){
					self.calcTicketCount();
				},
				"events":{
					"input":function(){
						self.calcTicketCount();
					}
				}
				,"cmdCalc":false
			})			
			,new EditInt("dialog:cont:barcode_to",{
				"labelCaption":"Номер по:",
				"onReset":function(){
					self.calcTicketCount();
				},
				"events":{
					"input":function(){
						self.calcTicketCount();
					}
				}
				,"cmdCalc":false
			})			
			,new Control("dialog:cont:inf", "DIV", {
				"attrs":{"class": "help-block text-info"}
			})						
		]
	});
	this.m_form = new WindowFormModalBS("dialog",{
		"content":this.m_view,
		"dialogWidth":"20%",
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Введите данные для создания талонов",
		"onClickCancel":function(){
			self.closeSelect();
		},
		"onClickOk":(function(productionSiteId){
			return function(){	
				var carriers_ref = self.m_view.getElement("carriers_ref").getValue();
				if(!carriers_ref || carriers_ref.isNull()){
					throw Error("Не задан перевозчик!");
				}

				var quarries_ref = self.m_view.getElement("quarries_ref").getValue();
				if(!quarries_ref|| quarries_ref.isNull()){
					throw Error("Не задан карьер!");
				}

				var raw_materials_ref = self.m_view.getElement("raw_materials_ref").getValue();
				if(!raw_materials_ref || raw_materials_ref.isNull()){
					throw Error("Не задан материал!");
				}
				if(!self.m_view.m_ticketCount){
					throw Error("Не определено количество талонов!");
				}
				var quant = self.m_view.getElement("quant").getValue();
				if(!quant){
					throw Error("Не задан вес!");
				}
				self.closeSelect(
					carriers_ref.getKey(),
					quarries_ref.getKey(),
					raw_materials_ref.getKey(),
					quant,
					self.m_view.getElement("barcode_from").getValue(),
					self.m_view.getElement("barcode_to").getValue(),
					self.m_view.getElement("expire_date").getValue()
				);
			}
		})(id)
		
	});
	
	this.m_form.open();

}

RawMaterialTicketIssueBtn.prototype.doCloseForm = function(){
	if(this.m_view){
		this.m_view.delDOM()	
		delete this.m_view;
	}
	if(this.m_form){
		this.m_form.delDOM();	
		delete this.m_form;
	}	
	
}

RawMaterialTicketIssueBtn.prototype.closeSelect = function(carrierId, quarryId, rawMaterialId, quant, barcodeFrom, barcodeTo, expireDate){
	if(carrierId && rawMaterialId && quant && barcodeFrom && barcodeTo && this.m_view.m_ticketCount){
		var pm = (new RawMaterialTicket_Controller()).getPublicMethod("generate");
		var self = this;
		
		pm.setFieldValue("carrier_id", carrierId);
		pm.setFieldValue("quarry_id", quarryId);
		pm.setFieldValue("raw_material_id", rawMaterialId);
		pm.setFieldValue("quant", quant);
		pm.setFieldValue("barcode_from", barcodeFrom);
		pm.setFieldValue("barcode_to", barcodeTo);
		pm.setFieldValue("expire_date", expireDate);
		window.setGlobalWait(true);
		pm.run({
			"ok":function(){
				self.m_grid.onRefresh(function(){
					window.showTempNote("Сгенерировано талонов: "+self.m_view.m_ticketCount,null,5000);
					self.doCloseForm();
				});				
			}
			,"all":function(){
				window.setGlobalWait(false);
			}
		});
	}else{
		this.doCloseForm();
	}
}

RawMaterialTicketIssueBtn.prototype.calcTicketCount = function(){
	if(!this.m_view){
		return;
	}
	this.m_view.m_ticketCount = 0;
	var barcode_from= this.m_view.getElement("barcode_from").getValue();
	if(barcode_from){
		var barcode_to= this.m_view.getElement("barcode_to").getValue();
		if(barcode_to){
			this.m_view.m_ticketCount = barcode_to - barcode_from + 1;
			this.m_view.getElement("inf").setValue("Количество талонов: "+this.m_view.m_ticketCount);
		}
	}
}

