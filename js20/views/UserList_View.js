/** Copyright (c) 2017
	Andrey Mikhalevich, Katren ltd.
*/
function UserList_View(id,options){	

	UserList_View.superclass.constructor.call(this,id,options);
	
	var model = options.models.UserList_Model;
	var contr = new User_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":User_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"addCustomCommandsAfter":function(commands){
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"entityType": "users",
					"getEntityId": function(){
						return model.getFieldValue("id");
					}
				}));
				/*
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"getNotifRef":function(model, callBack){						
						var tel = model.getFieldValue("phone_cel");
						if(tel && tel.length){
							window.getApp().setContactRefOnTel(tel, callBack);
						}
					}
				}));
				*/
			}		
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"ФИО",
							"columns":[
								new GridColumn({"field":model.getField("name")})
							],
							"sortable":true,
							"sort":"asc"							
						}),
						,new GridCellHead(id+":grid:head:contact_list",{
							"value":"Контакты",
							"columns":[
								new GridColumn({
									"formatFunction": function(f,cell){
										window.getApp().formatContactList(f,cell);
										return "";
									}
								})
							]
						})						
						
						,new GridCellHead(id+":grid:head:role_id",{
							"value":"Роль",
							"columns":[
								new EnumGridColumn_role_types({
									"field":model.getField("role_id"),
									"ctrlClass":Enum_role_types,
									"searchOptions":{
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						/*,new GridCellHead(id+":grid:head:tel_ext",{
							"value":"Внутр.номер",
							"columns":[
								new GridColumn({
									"field":model.getField("tel_ext")
								})
							]
						})*/
						,new GridCellHead(id+":grid:head:banned",{
							"value":"Доступ закрыт",
							"columns":[
								new GridColumn({
									"field":model.getField("banned"),
									"assocClassList":{"true":"glyphicon glyphicon-ok"}
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
extend(UserList_View,ViewAjxList);
