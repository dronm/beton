/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 */
function ShipmentDocRep_View(id,options){
	options = options || {};	

	let self = this;
	options.addElement = function(){
		this.addElement(new EditPeriodShift(id+":period",{
			"onChange":function(dateTime){
				window.setGlobalWait(true);
				self.cmdApplyFilter(function(){
					window.setGlobalWait(false);
				}, true);
			}
		}));	
	}
	ShipmentDocRep_View.superclass.constructor.call(this,id,options);
	
	this.cmdApplyFilter();
}

extend(ShipmentDocRep_View,View);

// ShipmentDocRep_View.prototype.toDOM = function(parent){
// 	ShipmentDocRep_View.superclass.toDOM.call(this, parent);
// 	window.getApp().addCollapseOnClick();
// }

ShipmentDocRep_View.prototype.getDocContNode = function(){
	return document.getElementById(this.getId() + ":report");
}

ShipmentDocRep_View.prototype.setTemplateContent = function(cont){
	var target_n = this.getDocContNode();
	if(!target_n){
		throw new Error("Doc container node not found");
	}
	target_n.innerHTML = cont;
}

ShipmentDocRep_View.prototype.cmdApplyFilterCont = function(model, callback){
	let templateOptions = {"VEHICLES": [], "ID": this.getId()};
	while(model.getNextRow()){
		let veh = model.getFieldValue("vehicles_ref");
		let dr = model.getFieldValue("drivers_ref");
		templateOptions.VEHICLES.push({
			"ID": this.getId(),
			"VEHICLE_SCHEDULE_ID": model.getFieldValue("id"),
			"VEHICLE_DESCR": veh.getDescr(),
			"DRIVER_DESCR": dr.getDescr()
		});
	}

	let tmpl = window.getApp().getTemplate("ShipmentDocRep_View");
	Mustache.parse(tmpl);
	this.setTemplateContent(Mustache.render(tmpl, templateOptions));

	let self = this;
	let cmdCont = document.getElementById(this.getId()+":cmdFetchShipmentList");
	(new ButtonCmd(this.getId()+":cmdFetchShipmentList", {
		"caption":"Показать отгрузки",
		"title":"Показать все отгрузки за период по выбранным экипажам",
		"onClick":function(){
			self.cmdFetchShipmentList();
		}
	})).toDOMInstead(cmdCont);

	window.getApp().addCollapseOnClick();

	DOMHelper.show(this.getId() + ":repPanel");

	if(callback){
		callback();
	}
}

