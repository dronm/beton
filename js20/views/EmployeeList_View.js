/** Copyright (c) 2019
	Andrey Mikhalevich, Katren ltd.
*/
function EmployeeList_View(id,options){	

	EmployeeList_View.superclass.constructor.call(this,id,options);

	var model = options.models.EmployeeList_Model;
	var contr = new Employee_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	let filters = {
		"deleted":{
			"binding":new CommandBinding({
				"control":new EditSwitcher(id+":filter-ctrl-employed",{
					"labelCaption":"Не показывать удаленные:",
					"contClassName":"form-group-filter",
					"checked":false
				}),
				"field":new FieldBool("employed")}),
			"sign":"ne",
			"falseValueNoFilter":true
		}
	};

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"onEventSetRowOptions":function(rowOpts){
			if(this.getModel().getFieldValue("employed")){
				rowOpts.attrs = rowOpts.attrs || {};
				rowOpts.attrs["class"] = rowOpts.attrs["class"] || "";
				rowOpts.attrs["class"]+= rowOpts.attrs["class"]==""? "":" ";
				rowOpts.attrs["class"]+= "deleted_row";
				rowOpts.attrs.title = "Элемент удален";
			}
		},
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters":filters,
			"addCustomCommandsAfter":function(commands){
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"getNotifRef":function(model){
						var users_ref = model.getFieldValue("users_ref");
						if(users_ref.isNull()){
							throw new Error("Не задан пользователь!");
						}
					
						return users_ref;
						/*new RefType({
							"keys": {"id": id},
							"descr":model.getFieldValue("name"),
							"dataType":"users"
						})*/
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
								new GridColumn({"field":model.getField("name")})
							],
							"sortable":true,
							"sort":"asc"							
						}),
						new GridCellHead(id+":grid:head:employed",{
							"value":"Работает",
							"columns":[
							new GridColumnBool({
									"field":model.getField("employed"),
									"showFalse":false
									// "ctrlClass":EditSwitcher
								})
							]
						}),
						new GridCellHead(id+":grid:head:users_ref",{
							"value":"Пользователь",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
									"ctrlOptions":{
										"labelCaption":""
									},
									"ctrlBindFieldId":"user_id"
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
extend(EmployeeList_View,ViewAjx);
