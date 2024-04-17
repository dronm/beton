/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ConcreteAdditiveTypeList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Виды добавок для паспорта";

	ConcreteAdditiveTypeList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models. ConcreteAdditiveType_Model)? options.models. ConcreteAdditiveType_Model : new ConcreteAdditiveType_Model();
	var contr = new ConcreteAdditiveType_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
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
						new GridCellHead(id+":grid:head:code",{
							"value":"Код",
							"title":"Используется для сортировки",
							"columns":[
								new GridColumn({
									"field":model.getField("code"),
									"ctrlClass":EditNum,
									"ctrlOptions":{
										"title":"Используется для сортировки",
									}
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({"field":model.getField("name")})
							],
							"sortable":true
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
extend(ConcreteAdditiveTypeList_View,ViewAjxList);
