/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function RAFuelFlowList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Движение ГСМ";

	RAFuelFlowList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.RAFuelFlowList_Model)? options.models.RAFuelFlowList_Model : new FuelFlowList_Model();
	var contr = new RAFuelFlow_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	this.addElement(new GridAjx(id+":grid",{
		"filters": filters,
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"readOnly": true,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"cmdDelete":false,
			"exportFileName" :"ДвижениеГСМПоТС"
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.RAFuelFlowList_Model)? 
			options.detailFilters.RAFuelFlowList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicle_id")
									"ctrlClass":VehicleEdit,
									"ctrlOptions": {
										"labelCaption": ""
									},
									"ctrlBindFieldId":"vehicle_id",
									"searchOptions":{
										"field":new FieldInt("vehicle_id"),
										"searchType":"on_match"
									}									
								})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:docs_ref",{
							"value":"Документ",
							"columns":[
								new GridColumnRef({
									"field":model.getField("docs_ref"),
									"ctrlOptions": {
										"labelCaption": ""
									},
									"ctrlBindFieldId":"doc_id"
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Кол-во",
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
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
							"colSpan":"2"
						})
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumn({
								"id":"tot_quant"
							})
						})						
					]
				})		
			]
		}),		
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
}
extend(FuelFlowList_View,ViewAjxList);



