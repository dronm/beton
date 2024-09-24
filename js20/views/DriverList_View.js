/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function DriverList_View(id,options){	

	DriverList_View.superclass.constructor.call(this,id,options);

	var model = options.models.DriverList_Model;
	var contr = new Driver_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":DriverDialog_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"addCustomCommandsAfter":function(commands){
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"entityType": "drivers",
					"getEntityId": function(){
						return model.getFieldValue("id");
					}
				}));
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
								new GridColumn({
									"field":model.getField("name")
								})
							],
							"sortable":true,
							"sort":"asc"						
						})
						,new GridCellHead(id+":grid:head:contact_ids",{
							"value":"Контакты",
							"columns":[
								new GridColumn({
									"field":model.getField("contact_ids"),
									"formatFunction": function(f,cell){
										window.getApp().formatContactList(f,cell);
										return "";
									},
									"ctrlClass":ContactEdit,
									"searchOptions":{
										"searchType":"on_match",
										"typeChange":false,
										"condSign":"any"
									}
								})
							]
						})						
												
						,new GridCellHead(id+":grid:head:driver_licence",{
							"value":"ВУ",
							"columns":[
								new GridColumn({
									"field":model.getField("driver_licence")
								})
							]
						})						
						,new GridCellHead(id+":grid:head:driver_licence_class",{
							"value":"Класс ВУ",
							"columns":[
								new GridColumn({
									"field":model.getField("driver_licence_class"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":10
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
extend(DriverList_View,ViewAjx);
