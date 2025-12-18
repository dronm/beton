/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientSpecificationList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Договоры";

	var model = (options.models && options.models.ClientSpecificationList_Model)? options.models.ClientSpecificationList_Model : new ClientSpecificationList_Model();
	var contr = new ClientSpecification_Controller();

	this.m_getRef1c = options.getRef1c;

	let filters = undefined;
	let fromOrder = false;

	let clientId = getClientIdFromURL();
	if(clientId){
		const filter = {
			field: "client_id",
			sign: "e",
			val: clientId
		}
		filters = [ filter ];
		fromOrder = true;
	}

	if(options.detailFilters&&options.detailFilters.ClientSpecificationList_Model){
		filters = options.detailFilters.ClientSpecificationList_Model;
	} 

	ClientSpecificationList_View.superclass.constructor.call(this,id,options);
	
	
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
		"filters":filters,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"editViewClass": ClientSpecificationListEdit_View,
		"editViewOptions": {
			"clientId": clientId,
			"getRef1c": this.m_getRef1c
		},
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						fromOrder||options.detailFilters||options.detail? null : new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Контрагент",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlClass":ClientEdit,
									"ctrlBindFieldId":"client_id",
									"ctrlOptions": {
										"labelCaption": ""
									},
									"searchOptions":{
										"field":new FieldInt("client_id"),
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
									"ctrlOptions": {
										"labelCaption": ""
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
					
						,new GridCellHead(id+":grid:head:client_contracts_1c_ref",{
							"value":"Договор 1с",
							"columns":[
								new GridColumnRef({
									"field":model.getField("client_contracts_1c_ref"),
									"ctrlBindFieldId":"client_contract_1c_ref",
									"ctrlClass":ClientContract1cEdit,
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							]
						})
						// ,new GridCellHead(id+":grid:head:specification_date",{
						// 	"value":"Дата",
						// 	"columns":[
						// 		new GridColumnDate({
						// 			"field":model.getField("specification_date")
						// 		})
						// 	],
						// 	"sortable":true,
						// 	"sort":"desc"
						// })
						// ,new GridCellHead(id+":grid:head:contract",{
						// 	"value":"Договор",
						// 	"columns":[
						// 		new GridColumn({
						// 			"field":model.getField("contract")
						// 		})
						// 	],
						// 	"sortable":true
						// })
						// ,new GridCellHead(id+":grid:head:specification",{
						// 	"value":"Спецификация",
						// 	"columns":[
						// 		new GridColumn({
						// 			"field":model.getField("specification")
						// 		})
						// 	],
						// 	"sortable":true
						// })
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

//***********************
function ClientSpecificationListEdit_View(id,options){	
	this.m_clientId = options.clientId;
	this.m_getRef1c = options.getRef1c;

	ClientSpecificationListEdit_View.superclass.constructor.call(this,id,options);
}
extend(ClientSpecificationListEdit_View, ViewGridEditInlineAjx);

ClientSpecificationListEdit_View.prototype.setClientRef1c = function(clientRef1c){
	if(!clientRef1c){
		throw new Error("Нет ссылки 1с");
	}
	this.getElement("client_contracts_1c_ref").setClientRef1c(clientRef1c);
}

ClientSpecificationListEdit_View.prototype.onGetData = function(resp, cmd){
	ClientSpecificationListEdit_View.superclass.onGetData.call(this, resp, cmd);

	debugger
	let clientRef1c = undefined;
	if(this.m_getRef1c){
		clientRef1c = this.m_getRef1c();
		clientRef1c = clientRef1c.keys?.ref_1c || clientRef1c.m_keys?.ref_1c;
		this.setClientRef1c(clientRef1c);

	} else if(resp){
		const model = resp.getModel("ClientSpecificationList_Model");
		model.getRow(0);
		clientRef1c = model.getFieldValue("client_ref_1c");
		this.setClientRef1c(clientRef1c);

	}else {
		const clientId = getClientIdFromURL();
		if(clientId){
			const pm = (new Client_Controller()).getPublicMethod("get_object");
			pm.setFieldValue("id", clientId);
			const self = this;
			pm.run({
				async: false,
				ok: function(resp){
					const m = resp.getModel("ClientDialog_Model");
					m.getRow(0);
					clientRef1c = m.getFieldValue("ref_1c");
					if(typeof clientRef1c === "string"){
						clientRef1c = JSON.parse(clientRef1c);
					}
					clientRef1c = clientRef1c.keys?.ref_1c;
					self.setClientRef1c(clientRef1c);
				}
			});
		}
	}
}

function getClientIdFromURL(){
	let clientId = undefined;
	const params = new URLSearchParams(window.location.search);
	const fields = params.get("cond_fields");
	if(fields?.length){
		const fieldSep = params.get("field_set");
		const clientIdInd = fields.split(fieldSep).indexOf("client_id");
		if(clientIdInd >= 0){
			const condVals = params.get("cond_vals");
			const valsAr = condVals?.split(fieldSep);
			if(valsAr.length > clientIdInd){
				clientId = valsAr[clientIdInd];
			}
		}
	}
	return clientId;
}
