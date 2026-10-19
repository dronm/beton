/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function UnloadSpeedSchemaList_View(id,options){	

	options.HEAD_TITLE = "Схемы скорости разгрузки";
	
	UnloadSpeedSchemaList_View.superclass.constructor.call(this,id,options);

	var model = (options && options.models && options.models.UnloadSpeedSchema_Model)?
		options.models.UnloadSpeedSchema_Model
		: new UnloadSpeedSchema_Model();
	var contr = new UnloadSpeedSchema_Controller();
	
	//var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	//window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	var self = this;
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
						new GridCellHead(id+":grid:head:quant",{
							"value":"Количество",
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
						})
						,new GridCellHead(id+":grid:head:speed",{
							"value":"Скорость",
							"columns":[
								new GridColumn({
									"field":model.getField("speed")
								})
							]
						})
					]
				})
			]
		}),
		//"pagination":new pagClass(id+"_page",
		//		{"countPerPage":constants.doc_per_page_count.getValue()}),		
		"autoRefresh":options.autoRefresh,
		//j"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(UnloadSpeedSchemaList_View,ViewAjxList);

