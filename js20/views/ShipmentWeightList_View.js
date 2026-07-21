/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function ShipmentWeightList_View(id,options){	

	ShipmentWeightList_View.superclass.constructor.call(this,id,options);

	var model = options.models.ShipmentWeightList_Model;
	var contr = new ShipmentWeight_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"keyIds": ["shipment_id"],
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd", {
			"cmdInsert": false,
			"cmdEdit": false,
			"cmdDelete": false
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:ship_date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("ship_date_time")})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:shipment_id",{
							"value":"Отгрузка",
							"columns":[
								new GridColumn({"field":model.getField("shipment_id")})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Взвешано",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							]
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Объем",
							"columns":[
								new GridColumn({"field":model.getField("quant")})
							]
						})
						,new GridCellHead(id+":grid:head:quant_gross",{
							"value":"Вес общий",
							"columns":[
								new GridColumn({"field":model.getField("quant_gross")})
							]
						})
						,new GridCellHead(id+":grid:head:quant_net",{
							"value":"Вес чистый",
							"columns":[
								new GridColumn({"field":model.getField("quant_net")})
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
extend(ShipmentWeightList_View,ViewAjx);

