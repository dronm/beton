/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function TmOutMessageList_View(id,options){	

	options.HEAD_TITLE = "Исходящие сообщения Telegram";

	TmUserList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.TmOutMessageList_Model)? options.models.TmOutMessageList_Model : new TmOutMessageList_Model();
	var contr = new TmOutMessage_Controller();
	
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
							"value":"Получатель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("ext_obj"),
									"formatFunction":function(fields){
										return window.getApp().getTmUserDescr(fields["ext_obj"].getValue());
									}
								})
							],
							"sortable":true
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
						,new GridCellHead(id+":grid:head:sent_date_time",{
							"value":"Отправлено",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("sent_date_time")
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
extend(TmOutMessageList_View,ViewAjxList);
