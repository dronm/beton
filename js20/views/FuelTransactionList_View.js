/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelTransactionList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Транзакции по заправочним картам";

	FuelTransactionList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.FuelTransactionList_Model)? options.models.FuelTransactionList_Model : new FuelTransactionList_Model();
	var contr = new FuelTransaction_Controller();
	
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
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":true,
			"cmdDelete":true,
			"exportFileName" :"ТранзакцииПоТопливнымКартам",
			"addCustomCommandsAfter":function(commands){
				commands.push(new FuelTransactionGridCmdImport(id+":grid:cmd:importData" ));				
			}
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.FuelTransactionList_Model)? options.detailFilters.FuelTransactionList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:id",{
							"value":"Транзакция",
							"columns":[
								new GridColumn({"field":model.getField("id")})
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
						,new GridCellHead(id+":grid:head:card_id",{
							"value":"Карта",
							"columns":[
								new GridColumn({
									"field":model.getField("card_id")
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
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
						,new GridCellHead(id+":grid:head:total",{
							"value":"Сумма",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("total"),
									"precision": 2,
									"length": 15
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
							"colSpan":"4"
						})
						,new GridCellFoot(id+":grid:foot:tot_quant",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_quant",
							"gridColumn":new GridColumn({
								"id":"tot_quant"
							})
						})						
						,new GridCellFoot(id+":grid:foot:tot_total",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_total",
							"gridColumn":new GridColumnFloat({
								"id":"tot_quant",
								"precision": 2
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
extend(FuelTransactionList_View,ViewAjxList);


