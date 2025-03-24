/* Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function VehicleDialog_View(id,options){	

	options = options || {};
	options.controller = new Vehicle_Controller();
	options.model = options.models.VehicleDialog_Model;
	
	VehicleDialog_View.superclass.constructor.call(this,id,options);
	
	let self = this;

	this.addElement(new EditString(id+":plate",{
		"labelCaption":"Рег.номер:",
		"maxLength":"6",
		"required":true
	}));	
	this.addElement(new EditString(id+":plate_region",{
		"labelCaption":"Регион номера:",
		"maxLength":"3"
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

	//insurance filling
	this.addElement(new Client1cEdit(id+":insurance_issuer",{
	}));	
	this.addElement(new BuhRBP1cEdit(id+":insurance_rbp",{
	}));	
	this.addElement(new ButtonCmd(id+":cmdAddOnRBPKASKO",{
		"caption":"Добавить КАСКО",
		"onClick":function(){
			self.cmdAddOnRBPKASKO();
		}
	}));	
	this.addElement(new ButtonCmd(id+":cmdAddOnRBPOSAGO",{
		"caption":"Добавить ОСАГО",
		"onClick":function(){
			self.cmdAddOnRBPOSAGO();
		}
	}));	

	this.addElement(new EditString(id+":leasor_pp",{
		"maxLength":"20",
		"labelCaption":"Номер п/п:",
		"placeholder":"Номер платежного поручения",
		"title":"Номер платежного поручения лизингодателя для заполнения"
	}));	
	this.addElement(new ButtonCmd(id+":cmdFillOnPP",{
		"caption":"Заполнить по п/п",
		"onClick":function(){
			self.cmdFillOnPP();
		}
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

	this.addElement(new VehicleMileageList_View(id+":mileage_list",{
		"detail":true
	}));		
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("plate")})
		,new DataBinding({"control":this.getElement("plate_region")})
		,new DataBinding({"control":this.getElement("load_capacity")})
		,new DataBinding({"control":this.getElement("driver"), "fieldId": "drivers_ref" })
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
		,new CommandBinding({"control":this.getElement("plate_region")})
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
	
	this.addDetailDataSet({
		"control":this.getElement("mileage_list").getElement("grid"),
		"controlFieldId": ["vehicle_id"],
		"value": [function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
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

VehicleDialog_View.prototype.cmdFillOnPP = function(){
	const ppNum = this.getElement("leasor_pp").getValue();
	if(!ppNum || !ppNum.length){
		throw new Error("Заполните номер п/п");
	}
	window.setGlobalWait(true);
	const self = this;
	const pm = (new Client1c_Controller()).getPublicMethod("get_leasor_on_pp");
	pm.setFieldValue("pp_num", ppNum);
	pm.run({
		"ok": function(resp){
			console.log(resp)
			const model = resp.getModel("Client1c_Model");
			if(!model || !model.getNextRow()){
				window.showTempWarn("П/п не найдено", null, 5000);
				return;
			}
			console.log(model)
			self.getElement("leasor").setValue(
				model.getFieldValue("client_name")
			);
			self.getElement("leasing_contract_num").setValue(
				model.getFieldValue("contract_num")
			);
			self.getElement("leasing_contract_date").setValue(
				date1c_to_date(model.getFieldValue("contract_date"))
			);
		},
		"all": function(){
			window.setGlobalWait(false);
		}
	});
}

function date1c_to_date(date1cStr){
	let dParts = date1cStr.split(" ")[0].split(".");
	if(dParts.length<3){
		throw new Error("dParts.length should be 3");
	}
	const d = DateHelper.strtotime(dParts[2]+"-"+dParts[1]+"-"+dParts[0]);
	return d;
}

VehicleDialog_View.prototype.getRBP = function(){
	const rbpCtrl = this.getElement("insurance_rbp");
	const rbp = rbpCtrl.getValue();
	if(!rbp || rbp.isNull()){
		throw new Error("Не задана статья");
	}

	const issuer = this.getElement("insurance_issuer").getValue();
	if(!issuer || issuer.isNull()){
		throw new Error("Не задан страхователь");
	}
	
	return {
		"rbp": rbp.getKey("name"),
		"issuer": issuer.getDescr(),
		"date_from": date1c_to_date(rbpCtrl.getAttr("date_from")),
		"date_to": date1c_to_date(rbpCtrl.getAttr("date_to")),
		"total": rbpCtrl.getAttr("total")
	};
}

VehicleDialog_View.prototype.addInsurance = function(rbpData, gridElemId){
	const grid = this.getElement(gridElemId);
	const pm = grid.getInsertPublicMethod();
	pm.setFieldValue("issuer", rbpData.issuer);
	pm.setFieldValue("total", rbpData.total);
	pm.setFieldValue("dt_from", rbpData.date_from);
	pm.setFieldValue("dt_to", rbpData.date_to);
	pm.run({
		"ok": (function(grid){
			return function(resp){
				grid.onRefresh();
			}
		})(grid)
	});
}

VehicleDialog_View.prototype.cmdAddOnRBPKASKO = function(){
	const rbpData = this.getRBP();
	console.log(rbpData);
	this.addInsurance(rbpData, "insurance_kasko");
}
VehicleDialog_View.prototype.cmdAddOnRBPOSAGO = function(){
	const rbpData = this.getRBP();
	console.log(rbpData);
	this.addInsurance(rbpData, "insurance_osago");
}
