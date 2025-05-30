/** Copyright (c) 2025
 *	Andrey Mikhalevich, Katren ltd.
 */
function UserAllowedMaterialCorrectionList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Список пользователей с разрешенным правом редактирования данных по материалам";

	UserAllowedMaterialCorrectionList_View.superclass.constructor.call(this,id,options);

	var model = (options.models && options.models.UserAllowedMaterialCorrectionList_Model)? 
		options.models.UserAllowedMaterialCorrectionList_Model : new UserAllowedMaterialCorrectionList_Model();
	var contr = new UserAllowedMaterialCorrection_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
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
						new GridCellHead(id+":grid:head:users_ref",{
							"value":"Сотрудник",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"ctrlClass":UserEditRef,
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
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(UserAllowedMaterialCorrectionList_View,ViewAjxList);

