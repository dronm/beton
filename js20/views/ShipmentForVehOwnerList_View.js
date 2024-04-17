/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function ShipmentForVehOwnerList_View(id,options){	

	ShipmentForVehOwnerList_View.superclass.constructor.call(this,id,options);
	
	var self = this;
	
	var model = options.models.ShipmentForVehOwnerList_Model;
	var contr = new Shipment_Controller();

	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null,"vehicle_owner_accord_from_day":null,"vehicle_owner_accord_to_day":null};
	window.getApp().getConstantManager().get(constants);

	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"field":new FieldDateTime("ship_date_time")
	});

	var role_id = window.getApp().getServVar("role_id");
	var smpl_v = (role_id=="vehicle_owner"||role_id=="client")

	var cur_d = (DateHelper.time()).getDate();
	var prev_month_acc_allowed = (cur_d>=constants.vehicle_owner_accord_from_day.getValue() && cur_d<=constants.vehicle_owner_accord_to_day.getValue());
	this.m_accDescr = {};
	
	var filters = {
		"period":{
			"binding":new CommandBinding({
				"control":period_ctrl,
				"field":period_ctrl.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":period_ctrl.getControlFrom(),
					"field":period_ctrl.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":period_ctrl.getControlTo(),
					"field":period_ctrl.getField()
					}),
				"sign":"le"
				}
			]
		}
	};
	
	filters.driver = {
		"binding":new CommandBinding({
			"control":new DriverEditRef(id+":filter-ctrl-driver",{
				"contClassName":"form-group-filter",
				"labelCaption":"Водитель:"
			}),
			"field":new FieldInt("driver_id")}),
		"sign":"e"		
	}
	filters.vehicle = {
		"binding":new CommandBinding({
			"control":new VehicleEdit(id+":filter-ctrl-vehicle",{
				"contClassName":"form-group-filter",
				"labelCaption":"ТС:"
			}),
			"field":new FieldInt("vehicle_id")}),
		"sign":"e"		
	};

	/*filters.destination = {
		"binding":new CommandBinding({
			"control":new DestinationEdit(id+":filter-ctrl-destination",{
				"contClassName":"form-group-filter",
				"labelCaption":"Объект:"
			}),
			"field":new FieldInt("destination_id")}),
		"sign":"e"		
	};*/
	filters.concrete_type = {
		"binding":new CommandBinding({
			"control":new ConcreteTypeEdit(id+":filter-ctrl-concrete_type",{
				"contClassName":"form-group-filter",
				"labelCaption":"Марка:"
			}),
			"field":new FieldInt("concrete_type_id")}),
		"sign":"e"		
	};	
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"readPublicMethod":contr.getPublicMethod("get_list_for_veh_owner"),
		"editInline":false,
		"editWinClass":ShipmentDialog_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"cmdDelete":false,
			"cmdFilter":true,
			"filters":filters,
			"variantStorage":options.variantStorage,
			"addCustomCommandsAfter" : (
				(window.getApp().getServVar("role_id")=="vehicle_owner")?
				function(commands){
					commands.push(new ShipmentForVehOwnerCmdSetAgreed(id+":grid:cmd:setAgreed"));
				}
				:null
				)			
			//"cmdExport":false
		}),
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:ship_date_time",{
							"value":"Дата",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnDate({
									"field":model.getField("ship_date_time"),
									"dateFormat":"d/m/y H:i",
									"ctrlClass":EditDate,
									"searchOptions":{
										"field":new FieldDate("ship_date_time"),
										"searchType":"on_beg"
									}																		
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,smpl_v? null : new GridCellHead(id+":grid:head:production_bases_ref",{
							"value":"База",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_bases_ref"),
									"form":null,
									"ctrlClass":ProductionBaseEdit,
									"searchOptions":{
										"field":new FieldInt("production_base_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						
						,smpl_v? null : new GridCellHead(id+":grid:head:vehicle_owners_ref",{
							"value":"Владелец ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicle_owners_ref"),
									"form":null,
									"ctrlClass":VehicleOwnerEdit,
									"searchOptions":{
										"field":new FieldInt("vehicle_owner_id"),
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
									"form":null,
									"ctrlClass":smpl_v? EditString:DestinationEdit,
									"searchOptions":{
										"field":smpl_v? (new FieldString("destinations_ref->descr")):(new FieldInt("destination_id")),
										"searchType":smpl_v? "on_part":"on_match",
										"typeChange":smpl_v
									}
								})
							],
							"sortable":true
						})
										
						,new GridCellHead(id+":grid:head:concrete_types_ref",{
							"value":"Марка",
							"colAttrs":{"clign":"center"},
							"columns":[
								new GridColumnRef({
									"field":model.getField("concrete_types_ref"),
									"ctrlClass":ConcreteTypeEdit,
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
							"value":"Количество",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"ctrlClass":VehicleEdit,
									"searchOptions":{
										"field":new FieldInt("vehicle_id"),
										"searchType":"on_match",
										"typeChange":false
									},
									"form":VehicleDialog_Form									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:drivers_ref",{
							"value":"Водитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("drivers_ref"),
									"form":Driver_Form,
									"ctrlClass":smpl_v? EditString:DriverEdit,
									"searchOptions":{
										"field":smpl_v? (new FieldString("drivers_ref->descr")):(new FieldInt("driver_id")),
										"searchType":smpl_v? "on_part":"on_match",
										"typeChange":smpl_v										
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:cost",{
							"value":"Доставка",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("cost"),
									"precision":2
								})
							]
						})
						,new GridCellHead(id+":grid:head:cost_for_driver",{
							"value":"Доставка для водителя",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("cost_for_driver"),
									"precision":2
								})
							]
						})
											
						,new GridCellHead(id+":grid:head:demurrage",{
							"value":"Время простоя",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("demurrage")
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:demurrage_cost",{
							"value":"За простой",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("demurrage_cost")									
								})
							]
						})
						,new GridCellHead(id+":grid:head:acc_comment_shipment",{
							"value":"Бух.коммент.",
							"columns":[
								new GridColumn({
									"field":model.getField("acc_comment_shipment")
								})
							]
						})	
						,new GridCellHead(id+":grid:head:owner_agreed",{
							"value":"Согласование",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"id":model.getField("owner_agreed"),
									"cellOptions":function(column,row){
										return (function(column,row){
											var res = {};
											var m = self.getElement("grid").getModel();
											if(m.getFieldValue("owner_agreed")){
												res.value = DateHelper.format(m.getFieldValue("owner_agreed_date_time"),"d/m/y");
											}
											else if(!m.getFieldValue("ship_date_time")){
												res.value = "Не отгружено";
											}
											else{
												var m_dif = ((DateHelper.time()).getMonth() - m.getFieldValue("ship_date_time").getMonth());
												if(m_dif==1 && prev_month_acc_allowed){
													var ctrl = new ButtonCmd(null,{
														"caption":"Согласовать",
														"onClick":function(){
															self.setOwnerAgreed(this);
														}
													});
													ctrl.m_row = row;
													res.elements = [ctrl];
												}
												else if(m_dif<=1){
													if(!self.m_accDescr["m_"+m_dif]){
														var ship_time = m.getFieldValue("ship_date_time");
														self.m_accDescr["m_"+m_dif] = {
															"from":DateHelper.format(
																new Date(ship_time.getFullYear(),ship_time.getMonth()+1,constants.vehicle_owner_accord_from_day.getValue())
																,"d/m/y"
																)
															,"to":DateHelper.format(
																new Date(ship_time.getFullYear(),ship_time.getMonth()+1,constants.vehicle_owner_accord_to_day.getValue())
																,"d/m/y"
																)
														};	
													}
													res.value = "Разрешено с "+self.m_accDescr["m_"+m_dif].from+" до "+self.m_accDescr["m_"+m_dif].to;
												}
											}
											return res;
										})(column,row)
									}
								})
							]
						})					
					]
				})
			]
		}),
		//"lastRowFooter":true,
		"foot":new GridFoot(id+"grid:foot",{
			"autoCalc":true,			
			"elements":[
				new GridRow(id+":grid:foot:row0",{
					"elements":[
						new GridCell(id+":grid:foot:total_sp1",{
							"colSpan": smpl_v? "3" : "5"
						})											
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumnFloat({"id":"tot_quant"})
						})
						,new GridCell(id+":grid:foot:total_sp2",{
							"colSpan":smpl_v? "3":"2"
						})																	
						,new GridCellFoot(id+":grid:foot:tot_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_cost"})
						})
						,new GridCellFoot(id+":grid:foot:tot_cost_for_driver",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_cost_for_driver",
							"gridColumn":new GridColumnFloat({"id":"tot_cost_for_driver"})
						})												
						,new GridCell(id+":grid:foot:total_sp4",{
							"colSpan":"1"
						})											
											
						,new GridCellFoot(id+":grid:foot:tot_demurrage_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_demurrage_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_demurrage_cost"})
						})						
						,new GridCell(id+":grid:foot:total_sp3",{
							"colSpan":"1"
						})						
					]
				})		
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));		
}
extend(ShipmentForVehOwnerList_View,ViewAjxList);

ShipmentForVehOwnerList_View.prototype.setOwnerAgreed = function(btn){
	var row = btn.m_row;
	var val = btn.getValue();
	var keys = CommonHelper.unserialize(row.getAttr("keys"));
	
	var pm = this.getElement("grid").getReadPublicMethod().getController().getPublicMethod("owner_set_agreed");
	pm.setFieldValue("shipment_id",keys.id);
	var slef = this;
	pm.run({
		"ok":function(resp){
			slef.getElement("grid").onRefresh(function(){
				window.showTempNote("Отгрузка согласована",null,2000);
			});
		}
	})
	
}
