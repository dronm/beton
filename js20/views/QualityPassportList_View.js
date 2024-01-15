/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function QualityPassportList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Реестр паспартов качества";

	QualityPassportList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.QualityPassportList_Model)? options.models.QualityPassportList_Model : new QualityPassportList_Model();
	var contr = new QualityPassport_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var self = this;
	
	var filters;
	if (!options.detail){
		var period_ctrl = new EditPeriodDate(id+":filter-ctrl-period",{
			"field":new FieldDate("vidan")
		});
	
		filters = {
			"period":{
				"binding":new CommandBinding({
					"control":period_ctrl,
					"field":period_ctrl.getField()
				}),
				"bindings":[
					{"binding":new CommandBinding({
						"control":period_ctrl.getControlFrom(),
						"field":period_ctrl.getField()
						}),
					"sign":"ge"
					},
					{"binding":new CommandBinding({
						"control":period_ctrl.getControlTo(),
						"field":period_ctrl.getField()
						}),
					"sign":"le"
					}
				]
			}		
		}
	}
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":false,
		"editWinClass":WindowFormModalBS,
		"editViewClass":QualityPassport_View,
		"editViewOptions":function(){
			return {
				"dialogWidth":"80%"
			}
		},
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":true,
			"exportFileName" :"РеестрПаспартовКачества",
			"filters":filters
			/*"addCustomCommandsAfter":function(commands){
				commands.push(new GridCmd(id+":grid:cmd:printPass",{
				}));
			}*/
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:num",{
							"value":"Номер",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("num")})
							],
							"sortable":true
						}),
						
						new GridCellHead(id+":grid:head:vidan",{
							"value":"Выдан",
							"columns":[
								new GridColumnDate({"field":model.getField("vidan")})
							],
							"sortable":true,
							"sort":"desc"							
						}),
						,new GridCellHead(id+":grid:head:orders_ref",{
							"value":"Заявка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("orders_ref"),
									"ctrlClass":OrderEdit,
									"ctrlOptions":{
										"lableCaption":""
									},
									"form": OrderDialog_Form,
									"ctrlBindFieldId":"order_id"
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Контрагент",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlClass":ClientEdit,
									"form": ClientDialog_Form,
									"ctrlOptions":{
										"lableCaption":""
									},
									"ctrlBindFieldId":"client_id"
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:shipments_list",{
							"value":"Отгрузки",
							"columns":[
								new GridColumnRef({
									"field":model.getField("shipments_list"),
									"ctrlEdit":false,
									"formatFunction":function(f, gridCell){
										var sh = f.shipments_list.getValue();
										if(!sh || !sh.length){
											return "";
										}
										var ref_list = document.createElement("ul");
										for(var i = 0; i < sh.length; i++){
											if(!sh[i].getDescr || !sh[i].getKey){
												continue;
											}
											var ref_item = document.createElement("li");
											var href = document.createElement("a");
											href.setAttribute("href", "#");
											href.setAttribute("key", sh[i].getKey());
											href.textContent = sh[i].getDescr();
											EventHelper.add(href, "click", function(e){
												if (e.preventDefault){
													e.preventDefault();
												}
												e.stopPropagation();
												var k = this.getAttribute("key");
												self.openShipment(k);
												return false;
											});
											
											ref_item.appendChild(href);											
											ref_list.appendChild(ref_item);
										}
										gridCell.getNode().appendChild(ref_list);
										
										return "";
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
extend(QualityPassportList_View,ViewAjxList);

QualityPassportList_View.prototype.openShipment = function(k){
	//open Shipment form
	(new ShipmentDialog_Form({
		"keys":{"id": k}
	})).open();
	/*
	var sh_v = new ShipmentDialog_View("shModal:view", {"cmd":"edit", "keys": {"id": k}});
	sh_v.read("edit");
	(new WindowFormModalBS("shModal",{
		"dialogWidth":"80%",
		"cmdOk":true,
		"cmdCancel":true,		
		"onClickOk":function(){
			this.close();
		},
		"onClickCancel":function(){
			this.close();
		},
		"cmdClose":true,
		"content":sh_v
	})).open();
	*/
}
