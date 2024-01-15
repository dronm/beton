/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function TmInMessageList_View(id,options){	

	options.HEAD_TITLE = "Входящие сообщения из Telegram";

	TmUserList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.TmInMessageList_Model)? options.models.TmInMessageList_Model : new TmInMessageList_Model();
	var contr = new TmInMessage_Controller();
	
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
			"cmdEdit":false,
			"cmdDelete":false
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:ext_obj",{
							"value":"Отправитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("ext_obj"),
									"formatFunction":function(fields){
										return window.getApp().getTmUserDescr(fields["ext_obj"].getValue());
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:message",{
							"value":"Сообщение",
							"columns":[
								new GridColumnRef({
									"field":model.getField("message"),
									"formatFunction":function(fields){
										var v = fields["message"].getValue();
										return (v && v.text)? v.text : "";
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Получено",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
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
extend(TmInMessageList_View,ViewAjxList);
