/* Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function VehicleDialog_View(id,options){	

	options = options || {};
	options.controller = new Vehicle_Controller();
	options.model = options.models.VehicleDialog_Model;
	
	VehicleDialog_View.superclass.constructor.call(this,id,options);
	
	this.addElement(new EditString(id+":plate",{
		"labelCaption":"Рег.номер:",
		"maxLength":"6",
		"required":true
	}));	
	this.addElement(new EditFloat(id+":load_capacity",{
		"precision":"2",
		"labelCaption":"Грузоподъемность:"
	}));	
	this.addElement(new DriverEditRef(id+":driver"));	
	
	this.addElement(new MakeEdit(id+":make"));	
	
	this.addElement(new FeatureEdit(id+":feature"));	
	
	this.addElement(new GPSTrackerRef(id+":tracker_id"));	
	
	this.addElement(new EditString(id+":sim_id",{
		"maxLength":"20",
		"labelCaption":"Идентификатор СИМ карты:",
		"enabled":false
	}));	

	this.addElement(new EditPhone(id+":sim_number",{
		"labelCaption":"Номер телефона СИМ карты:",
		"enabled":false
	}));	

	this.addElement(new EditDateTime(id+":tracker_last_dt",{
		"labelCaption":"Последние данные трэкера:",
		"enabled":false
	}));	

	this.addElement(new EditNum(id+":tracker_sat_num",{
		"labelCaption":"Количество спутников:",
		"enabled":false
	}));	

	this.addElement(new OwnerListGrid(id+":owners",{
	}));	
	this.addElement(new InsuranceListGrid(id+":insurance_osago",{
	}));	
	this.addElement(new InsuranceListGrid(id+":insurance_kasko",{
	}));	

	this.addElement(new LeasorEdit(id+":leasor",{
	}));	
	this.addElement(new EditMoney(id+":leasing_total",{
		"labelCaption":"Сумма по договору:"
	}));	

	this.addElement(new EditDate(id+":leasing_contract_date",{
		"labelCaption":"Дата договора:",
	}));	
	this.addElement(new EditString(id+":leasing_contract_num",{
		"maxLength":"100",
		"labelCaption":"Номер договора:",
	}));	

	this.addElement(new EditInt(id+":ord_num",{
		"labelCaption":"Порядковый номер:",
	}));	

	this.addElement(new EditInt(id+":weight_t",{
		"labelCaption":"Масса, тонн:",
	}));	
	
	this.addElement(new EditString(id+":vin",{
		"labelCaption":"VIN:",
		"maxLength": 17
	}));	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("plate")})
		,new DataBinding({"control":this.getElement("load_capacity")})
		,new DataBinding({"control":this.getElement("driver")})
		,new DataBinding({"control":this.getElement("make")})
		,new DataBinding({"control":this.getElement("owners"),"fieldId":"vehicle_owners"})
		,new DataBinding({"control":this.getElement("insurance_osago"),"fieldId":"insurance_osago"})
		,new DataBinding({"control":this.getElement("insurance_kasko"),"fieldId":"insurance_kasko"})
		,new DataBinding({"control":this.getElement("leasor"),"fieldId":"leasor"})
		,new DataBinding({"control":this.getElement("leasing_total"),"fieldId":"leasing_total"})
		,new DataBinding({"control":this.getElement("leasing_contract_num"),"fieldId":"leasing_contract_num"})
		,new DataBinding({"control":this.getElement("leasing_contract_date"),"fieldId":"leasing_contract_date"})
		,new DataBinding({"control":this.getElement("feature")})
		,new DataBinding({"control":this.getElement("tracker_id")})
		,new DataBinding({"control":this.getElement("sim_id")})
		,new DataBinding({"control":this.getElement("sim_number")})
		,new DataBinding({"control":this.getElement("tracker_last_dt")})
		,new DataBinding({"control":this.getElement("tracker_sat_num")})
		,new DataBinding({"control":this.getElement("ord_num")})
		,new DataBinding({"control":this.getElement("weight_t")})		
		,new DataBinding({"control":this.getElement("vin")})		
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("plate")})
		,new CommandBinding({"control":this.getElement("load_capacity")})
		,new CommandBinding({"control":this.getElement("driver"),"fieldId":"driver_id"})
		,new CommandBinding({"control":this.getElement("make")})
		,new CommandBinding({"control":this.getElement("owners"),"fieldId":"vehicle_owners"})
		,new CommandBinding({"control":this.getElement("insurance_osago"),"fieldId":"insurance_osago"})
		,new CommandBinding({"control":this.getElement("insurance_kasko"),"fieldId":"insurance_kasko"})
		,new CommandBinding({"control":this.getElement("leasor"),"fieldId":"leasor"})
		,new CommandBinding({"control":this.getElement("leasing_total"),"fieldId":"leasing_total"})
		,new CommandBinding({"control":this.getElement("leasing_contract_num"),"fieldId":"leasing_contract_num"})
		,new CommandBinding({"control":this.getElement("leasing_contract_date"),"fieldId":"leasing_contract_date"})
		,new CommandBinding({"control":this.getElement("feature")})
		,new CommandBinding({"control":this.getElement("vin")})
		,new CommandBinding({"control":this.getElement("tracker_id")})
		,new CommandBinding({"control":this.getElement("ord_num")})
		,new CommandBinding({"control":this.getElement("weight_t")})		
		//,new CommandBinding({"control":this.getElement("sim_id")})
		//,new CommandBinding({"control":this.getElement("sim_number")})
	]);
	
}
extend(VehicleDialog_View,ViewObjectAjx);

VehicleDialog_View.prototype.onGetData = function(resp,cmd){
	VehicleDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	if(window.getApp().getServVar("role_id")=="vehicle_owner"){
		this.setEnabled(false);
		this.getControlOK().setEnabled(true);
		this.getControlSave().setEnabled(true);
		this.getControlCancel().setEnabled(true);
	}
}
