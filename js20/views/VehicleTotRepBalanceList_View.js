/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function VehicleTotRepBalanceList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Остатки взаиморасчетов с владельцами ТС";

	VehicleTotRepBalanceList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.VehicleTotRepBalanceList_Model)? options.models.VehicleTotRepBalanceList_Model : new VehicleTotRepBalanceList_Model();
	var contr = new VehicleTotRepBalance_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["id"],
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:vehicle_owners_ref",{
							"value":"Владелец",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicle_owners_ref"),
									"ctrlClass":VehicleOwnerEdit,
									"ctrlBindFieldId":"vehicle_owner_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							]
						})
					
						,new GridCellHead(id+":grid:head:period",{
							"value":"Период",
							"columns":[
								new GridColumnDate({"field":model.getField("period")})
							]							
						})
						,new GridCellHead(id+":grid:head:value",{
							"value":"Сумма",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("value"),
									"precision":"2"
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
extend(VehicleTotRepBalanceList_View, ViewAjxList);

