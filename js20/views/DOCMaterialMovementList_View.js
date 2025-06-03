function DOCMaterialMovementList_View(id,options){	

	options.HEAD_TITLE = "Перемещение материалов.";
	DOCMaterialMovementList_View.superclass.constructor.call(this,id,options);

	const model = (options.models&&options.models.DOCMaterialMovementList_Model)? options.models.DOCMaterialMovementList_Model:new DOCMaterialMovementList_Model();
	const contr = new DOCMaterialMovement_Controller();
	
	const constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
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
		,"material": {
			"binding":new CommandBinding({
				"control":new MaterialSelect(id+":filter-ctrl-material",{
					"contClassName":"form-group-filter"
				}),
				"field":new FieldInt("material_id")}),
			"sign":"e"		
		}
		,"production_base_from": {
			"binding":new CommandBinding({
				"control":new ProductionBaseEdit(id+":filter-ctrl-production_base_from",{
					"contClassName":"form-group-filter"
				}),
				"field":new FieldInt("production_base_from")}),
			"sign":"e"		
		}
		,"production_base_to": {
			"binding":new CommandBinding({
				"control":new ProductionBaseEdit(id+":filter-ctrl-production_base_to",{
					"contClassName":"form-group-filter"
				}),
				"field":new FieldInt("production_base_to")}),
			"sign":"e"		
		}
	};
			
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["id"],
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"cmdFilter":true,
			"filters":filters,
			"variantStorage":options.variantStorage,
			"cmdSearch":true
		}),
		"filters":null,
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time"),
									"dateFormat":"d/m/y H:i"
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:number",{
							"value":"Номер",
							"columns":[
								new GridColumn({
									"field":model.getField("number")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:materials_ref",{
							"value":"Материал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("materials_ref"),
									"ctrlClass":MaterialSelect,
									"ctrlOptions": {
										"labelCaption": "",
										"required": true
									},
									"ctrlBindFieldId":"material_id",
									"searchOptions":{
										"field":new FieldInt("material_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:production_base_from",{
							"value":"Отправитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_bases_from_ref"),
									"ctrlClass":ProductionBaseEdit,
									"ctrlOptions": {
										"labelCaption": "",
										"required": true
									},
									"ctrlBindFieldId":"production_base_from_id",
									"searchOptions":{
										"field":new FieldInt("production_base_from_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:production_base_to",{
							"value":"Получатель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_bases_to_ref"),
									"ctrlClass":ProductionBaseEdit,
									"ctrlOptions": {
										"labelCaption": "",
										"required": true
									},
									"ctrlBindFieldId":"production_base_to_id",
									"searchOptions":{
										"field":new FieldInt("production_base_from_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:carriers_ref",{
							"value":"Перевозчик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("carriers_ref"),
									"ctrlClass":SupplierEdit,
									"ctrlOptions": {
										"labelCaption": ""
									},
									"ctrlBindFieldId":"carrier_id",
									"searchOptions":{
										"field":new FieldInt("carrier_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:vehicle_plate",{
							"value":"Номер ТС",
							"columns":[
								new GridColumn({
									"field":model.getField("vehicle_plate")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Кол-во",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant"),
									"precision":"4"
								})
							]
						})
						,new GridCellHead(id+":grid:head:users_ref",{
							"value":"Кто создал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlEdit": false,
									"searchOptions":{
										"field":new FieldInt("user_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
									
								})
							],
							"sortable":true
						})
					]
				})
			]
		}),
		"foot":new GridFoot(id+":grid:foot",{
			"autoCalc":true,			
			"elements":[
				new GridRow(id+":grid:foot:row0",{
					"elements":[
						new GridCell(id+":grid:foot:sp1",{
							"value":"Итого",
							"colSpan":"7"
						})
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumnFloat({
								"id":"tot_quant",
								"precision":"4"
							})
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
extend(DOCMaterialMovementList_View,ViewAjxList);


