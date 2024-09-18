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
function PumpVehicleDialog_View(id,options){	

	options = options || {};
	
	options.controller = new PumpVehicle_Controller();
	options.model = options.models.PumpVehicleList_Model;
	
	let min_vals_enabled = !window.getApp().controlePumpVehicle();

	options.addElement = function(){
		this.addElement(new VehicleEdit(id+":pump_vehicles_ref",{
		}));	
		
		this.addElement(new VehicleOwnerEdit(id+":vehicle_owners_ref",{
		}));
			
		this.addElement(new PumpVehiclePriceListGrid(id+":pump_prices",{
		}));	
		
		this.addElement(new EditInt(id+":pump_length",{
			"labelCaption": "Длина подачи:"
		}));	
		
		this.addElement(new EditString(id+":comment_text",{
			"labelCaption": "Комметарий:",
			"maxLength": 100
		}));	
		
		this.addElement(new EditCheckBox(id+":deleted",{
			"labelCaption": "Удален:",
			"title": "Признак активности данной карточки"
		}));	
		
		this.addElement(new EditCheckBox(id+":specialist_inform",{
			"labelCaption": "Информировать специалиста:",
			"title": "Если установлен, специалист будет получать уведомления"
		}));	
		
		this.addElement(new EditCheckBox(id+":driver_ship_inform",{
			"labelCaption": "Информировать водителя (отгрузка):",
			"title": "Если установлен, водитель будет получать уведомления при отгрузке" 
		}));	

		this.addElement(new EditFloat(id+":min_order_quant",{
			"precision":2,
			"labelCaption": "Мин. кол-во для заявки, м3:",
			"title": "При выборе данного насоса в заявку будет контролироваться количество по заявке. Если количество по заявке меньше минимального, заявка не будет поставлена.",
			"enabled":min_vals_enabled
		}));	

		this.addElement(new EditTime(id+":min_order_time_interval",{
			"labelCaption": "Мин. время между заявками:",
			"title": "При выборе данного насоса в заявку будет контролироваться временной интервал между другими заявками с этим насосом. Если временной интервал меньше заданного, заявка не будет поставлена.",
			"enabled":min_vals_enabled
		}));	

		this.addElement(new EntityContactList_View(id+":contacts_list",{
			"detail":true
		}));		
		
	}
	
	PumpVehicleDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("pump_vehicles_ref"), "fieldId":"pump_vehicles_ref"})
		,new DataBinding({"control":this.getElement("vehicle_owners_ref"), "fieldId":"vehicle_owners_ref"})
		,new DataBinding({"control":this.getElement("pump_length")})
		,new DataBinding({"control":this.getElement("comment_text")})
		,new DataBinding({"control":this.getElement("deleted")})
		,new DataBinding({"control":this.getElement("specialist_inform")})
		,new DataBinding({"control":this.getElement("driver_ship_inform")})
		,new DataBinding({"control":this.getElement("min_order_quant")})
		,new DataBinding({"control":this.getElement("min_order_time_interval")})
		,new DataBinding({"control":this.getElement("pump_prices")})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("pump_vehicles_ref"), "fieldId":"vehicle_id"})
		,new CommandBinding({"control":this.getElement("pump_length")})		
		,new CommandBinding({"control":this.getElement("comment_text")})
		,new CommandBinding({"control":this.getElement("deleted")})
		,new CommandBinding({"control":this.getElement("specialist_inform")})
		,new CommandBinding({"control":this.getElement("driver_ship_inform")})
		,new CommandBinding({"control":this.getElement("min_order_quant")})
		,new CommandBinding({"control":this.getElement("min_order_time_interval")})
		,new CommandBinding({"control":this.getElement("pump_prices"), "fieldId":"pump_prices"})
	]);
	
	var self = this;
	this.addDetailDataSet({
		"control":this.getElement("contacts_list").getElement("grid"),
		"controlFieldId": ["entity_type", "entity_id"],
		"value": ["pump_vehicles", function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
}
extend(PumpVehicleDialog_View,ViewObjectAjx);
