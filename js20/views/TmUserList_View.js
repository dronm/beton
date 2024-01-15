/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function TmUserList_View(id,options){	

	options.HEAD_TITLE = "Соответствие пользователей в Telegram";

	TmUserList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.TmUserList_Model)? options.models.TmUserList_Model : new TmUserList_Model();
	var contr = new TmUser_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":true,
			"cmdDelete":true
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:id",{
							"value":"ИД",
							"columns":[
								new GridColumn({
									"field":model.getField("id"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:tm_id",{
							"value":"ИД телеграм",
							"columns":[
								new GridColumn({
									"field":model.getField("tm_id"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:tm_first_name",{
							"value":"Имя в телеграм",
							"columns":[
								new GridColumn({
									"field":model.getField("tm_first_name"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:ext_obj",{
							"value":"Объект",
							"columns":[
								new GridColumnRef({
									"field":model.getField("ext_obj"),
									"ctrlBindFieldId":"ext_obj",
									"ctrlClass":ClientTelEdit,
									"ctrlOptions":{
										"labelCaption":""
									},
									"formatFunction":function(fields){
										return window.getApp().getTmUserDescr(fields["ext_obj"].getValue());
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата создания",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
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
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(TmUserList_View,ViewAjxList);
