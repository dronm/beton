/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function WorkplaceScheduleList_View(id,options){	

	WorkplaceScheduleList_View.superclass.constructor.call(this,id,options);

	var model = options.models.WorkplaceScheduleList_Model;
	var contr = new WorkplaceSchedule_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd" ),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:for_date",{
							"value":"Дата",
							"columns":[
								new GridColumnDate({"field":model.getField("for_date")})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:workplaces_ref",{
							"value":"Рабочее место",
							"columns":[
								new GridColumnRef({
									"field":model.getField("workplaces_ref"),
									"ctrlClass":WorkplaceEdit,
									"ctrlBindFieldId":"workplace_id",
									"ctrlOptions":{
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("workplace_id"),
										"searchType":"on_match"
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:users_ref",{
							"value":"Пользователь",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlBindFieldId":"user_id",
									"ctrlOptions":{
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("user_id"),
										"searchType":"on_match"
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
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(WorkplaceScheduleList_View,ViewAjx);



