/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function VehicleMileageList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Пробег транспортного средства";

	VehicleMileageList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.VehicleMileageList_Model)? options.models.VehicleMileageList_Model : new VehicleMileageList_Model();
	var contr = new VehicleMileage_Controller();
	
	var constants = {"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdSearch": false,
			"cmdAllCommands": false
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:for_date",{
							"value":"Пробег на дату",
							"columns":[
								new GridColumnDateTime(
									{"field":model.getField("for_date")
								})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:mileage",{
							"value":"Пробег",
							"columns":[
								new GridColumn({
									"field":model.getField("mileage")
								})
							]
						})
						,new GridCellHead(id+":grid:head:users_ref",{
							"value":"Сотрудник",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlEdit": false,
									"ctrlOptions":{
										"labelCaption":""
									}
									
								})
							]
						})
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage": 10}),		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	


}
extend(VehicleMileageList_View,ViewAjxList);

