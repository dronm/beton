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
						new GridCellHead(id+":grid:head:contacts_ref",{
							"value":"Отправитель",
							"columns":[
								new GridColumn({
									"field":model.getField("contacts_ref"),
									"formatFunction":function(fields){
										//return window.getApp().getTmUserDescr(fields["ext_obj"].getValue());
										var res = "";
										var ct = fields.contacts_ref.getValue();
										if(ct && ct.getDescr){
											res = ct.getDescr();
										}
										var ent = fields.entity.getValue();
										if(ent && CommonHelper.isArray(ent) && ent.length){
											var res_tp = "";
											for(var i = 0; i < ent.length; i++){
												if(ent[i] && ent[i].getDescr){
													if(res_tp != ""){
														res_tp+=", ";
													}
													var tp = ent[i].getDataType();
													var tp_descr = "";
													if(tp == "users"){
														tp_descr = "сотрудник";
													}else if(tp == "clients"){
														tp_descr = "клиент";
													}else if(tp == "drivers"){
														tp_descr = "водитель";
													}else if(tp == "suppliers"){
														tp_descr = "поставщик";
													}
													res_tp+= tp_descr + " " + ent[i].getDescr();													
												}
											}
											if(res_tp.length){
												if(res.length){
													res+= " (" + res_tp + ")";
												}else{
													res = res_tp;
												}
											}
										}
										return res;
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:message",{
							"value":"Сообщение",
							"columns":[
								new GridColumnRef({
									"field":model.getField("message"),
									"formatFunction":function(fields, cell){
										return window.getApp().tmMessageFormat(fields, cell);
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
	
	window.getApp().addVideoPlayerSupport();
}
extend(TmInMessageList_View,ViewAjxList);




