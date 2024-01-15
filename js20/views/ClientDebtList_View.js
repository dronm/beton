/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientDebtList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Взаиморасчеты 1с с контрагентами";

	ClientDebtList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ClientDebtList_Model)? options.models.ClientDebtList_Model : new ClientDebtList_Model();
	var contr = new ClientDebt_Controller();
	
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
			"exportFileName" :"Взаиморасчеты1с"
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.ClientDebtList_Model)? options.detailFilters.ClientDebtList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:firms_ref",{
							"value":"Организация",
							"columns":[
								new GridColumnRef({
									"field":model.getField("firms_ref"),
									"ctrlEdit":Firm1cEdit,
									"ctrlBindFieldId":"firm_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Контрагент",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlEdit":ClientEdit,
									"ctrlBindFieldId":"client_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:debt_total",{
							"value":"Сумма",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("debt_total"),
									"ctrlClass":EditMoney,
									"ctrlOptions":{
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:update_date",{
							"value":"Дата обновления",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("update_date"),
									"ctrlClass":EditDateTime,
									"ctrlOptions":{
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
extend(ClientDebtList_View,ViewAjxList);

