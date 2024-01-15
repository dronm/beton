/** Copyright (c) 2021
 *	Andrey Mikhalevich, Katren ltd.
 */
function RoleViewRestrictionList_View(id,options){	

	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEAD_TITLE = "Запрет на просмотр заяок/отгрузок по ролям";

	RoleViewRestrictionList_View.superclass.constructor.call(this,id,options);
	
	var model = options.models.RoleViewRestriction_Model;
	var contr = new RoleViewRestriction_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["role_id"],
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:role_id",{
							"value":"Роль",
							"columns":[
								new EnumGridColumn_role_types({"field":model.getField("role_id")})
							],
							"sortable":true,
							"sort":"asc"							
						}),
						new GridCellHead(id+":grid:head:back_days_allowed",{
							"value":"Дней назад",
							"columns":[
								new GridColumn({"field":model.getField("back_days_allowed")})
							]
						}),											
						new GridCellHead(id+":grid:head:front_days_allowed",{
							"value":"Дней вперед",
							"columns":[
								new GridColumn({
									"field":model.getField("front_days_allowed")
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
extend(RoleViewRestrictionList_View,ViewAjxList);
