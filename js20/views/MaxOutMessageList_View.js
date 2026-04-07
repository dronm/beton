/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function MaxOutMessageList_View(id,options){	

	options.HEAD_TITLE = "Исходящие сообщения MAX";

	MaxOutMessageList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.MaxOutMessageList_Model)? options.models.MaxOutMessageList_Model : new MaxOutMessageList_Model();
	var contr = new MaxOutMessage_Controller();
	
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
						new GridCellHead(id+":grid:head:contacts_ref",{
							"value":"Получатель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("contacts_ref")
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
						,new GridCellHead(id+":grid:head:sent_at",{
							"value":"Отправлено",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("sent_at")
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:created_at",{
							"value":"Создано",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("created_at")
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
extend(MaxOutMessageList_View,ViewAjxList);

