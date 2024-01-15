/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientSpecificationList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Договоры";

	ClientSpecificationList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ClientSpecificationList_Model)? options.models.ClientSpecificationList_Model : new ClientSpecificationList_Model();
	var contr = new ClientSpecification_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline": true,
		"editWinClass": null,
		"filters":(options.detailFilters&&options.detailFilters.ClientSpecificationList_Model)? options.detailFilters.ClientSpecificationList_Model:null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						options.detailFilters||options.detail? null : new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Контрагент",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlClass":DestinationEdit,
									"ctrlBindFieldId":"client_id",
									"searchOptions":{
										"field":new FieldInt("client_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
					
						,new GridCellHead(id+":grid:head:specification_date",{
							"value":"Дата",
							"columns":[
								new GridColumnDate({
									"field":model.getField("specification_date")
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:contract",{
							"value":"Договор",
							"columns":[
								new GridColumn({
									"field":model.getField("contract")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:specification",{
							"value":"Спецификация",
							"columns":[
								new GridColumn({
									"field":model.getField("specification")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:concrete_types_ref",{
							"value":"Марка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("concrete_types_ref"),
									"ctrlClass":ConcreteTypeEdit,
									"ctrlOptions":{
										"labelCaption":""
									},
									"ctrlBindFieldId":"concrete_type_id",
									"searchOptions":{
										"field":new FieldInt("concrete_type_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:destinations_ref",{
							"value":"Объект",
							"columns":[
								new GridColumnRef({
									"field":model.getField("destinations_ref"),
									"ctrlClass":DestinationEdit,
									"ctrlOptions":{
										"labelCaption":""
									},
									"ctrlBindFieldId":"destination_id",
									"searchOptions":{
										"field":new FieldInt("destination_id"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})

						,new GridCellHead(id+":grid:head:quant",{
							"value":"Кол-во",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant"),
									"precision":"4",
									"ctrlClass":EditFloat,
									"ctrlOptions":{
										"precision":"4",
										"events":{
											"input":(function(viewCont){
												return function(n){												
													viewCont.calcTotal();
												}
											})(self)
										}
									},
									"searchOptions":{
										"field":new FieldInt("quant"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:quant_balance",{
							"value":"Кол-во, остаток",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_balance"),
									"precision":"4",
									"ctrlClass":EditFloat,
									"ctrlEdit":false,
									"searchOptions":{
										"field":new EditFloat("quant_balance"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:price",{
							"value":"Цена",
							"columns":[
								new GridColumnFloat({
									"precision":"2",
									"field":model.getField("price"),
									"ctrlClass":EditMoney,
									"ctrlOptions":{
										"events":{
											"input":(function(viewCont){
												return function(n){												
													viewCont.calcTotal();
												}
											})(self)
										}
									},
									"searchOptions":{
										"field":new FieldFloat("price"),
										"searchType":"on_match",
										"typeChange":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:total",{
							"value":"Сумма",
							"columns":[
								new GridColumnFloat({
									"precision":"2",
									"field":model.getField("total"),
									"ctrlClass":EditMoney,
									"searchOptions":{
										"field":new FieldFloat("total"),
										"searchType":"on_match",
										"typeChange":false
									}
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
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	


}
extend(ClientSpecificationList_View,ViewAjxList);

ClientSpecificationList_View.prototype.calcTotal = function(){
	var v = this.getElement("grid").getEditViewObj();
	if(!v){
		return;
	}
	v.getElement("total").setValue(v.getElement("price").getValue() * v.getElement("quant").getValue());
}
