/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function DestinationProdBaseDriverPriceList_View(id,options){	

	options = options || {};
	
//	options.HEAD_TITLE = "Контакты";
	DestinationProdBaseDriverPriceList_View.superclass.constructor.call(this,id,options);

	var model = (options.models && options.models.DestinationProdBaseDriverPriceList_Model)? options.models.DestinationProdBaseDriverPriceList_Model : new DestinationProdBaseDriverPriceList_Model();
	var contr = new DestinationProdBaseDriverPrice_Controller();
	
	var pagClass = window.getApp().getPaginationClass();
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var filters;	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters":filters,
			"variantStorage":!options.detail? options.variantStorage : null,
			"cmdSearch":!options.detail
		}),
		"popUpMenu":new PopUpMenu(),
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:production_bases_ref",{
							"value":"База",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_bases_ref"),
									"ctrlClass":ProductionBaseEdit,
									"ctrlBindFieldId":"production_base_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							]
						})						
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
								})
							]
						})												
						,new GridCellHead(id+":grid:head:price",{
							"value":"Цена",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("price"),
									"precision":"2",
									"ctrlClass":EditMoney
								})
							]
						})						
						
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",{"countPerPage":constants.doc_per_page_count.getValue()}),				
		"autoRefresh":false,
		"refreshInterval":!options.detail? (constants.grid_refresh_interval.getValue()*1000) : 0,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(DestinationProdBaseDriverPriceList_View,ViewAjxList);

