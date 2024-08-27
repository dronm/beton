/** Copyright (c) 2020
 *	Andrey Mikhalevich, Katren ltd.
 */
function ShipmentForClientList_View(id,options){	

	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEAD_TITLE = "Журнал отгрузок";

	ShipmentForClientList_View.superclass.constructor.call(this,id,options);
	
	var self = this;
	
	var model = options.models.ShipmentForClientList_Model;
	var contr = new Shipment_Controller();

	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	var role = window.getApp().getServVar("role_id")
	var ext_user = (role=="vehicle_owner"||role=="client");

	var period_ctrl;
	var filters;
	
	if(ext_user){
		period_ctrl = new EditPeriodMonth(id+":filter-ctrl-period",{
			"field":new FieldDateTime("ship_date")
			,"onChange":function(dFrom,dTo){
				self.setGridFilter(dFrom,dTo);
				window.setGlobalWait(true);
				self.getElement("grid").onRefresh(function(){
					window.setGlobalWait(false);
				});			
			}		
			
		});
	}else{
		period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
			"field":new FieldDateTime("ship_date")
		});
	
		filters = {
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
		

		filters.destination = {
			"binding":new CommandBinding({
				"control":new DestinationForClientEdit(id+":filter-ctrl-destination",{
					"contClassName":"form-group-filter",
					"labelCaption":"Объект:"
				}),
				"field":new FieldInt("destination_id")}),
			"sign":"e"		
		};
		filters.concrete_type = {
			"binding":new CommandBinding({
				"control":new ConcreteTypeEdit(id+":filter-ctrl-concrete_type",{
					"contClassName":"form-group-filter",
					"labelCaption":"Марка:"
				}),
				"field":new FieldInt("concrete_type_id")}),
			"sign":"e"		
		};	
	}
	
	this.addElement(period_ctrl);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"keyIds":["order_id"],
		"readPublicMethod":contr.getPublicMethod("get_list_for_client"),
		"editInline":false,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"cmdDelete":false,
			"cmdFilter":!ext_user,
			"filters":filters,
			"variantStorage":options.variantStorage,
			"cmdExport":!ext_user
		}),
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:row0:ship_date",{
							"value":"Дата",
							"attrs":{"rowspan":"2"},
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnDate({
									"field":model.getField("ship_date"),
									"dateFormat":"d/m/y",
									"ctrlClass":EditDate,
									"searchOptions":{
										"field":new FieldDate("ship_date")
									}																		
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:row0:destinations_ref",{
							"value":"Объект",
							"attrs":{"rowspan":"2"},
							"columns":[
								new GridColumnRef({
									"field":model.getField("destinations_ref"),
									"ctrlClass":ext_user? DestinationForClientEdit:DestinationEdit,
									"searchOptions":{
										"field":new FieldInt("destination_id"),
										"searchType":"on_match",
										"typeChange":false
									},
									"form":null
								})
							]
						})
						,ext_user? null:
							new GridCellHead(id+":grid:head:row0:clients_ref",{
								"value":"Клиент",
								"attrs":{"rowspan":"2"},
								"columns":[
									new GridColumnRef({
										"field":model.getField("clients_ref"),
										"ctrlClass":ClientEdit,
										"searchOptions":{
											"field":new FieldInt("client_id"),
											"searchType":"on_match",
											"typeChange":false
										},
										"form":null
									})
								]
							})
					
						,new GridCellHead(id+":grid:head:row0:concrete_types_ref",{
							"value":"Марка",
							"attrs":{"rowspan":"2"},
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
						,new GridCellHead(id+":grid:head:row0:pump_exists",{
							"value":"Есть насос",
							"attrs":{"rowspan":"2"},
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("pump_exists")
									,"showFalse":false
								})
							]
						})												
						,new GridCellHead(id+":grid:head:row0:quant",{
							"value":"Количество",
							"attrs":{"rowspan":"2"},
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
						})						
						
						,new GridCellHead(id+":grid:head:row0:cost_title",{
							"value":"Стоимость",
							"attrs":{"colspan":"4"}
						})						
						
					]
				})
				,new GridRow(id+":grid:head:row1",{
					"elements":[
						,new GridCellHead(id+":grid:head:concrete_cost",{
							"value":"Бетон",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("concrete_cost")
									,"precision":"2"
								})
							]
						})						
						
						,new GridCellHead(id+":grid:head:deliv_cost",{
							"value":"Доставка",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("deliv_cost")
									,"precision":"2"
								})
							]
						})
						,new GridCellHead(id+":grid:head:pump_cost",{
							"value":"Насос",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("pump_cost")
									,"precision":"2"
								})
							]
						})						
						,new GridCellHead(id+":grid:head:total_cost",{
							"value":"Всего",
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("total_cost")
									,"precision":"2"
								})
							]
						})						
					]
				})				
			]
		}),
		"foot":new GridFoot(id+"grid:foot",{
			"autoCalc":true,			
			"elements":[
				new GridRow(id+":grid:foot:row0",{
					"elements":[
						new GridCell(id+":grid:foot:total_sp1",{
							"colSpan":ext_user? "4":"5"
						})											
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumnFloat({"id":"tot_quant"})
						})
						,new GridCellFoot(id+":grid:foot:tot_concrete_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_concrete_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_concrete_cost"})
						})
						,new GridCellFoot(id+":grid:foot:tot_deliv_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_deliv_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_deliv_cost"})
						})
						,new GridCellFoot(id+":grid:foot:tot_pump_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_pump_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_pump_cost"})
						})						
						,new GridCellFoot(id+":grid:foot:tot_total_cost",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"totalFieldId":"total_total_cost",
							"gridColumn":new GridColumnFloat({"id":"tot_total_cost"})
						})						
						
					]
				})		
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		"autoRefresh":false,
		"refreshInterval":0,
		"rowSelect":false,
		"focus":true
	}));		
}
extend(ShipmentForClientList_View,ViewAjxList);

ShipmentForClientList_View.prototype.setGridFilter = function(dFrom,dTo){
	var gr = this.getElement("grid");
	gr.setFilter({
		"field":"ship_date"
		,"sign":"ge"
		,"val":DateHelper.format(dFrom,"Y-m-d")
	});
	gr.setFilter({
		"field":"ship_date"
		,"sign":"le"
		,"val":DateHelper.format(dTo,"Y-m-d")
	});
}

