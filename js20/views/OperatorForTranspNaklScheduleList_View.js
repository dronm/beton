/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function OperatorForTranspNaklScheduleList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "График работы операторов (официальный)";

	OperatorForTranspNaklScheduleList_View.superclass.constructor.call(this,id,options);
	
	const model = (options.models && options.models.OperatorForTranspNaklScheduleList_Model)? options.models.OperatorForTranspNaklScheduleList_Model : new OperatorForTranspNaklScheduleList_Model();
	const contr = new OperatorForTranspNaklSchedule_Controller();
	
	const constants = {"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	const popup_menu = new PopUpMenu();
	const pagClass = window.getApp().getPaginationClass();

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
						new GridCellHead(id+":grid:head:for_date",{
							"value":"Дата",
							"columns":[
								new GridColumnDate({
									"field":model.getField("for_date")
								})
							]
						})
						,new GridCellHead(id+":grid:head:users_ref",{
							"value":"Сотрудник",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlBindFieldId": "user_id",
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
									"ctrlBindFieldId": "production_site_id",
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
extend(OperatorForTranspNaklScheduleList_View,ViewAjxList);



