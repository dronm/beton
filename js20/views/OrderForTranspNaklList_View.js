/** Copyright (c) 2025
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderForTranspNaklList_View(id,options){	

	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEAD_TITLE = "Журнал заявок";

	options.addElement = function(){
		const self = this;
		
		var model = new OrderForTranspNaklList_Model();
		var contr = new Order_Controller();

		var popup_menu = new PopUpMenu();

		const init_dt = new Date();
		var per_select = new EditPeriodShift(id+":order_make_filter",{
			"template":window.getApp().getTemplate( ((window.getWidthType()=="sm")? "EditPeriodShiftSM":"EditPeriodShift") ),
			"dateFrom":init_dt,
			"onChange":function(dateTime){
				self.setGridFilter(dateTime, dateTime);
				window.setGlobalWait(true);
				self.getElement("grid").onRefresh(function(){
					window.setGlobalWait(false);
				}, true);
			}
		});
		this.addElement(per_select);	

		this.addElement(new GridAjx(id+":grid",{
			//"className":"table-bordered table-responsive",//table-make_order order_make_grid
			"model":model,
			"controller":contr,
			"keyIds":["id"],
			"readPublicMethod":contr.getPublicMethod("get_transp_nakl_list"),
			"editInline":false,
			"editWinClass":null,
			"commands":new GridCmdContainerAjx(id+":grid:cmd",{
				"cmdInsert":false
				,"cmdEdit":false
				,"cmdDelete":false
				,"cmdFilter":false
				,"cmdPrint":false
				,"cmdExport":false
				,"filters":null
				,"cmdAllCommands": false
				,"cmdSearch": true
				,"addCustomCommandsAfter":function(commands){
					commands.push(new OrderGridCmdPrintTranspNakl(id+":grid:cmd:printTranspNakl", {"grid": self.getElement("grid")}));
				}
			}),
			
			"popUpMenu":popup_menu,
			"head":new GridHead(id+"-grid:head",{
				"elements":[
					new GridRow(id+":grid:head:row0",{
						"elements":[
							new GridCellHeadMark(id+":grid:head:mark")
							,new GridCellHead(id+":grid:head:ship_date",{
								"value":"Дата",
								"colAttrs":{"align":"center"},
								"columns":[
									new GridColumnDate({
										"field":model.getField("date_time"),
										"dateFormat":"d/m/y H:i",
										"ctrlClass":EditDateTime,
										"searchOptions":{
											"field":new FieldDate("date_time")
											,"searchType":"on_part",
										},
										"master":true,
										"detailViewClass":ShipmentForTranspNaklList_View,
										"detailViewOptions":{
											"detailFilters":{
												"ShipmentForTranspNaklList_Model":[
													{
													"masterFieldId":"id",
													"field":"order_id",
													"sign":"e",
													"val":"0"
													}	
												]
											}													
										}
																												
									})
								],
								"sortable":true
							})
							,new GridCellHead(id+":grid:head:order_num",{
								"value":"Заявка",
								"colAttrs":{"align":"center"},
								"columns":[
									new GridColumn({
										"field":model.getField("order_num"),
									})
								]
							})
							,new GridCellHead(id+":grid:head:quant",{
								"value":"Количество",
								"colAttrs":{"align":"center"},
								"columns":[
									new GridColumn({
										"field":model.getField("quant")
									})
								]
							})						
							,new GridCellHead(id+":grid:head:clients_ref",{
								"value":"Контрагент",
								"columns":[
									new GridColumnRef({
										"field":model.getField("clients_ref"),
										"ctrlClass":ClientEdit,
										"form":ClientDialog_Form
									})
								],
								"sortable":true,
								"sort": "asc"
							})
							,new GridCellHead(id+":grid:head:client_ref_1c_exists",{
								"value":"1c",
								"colAttrs":{"align":"center"},
								"columns":[
									new GridColumnBool({
										"field":model.getField("client_ref_1c_exists")
									})
								]
							})
							,new GridCellHead(id+":grid:head:destinations_ref",{
								"value":"Объект",
								"columns":[
									new GridColumnRef({
										"field":model.getField("destinations_ref"),
										"ctrlClass":DestinationForClientEdit
									})
								],
								"sortable":true
							})
							,new GridCellHead(id+":grid:head:concrete_types_ref",{
								"value":"Марка",
								"colAttrs":{"align":"center"},
								"columns":[
									new GridColumnRef({
										"field":model.getField("concrete_types_ref"),
										"ctrlClass":ConcreteTypeEdit
									})
								]
							})
						]
					})
				]
			}),
			"pagination": null,
			"autoRefresh":true,
			"selectedRowClass":"order_current_row",
			"refreshInterval": null,
			"rowSelect":false,
			"focus":true
		}));
		this.setGridFilter(per_select.getDateFrom(),per_select.getDateTo());		
	}

	OrderForTranspNaklList_View.superclass.constructor.call(this,id,options);
}
extend(OrderForTranspNaklList_View, ViewAjxList);

OrderForTranspNaklList_View.prototype.setGridFilter = function(dFrom,dTo){
	dFrom = DateHelper.getStartOfShift(dFrom);	
	dTo = DateHelper.getEndOfShift(dTo);
	var gr = this.getElement("grid");
	gr.setFilter({
		"field":"date_time"
		,"sign":"ge"
		,"val":DateHelper.format(dFrom,"Y-m-d H:i:s")
	});
	gr.setFilter({
		"field":"date_time"
		,"sign":"le"
		,"val":DateHelper.format(dTo,"Y-m-d H:i:s")
	});
}


