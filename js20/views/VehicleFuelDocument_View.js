/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function VehicleFuelDocument_View(id,options){	

	options.HEAD_TITLE = options.detail? undefined : "Документы по ТС";

	VehicleFuelDocument_View.superclass.constructor.call(this,id,options);

	var model = (options && options.models && options.models.VehicleFuelDocument_Model)?
		options.models.VehicleFuelDocument_Model : new VehicleFuelDocument_Model();
	var contr = new Vehicle_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"keyIds":["vehicle_id", "doc_type", "source_id"],
		"controller":contr,
		"readPublicMethod":contr.getPublicMethod("get_fuel_documents"),
		"insertPublicMethod":null,
		"updatePublicMethod":null,
		"editPublicMethod":null,
		"deletePublicMethod":null,
		"editInline":false,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd", {
			"cmdInsert":false,
			"cmdRefresh":true,
			"cmdEdit":false,
			"cmdSearch":false
		} ),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDate({
									"field":model.getField("date_time")
								})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:document",{
							"value":"Документ",
							"columns":[
								new GridColumn({
									"formatFunction":function(f, cell){
										let doc_descr = "";
										const doc_type = f.doc_type.getValue();
										switch (doc_type) {
											case "fuel_transactions":
												doc_descr = `Заправка №${f.transaction_id.getValue()} (${f.card_id.getValue()})`;
												break;
											case "fuel_corrections":
												doc_descr = `Исправление №${f.source_id.getValue()}`;
												break;

											case "fuel_consumptions":
												doc_descr = "Суточный пробег";
												break;

											default:
												break;
										}
										return doc_descr;
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_deb",{
							"value":"Приход, л",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant_deb")
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_kred",{
							"value":"Расход, л",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant_kred")
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
extend(VehicleFuelDocument_View,ViewAjx);




