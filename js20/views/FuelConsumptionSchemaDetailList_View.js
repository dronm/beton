/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelConsumptionSchemaDetailList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Расхода ГСМ по схеме";

	FuelConsumptionSchemaDetailList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.FuelConsumptionSchemaDetailList_Model)? 
		options.models.FuelConsumptionSchemaDetailList_Model : new FuelConsumptionSchemaDetailList_Model();

	var contr = new FuelConsumptionSchemaDetail_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();

	const isDetail = (options.detailFilters && options.detailFilters.FuelConsumptionSchemaDetailList_Model);
	const monthList = [
			"Январь", "Февраль", "Март", "Апрель", "Май",
			"Июнь", "Июль", "Август", "Сентябрь", "Октябрь",
			 "Ноябрь", "Декабрь"
	];
	
	var filters;
	this.addElement(new GridAjx(id+":grid",{
		"attrs": {"width": "80%"},
		"filters": filters,
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"exportFileName" :"РасходГСМ",
		}),		
		"popUpMenu":popup_menu,
		"filters":isDetail? options.detailFilters.FuelConsumptionSchemaDetailList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						isDetail? null:
						new GridCellHead(id+":grid:head:fuel_consumption_schema_ref",{
							"value":"Схема",
							"columns":[
								new GridColumnRef({
									"field":model.getField("id"),
									"ctrlClass":FuelConsumptionSchemaEdit,
									"ctrlOptions": {
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("fuel_consumption_schema_id"),
										"searchType":"on_match"
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:month_from",{
							"value":"Месяц с",
							"attrs":{"width":"200px"},
							"columns":[
								new GridColumn({
									"field":model.getField("month_from"),
									"formatFunction": function(f){
										const v = f.month_from.getValue();
										if(v && v<12){
											return monthList[v-1];
										}
										return "";
									},
									"ctrlClass":EditMonth
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:month_to",{
							"value":"Месяц по",
							"attrs":{"width":"200px"},
							"columns":[
								new GridColumn({
									"field":model.getField("month_to"),
									"formatFunction": function(f){
										const v = f.month_to.getValue();
										if(v && v<12){
											return monthList[v-1];
										}
										return "";
									},
									"ctrlClass":EditMonth
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_distance",{
							"value":"Расход на 100 км",
							"attrs":{"width":"200px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_distance"),
									"precision": "2",
									"ctrlClass":EditFloat,
									"ctrlOptions": {
										"length":"15",
										"precision": "2"
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_time",{
							"value":"Расход на 1 час",
							"attrs":{"width":"200px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_time"),
									"precision": "2",
									"ctrlClass":EditFloat,
									"ctrlOptions": {
										"length":"15",
										"precision": "2"
									}
								})
							]
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
extend(FuelConsumptionSchemaDetailList_View,ViewAjxList);




