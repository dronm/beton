/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function Firm1cList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Организации 1с";

	Firm1cList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.Firm1cList_Model)? options.models.Firm1cList_Model : new Firm1cList_Model();
	var contr = new Firm1c_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	this.addElement(new GridAjx(id+":grid",{
		"filters": filters,
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"exportFileName" :"Организации 1с"
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.Firm1cList_Model)? options.detailFilters.Firm1cList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:descr",{
							"value":"Наименование",
							"columns":[
								new GridColumn({"field":model.getField("descr")})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:inn",{
							"value":"ИНН",
							"columns":[
								new GridColumn({
									"field":model.getField("inn"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":"12"
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
		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
}
extend(Firm1cList_View,ViewAjxList);

