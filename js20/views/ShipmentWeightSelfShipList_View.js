/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function ShipmentWeightSelfShipList_View(id,options){	

	options.HEAD_TITLE = "Бетон самовывоз";
	ShipmentWeightSelfShipList_View.superclass.constructor.call(this,id,options);

	var model = options.models.ShipmentWeightSelfShipList_Model;
	var contr = new ShipmentWeightSelfShip_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	const period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"field":new FieldDateTime("date_time")
	});

	const filters = {
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

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"keyIds": ["shipment_id"],
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd", {
			"cmdInsert": false,
			"cmdEdit": true,
			"cmdDelete": true,
			"cmdFilter":true,
			"filters":filters
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:number",{
							"value":"Номер",
							"columns":[
								new GridColumn({"field":model.getField("number")})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:material",{
							"value":"Бетон",
							"columns":[
								new GridColumn({
									"field":model.getField("material")
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"ctrlEdit": false,
									"ctrlBindFieldId": "vehicle_id",
									"ctrlOptions": {
										"labelCaption": "",
									},
									"ctrlClass":VehicleEdit,
									"searchOptions":{
										"field":new FieldInt("vehicle_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:sender_name",{
							"value":"Получатель",
							"columns":[
								new GridColumn({
									"field":model.getField("sender_name")
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_gross",{
							"colAttrs": {"align": "right"},
							"value":"Тара",
							"columns":[
								new GridColumn({
									"field":model.getField("quant_gross")
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_net",{
							"colAttrs": {"align": "right"},
							"value":"Вес нетто",
							"columns":[
								new GridColumn({"field":model.getField("quant_net")})
							]
						})
						,new GridCellHead(id+":grid:head:comment_text",{
							"value":"Комментарий",
							"columns":[
								new GridColumn({
									"field":model.getField("comment_text")
								})
							]
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
extend(ShipmentWeightSelfShipList_View,ViewAjx);