ShipmentDocRep_View.prototype.cmdFetchShipmentList = function(){
	let ids = [];
	let inputs = DOMHelper.getElementsByAttr("schedule_select", this.getNode(), "class", false, "input");
	for(let i = 0; i< inputs.length; i++){
		if(!inputs[i].checked){
			continue;
		}
		ids.push(parseInt(inputs[i].getAttribute("vehicle_schedule_id"), 10));
	}
	if(!ids.length){
		throw new Error("Не выбран ни один экипаж");
	}

	let contr = new Shipment_Controller();
	let pm = contr.getPublicMethod("get_list_for_doc");

	let id = this.getId()+":doc_grid";
	let model = new ShipmentForDocList_Model();
	if(this.m_grid){
		this.m_grid.delDOM();
	}
	let self = this;
	this.m_grid = new GridAjx(id, {
		"filters":[{
			field:"vehicle_schedule_id",
			sign:"incl",
			val:ids.join(";")
		}],
		"model":model,
		"readPublicMethod":pm,
		"controller":contr,
		"editInline":false,
		"editWinClass":null,
		"commands":null,		
		"popUpMenu":null,
		"head":new GridHead(id+":grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:ship_date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("ship_date_time")})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"ctrlCalss":VehicleEdit,
									"searchOptions":{
										"field":new FieldInt("vehicle_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:drivers_ref",{
							"value":"Водитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("drivers_ref"),
									"ctrlCalss":DriverEditRef,
									"searchOptions":{
										"field":new FieldInt("driver_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Клиент",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlCalss":ClientEdit,
									"searchOptions":{
										"field":new FieldInt("client_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:destinations_ref",{
							"value":"Объект",
							"columns":[
								new GridColumnRef({
									"field":model.getField("destinations_ref"),
									"ctrlCalss":DestinationEdit,
									"searchOptions":{
										"field":new FieldInt("destination_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:concrete_types_ref",{
							"value":"Марка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("concrete_types_ref"),
									"ctrlCalss":ConcreteTypeEdit,
									"searchOptions":{
										"field":new FieldInt("concrete_type_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Объем",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant"),
									"precision":"4"
								})
							]
						})
						,new GridCellHead(id+":grid:head:docs",{
							"value":"Документы",
							"columns":[
								new GridColumn({
									"formatFunction":function(fields, cell){
										//two buttons: printPutList, printTTN
										let btnPrintPL = new PrintPutevoiListBtn(self.getId()+":doc_grid:printPL", {
											"cmd":"print"
										});
										btnPrintPL.m_grid = self.m_grid;
										cell.getNode().appendChild(btnPrintPL.m_node);

										let btnPrintTTN = new PrintTTNBtn(self.getId()+":doc_grid:printTTN", {
											"cmd":"print"
										});
										btnPrintTTN.m_grid = self.m_grid;
										cell.getNode().appendChild(btnPrintTTN.m_node);

										return "";
									}
								})
							]
						})
					]
				})
			]
		}),
		"pagination":null,
		"autoRefresh":true,
		"refreshInterval":null,
		"rowSelect":false,
		"focus":false
	});
	this.m_grid.toDOM(document.getElementById(this.getId()+":doc_grid_cont"));
}

//fetch shipments on: selected vehicle-schedules
ShipmentDocRep_View.prototype.cmdFetchShipmentListOld = function(){
	//get all marked vehicle_schedule ids
	let ids = [];
	let inputs = DOMHelper.getElementsByAttr("schedule_select", this.getNode(), "class", false, "input");
	for(let i = 0; i< inputs.length; i++){
		if(!inputs[i].checked){
			continue;
		}
		ids.push(parseInt(inputs[i].getAttribute("vehicle_schedule_id"), 10));
	}
	if(!ids.length){
		throw new Error("Не выбран ни один экипаж");
	}
	let contr = new Shipment_Controller();
	let pm = contr.getPublicMethod("get_list_for_doc");
	pm.setFieldValue(contr.PARAM_COND_FIELDS, "id");
	pm.setFieldValue(contr.PARAM_COND_SGNS, "incl");
	pm.setFieldValue(contr.PARAM_COND_VALS, ids.join(";"));
	pm.setFieldValue(contr.PARAM_COND_ICASE, "0");
	let self = this;
	pm.run({
		"ok":function(resp){
			self.cmdFetchShipmentListCont(resp.getModel("VehicleScheduleList_Model"));
		}
	});
}

ShipmentDocRep_View.prototype.cmdApplyFilter = function(callback){
	let d = this.getElement("period").getDateFrom();
	let contr = new VehicleSchedule_Controller();
	let pm = contr.getPublicMethod("get_list");
	pm.setFieldValue(contr.PARAM_COND_FIELDS, "schedule_date");
	pm.setFieldValue(contr.PARAM_COND_SGNS, "e");
	pm.setFieldValue(contr.PARAM_COND_VALS, DateHelper.format(d, "Y-m-dTH:i:s"));
	pm.setFieldValue(contr.PARAM_COND_ICASE, "0");
	pm.setFieldValue(contr.PARAM_ORD_FIELDS, "vehicles_ref"+contr.PARAM_FIELD_SEP_VAL+"drivers_ref");
	let self = this;
	pm.run({
		"ok":function(resp){
			self.cmdApplyFilterCont(resp.getModel("VehicleScheduleList_Model"), callback);
		}
	})

}
