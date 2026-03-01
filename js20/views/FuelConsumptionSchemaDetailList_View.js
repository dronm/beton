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
			"exportFileName" :"РасходГСМ",
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.FuelConsumptionSchemaDetailList_Model)? 
			options.detailFilters.FuelConsumptionSchemaDetailList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:fuel_consumption_schema_ref",{
							"value":"Схема",
							"columns":[
								new GridColumnRef({
									"field":model.getField("id"),
									"ctrlClass":FuelConsumptionSchemaEdit,
									"searchOptions":{
										"field":new FieldInt("fuel_consumption_schema_id"),
										"searchType":"on_match"
									}									
								})
								,new GridColumn({
									"field":model.getField("month_from"),
									"ctrlClass":EditMonth,
								})
								,new GridColumn({
									"field":model.getField("month_to"),
									"ctrlClass":EditMonth,
								})
								,new GridColumn({
									"field":model.getField("quant_distance"),
									"ctrlClass":EditNum,
								})
								,new GridColumn({
									"field":model.getField("quant_time"),
									"ctrlClass":EditNum,
								})
							],
							"sortable":true,
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




