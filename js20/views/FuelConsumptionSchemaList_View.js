/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelConsumptionSchemaList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Схемы расхода ГСМ";

	FuelConsumptionSchemaList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.FuelConsumptionSchema_Model)? 
		options.models.FuelConsumptionSchema_Model : new FuelConsumptionSchema_Model();

	var contr = new FuelConsumptionSchema_Controller();
	
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
			"exportFileName" :"СхемыРасходаГСМ",
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.FuelConsumptionSchemaList_Model)? 
			options.detailFilters.FuelConsumptionSchemaList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({
									"field":model.getField("name"),
									"master":true,
									"detailViewClass":FuelConsumptionSchemaDetailList_View,
									"detailViewOptions":{
										"detailFilters":{
											"ConcreteCostList_Model":[
												{
												"masterFieldId":"id",
												"field":"fuel_consumption_schema_id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									}
								})
							],
							"sortable":true,
							"sort":"desc"							
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
extend(FuelConsumptionSchemaList_View,ViewAjxList);



