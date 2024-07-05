/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function RawMaterialTicketList_View(id,options){	

	options.HEAD_TITLE = "Журнал талонов на материала";
	RawMaterialTicketList_View.superclass.constructor.call(this,id,options);

	var model = options.models.RawMaterialTicketList_Model;
	var contr = new RawMaterialTicket_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var r = window.getApp().getServVar("role_id");
	
	var issue_period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-issue_period",{
		"field":new FieldDateTime("issue_date_time")
	});
	var close_period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-close_period",{
		"field":new FieldDateTime("close_date_time")
	});
	
	var filters = {
		"issue_period":{
			"binding":new CommandBinding({
				"control":issue_period_ctrl,
				"field":issue_period_ctrl.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":issue_period_ctrl.getControlFrom(),
					"field":issue_period_ctrl.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":issue_period_ctrl.getControlTo(),
					"field":issue_period_ctrl.getField()
					}),
				"sign":"le"
				}
			]
		}
		,"close_period":{
			"binding":new CommandBinding({
				"control":close_period_ctrl,
				"field":close_period_ctrl.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":close_period_ctrl.getControlFrom(),
					"field":close_period_ctrl.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":close_period_ctrl.getControlTo(),
					"field":close_period_ctrl.getField()
					}),
				"sign":"le"
				}
			]
		}
		
		,"carrier":{
			"binding":new CommandBinding({
				"control":new SupplierEdit(id+":filter-ctrl-carrier",{
					"contClassName":"form-group-filter",
					"labelCaption":"Перевозчик:"
				}),
				"field":new FieldInt("carrier_id")}),
			"sign":"e"		
		}
		,"quarry":{
			"binding":new CommandBinding({
				"control":new QuarryEdit(id+":filter-ctrl-quarry",{
					"contClassName":"form-group-filter",
					"labelCaption":"Карьер:"
				}),
				"field":new FieldInt("quarry_id")}),
			"sign":"e"		
		}
		,"material":{
			"binding":new CommandBinding({
				"control":new MaterialSelect(id+":filter-ctrl-material",{
					"contClassName":"form-group-filter",
					"labelCaption":"Материал:"
				}),
				"field":new FieldInt("raw_material_id")}),
			"sign":"e"		
		}
		
	}
		
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd", {
			"cmdInsert":false,
			"cmdEdit":(r=="owner" || r=="admin" || r == "boss" || r == "weighing"),
			"cmdDelete":(r=="owner" || r=="admin" || r == "boss" || r == "weighing"),
			"cmdFilter":true,
			"filters":filters,
			"addCustomCommandsAfter":function(commands){
				commands.push(new RawMaterialTicketGridCmdIssue(id+":grid:cmd:issue"));
			}
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:carriers_ref",{
							"value":"Перевозчик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("carriers_ref"),
									"ctrlOptions":{
										"labelCaption": ""
									},
									"ctrlClass":SupplierEdit,
									"ctrlBindFieldId": "carrier_id"
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:raw_materials_ref",{
							"value":"Материал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("raw_materials_ref"),
									"ctrlOptions":{
										"labelCaption": ""
									},
									"ctrlClass":MaterialSelect,
									"ctrlBindFieldId": "raw_material_id"
								})
							]
						})
						,new GridCellHead(id+":grid:head:quarries_ref",{
							"value":"Карьер",
							"columns":[
								new GridColumnRef({
									"field":model.getField("quarries_ref"),
									"ctrlOptions":{
										"labelCaption": ""
									},
									"ctrlClass":QuarryEdit,
									"ctrlBindFieldId": "quarry_id"
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:barcode",{
							"value":"Штрихкод",
							"columns":[
								new GridColumn({
									"field":model.getField("barcode"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":13
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Вес",
							"columns":[
								new GridColumn({
									"field":model.getField("quant"),
									"ctrlClass":EditInt
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:issue_date_time",{
							"value":"Дата выпуска",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("issue_date_time"),
									"ctrlClass":EditDateTime,
									"ctrlEdit":false
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:expire_date",{
							"value":"Дата окончания",
							"columns":[
								new GridColumnDate({
									"field":model.getField("expire_date")
									,"ctrlClass":EditDate
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:issue_users_ref",{
							"value":"Кто выдал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("issue_users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlEdit":false
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:close_date_time",{
							"value":"Дата гашения",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("close_date_time"),
									"ctrlClass":EditDateTime,
									"ctrlEdit":false
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:close_users_ref",{
							"value":"Кто погасил",
							"columns":[
								new GridColumnRef({
									"field":model.getField("close_users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlEdit":false
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
							"colSpan":"4"
						})											
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumnFloat({"id":"tot_quant"})
						})
						,new GridCell(id+":grid:foot:total_sp2",{
							"colSpan":"4"
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
extend(RawMaterialTicketList_View,ViewAjx);
