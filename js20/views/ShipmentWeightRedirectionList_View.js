/** Copyright (c) 2026
	Andrey Mikhalevich, Katren ltd.
*/
function ShipmentWeightRedirectionList_View(id,options){	

	options.HEAD_TITLE = "Переадресация";
	ShipmentWeightRedirectionList_View.superclass.constructor.call(this,id,options);

	var model = options.models.ShipmentWeightRedirectionList_Model;
	var contr = new ShipmentWeightRedirection_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	const self = this;

	this.m_allowedRolesSetPayment = ["admin", "owner", "dispatcher"];
	this.m_allowedRolesDelPayment = ["admin", "owner"];
	this.m_roleId = window.getApp().getServVar("role_id");
	
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
			"cmdEdit": this.m_allowedRolesSetPayment.includes(this.m_roleId),
			"cmdDelete": this.m_allowedRolesSetPayment.includes(this.m_roleId),
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"ctrlEdit": false,
									"field":model.getField("date_time")
								})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,new GridCellHead(id+":grid:head:number",{
							"value":"Номер",
							"columns":[
								new GridColumn({
									"ctrlEdit": false,
									"field":model.getField("number")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:material",{
							"value":"Бетон",
							"columns":[
								new GridColumn({
									"field":model.getField("material"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:unloading_warehouse",{
							"value":"Куда переадресовали",
							"columns":[
								new GridColumn({
									"field":model.getField("unloading_warehouse"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:sender_client",{
							"value":"Отправитель",
							"columns":[
								new GridColumn({
									"field":model.getField("sender_client"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"ctrlEdit": false,
									"ctrlBindFieldId": "vehicle_id",
									"ctrlOptions": {
										"labelCaption": "",
									},
									"ctrlClass":VehicleEdit,
									"searchOptions":{
										"field":new FieldInt("vehicle_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:sender_name",{
							"value":"Откуда переадресовали",
							"columns":[
								new GridColumn({
									"field":model.getField("sender_name"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_net",{
							"colAttrs": {"align": "right"},
							"value":"Вес нетто",
							"columns":[
								new GridColumn({
									"field":model.getField("quant_net"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant",{
							"colAttrs": {"align": "right"},
							"value":"Объем, м3",
							"columns":[
								new GridColumn({
									"field":model.getField("quant"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:amount",{
							"colAttrs": {"align": "right"},
							"value":"Деньги, руб",
							"columns":[
								new GridColumn({
									"field":model.getField("amount"),
									"ctrlEdit": false
								})
							]
						})
						,new GridCellHead(id+":grid:head:payment",{
							"value":"Выдача",
							"columns":[
								new GridColumn({
									"id":model.getField("payment"),
									"ctrlEdit":false,
									"formatFunction":function(f, gridCell){
										const cellNode = gridCell.getNode();
										const cont = document.createElement("div");
										const payment = f.payment.getValue();
										if(!payment && self.m_allowedRolesSetPayment.includes(self.m_roleId)){
											const btn = new Button(null, {
												"caption": "Выдать",
												"onClick": function(){
													self.makePayment(f.shipment_id.getValue());
												}
											});
											btn.toDOM(cont);

										}else if (payment.created_at && payment.users_ref){
											const n = document.createElement("span");
											const d = DateHelper.format(DateHelper.strtotime(payment.created_at), "d/m/y H:i");
											const u = payment.users_ref.getDescr();
											n.textContent = `${u} (${d})`; 
											cont.appendChild(n);
											//clear
											if( self.m_allowedRolesDelPayment.includes(self.m_roleId)){
												const btn = new ButtonCtrl(null, {
													"caption": "X",
													"title": "Удалить выдачу",
													"onClick": function(){
														self.removePayment(f.shipment_id.getValue());
													}
												});
												btn.toDOM(cont);
											}
										}

										cellNode.appendChild(cont);

										return "";
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:comment_text",{
							"value":"Комментарий",
							"columns":[
								new GridColumn({
									"field":model.getField("comment_text")
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
extend(ShipmentWeightRedirectionList_View,ViewAjx);

ShipmentWeightRedirectionList_View.prototype.removePayment= function(shipmentId){
	const self = this;
	if(WindowQuestion.show({
		"text": "Удалить выдачу?",
		"no":false,
		"callBackYes": function(){
			self.removePaymentCont(shipmentId);
		}
	}));
}

ShipmentWeightRedirectionList_View.prototype.removePaymentCont = function(shipmentId){
	const pm = (new ShipmentWeightRedirectionPayment_Controller()).getPublicMethod("delete");
	pm.setFieldValue("shipment_id", shipmentId);
	const self = this;
	pm.run({
		"ok": function(){
			self.getElement("grid").onRefresh();
		}
	});
}

ShipmentWeightRedirectionList_View.prototype.makePayment= function(shipmentId){
	const self = this;
	if(WindowQuestion.show({
		"text": "Оформить выдачу?",
		"no":false,
		"callBackYes": function(){
			self.makePaymentCont(shipmentId);
		}
	}));
}

ShipmentWeightRedirectionList_View.prototype.makePaymentCont = function(shipmentId){
	const pm = (new ShipmentWeightRedirectionPayment_Controller()).getPublicMethod("insert");
	pm.setFieldValue("shipment_id", shipmentId);
	pm.setFieldValue("user_id", window.getApp().getServVar("user_id"));
	const self = this;
	pm.run({
		"ok": function(){
			self.getElement("grid").onRefresh();
		}
	});
}



