/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelCorrectionList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал корректировок остатков топлива";

	FuelCorrectionList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.FuelCorrectionList_Model)? options.models.FuelCorrectionList_Model : new FuelCorrectionList_Model();
	var contr = new FuelCorrection_Controller();
	
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
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"exportFileName" :"Журнал_корректировок_остатков_топлива",
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.FuelCorrectionList_Model)? options.detailFilters.FuelCorrectionList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"colAttrs": {"align": "center"},
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
							"value":"Кол-во требуется",
							"colAttrs": {"align": "right"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_correction",{
							"value":"Кол-во корректировка",
							"colAttrs": {"align": "right"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant_correction"),
									"ctrlEdit": false
								})
							]
						})
					]
				})
			]
		}),
		"foot":null,
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
}
extend(FuelCorrectionList_View,ViewAjxList);



