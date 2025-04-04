/** Copyright (c) 2025
 *	Andrey Mikhalevich, Katren ltd.
 */
function OperatorForTranspNaklList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Список операторов (официальный)";

	OperatorForTranspNaklList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.OperatorForTranspNaklList_Model)? options.models.OperatorForTranspNaklList_Model : new OperatorForTranspNaklList_Model();
	var contr = new OperatorForTranspNakl_Controller();
	
	var constants = {"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"keyIds":["user_id"],
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
						new GridCellHead(id+":grid:head:users_ref",{
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
						,new GridCellHead(id+":grid:head:production_sites_ref",{
							"value":"Завод",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_sites_ref"),
									"ctrlClass":ProductionSiteEdit,
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
extend(OperatorForTranspNaklList_View,ViewAjxList);


