/** Copyright (c) 2021
 *	Andrey Mikhalevich, Katren ltd.
 */
function GornyiCarrierMatchList_View(id,options){	

	GornyiCarrierMatchList_View.superclass.constructor.call(this,id,options);

	var model = options.models.GornyiCarrierMatchList_Model;
	var contr = new GornyiCarrierMatch_Controller();
	
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
						new GridCellHead(id+":grid:head:plate",{
							"value":"Гос.номер",
							"columns":[
								new GridColumn({
									"field":model.getField("plate")
								})
							],
							"sortable":true
							,"sort":"asc"
						})
						,new GridCellHead(id+":grid:head:carriers_ref",{
							"value":"Перевозчик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("carriers_ref"),									
									"ctrlClass":SupplierEdit,
									"ctrlOptions":{
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("carrier_id"),
										"searchType":"on_match"
									},									
									"ctrlBindFieldId":"carrier_id"
								})
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
		"refreshInterval":0,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(GornyiCarrierMatchList_View,ViewAjx);
