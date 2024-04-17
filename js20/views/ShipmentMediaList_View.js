/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ShipmentMediaList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Медиа файлы водителей";

	ShipmentMediaList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ShipmentMediaList_Model)? options.models.ShipmentMediaList_Model : new ShipmentMediaList_Model();
	var contr = new ShipmentMedia_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	if (!options.detail){
		var period_ctrl = new EditPeriodDate(id+":filter-ctrl-period",{
			"field":new FieldDateTime("date_time")
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
	var grid = new GridAjx(id+":grid",{
		"filters": filters,
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"editViewClass":null,
		"editViewOptions":null,
		"commands":options.detail? null : new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"cmdDelete":false,
			"exportFileName" :"Медиа файлы водителей"
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.ShipmentMediaList_Model)? options.detailFilters.ShipmentMediaList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:drivers_ref",{
							"value":"Водитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("drivers_ref"),
									"form":DriverDialog_Form,
									"ctrlClass":DriverEditRef,
									"ctrlOptions":{
										"lableCaption":""
									},
									"ctrlBindFieldId":"driver_id"
								})
							]
						})
						,options.detail? null : new GridCellHead(id+":grid:head:orders_ref",{
							"value":"Заявка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("orders_ref"),
									"form":OrderDialog_Form,
									"ctrlClass":OrderEdit,
									"ctrlOptions":{
										"lableCaption":""
									},
									"ctrlBindFieldId":"order_id"
								})
							]
						})
						,options.detail? null : new GridCellHead(id+":grid:head:shipments_ref",{
							"value":"Отгрузка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("shipments_ref"),
									"form":ShipmentDialog_Form,
									"ctrlClass":ShipmentEdit,
									"ctrlOptions":{
										"lableCaption":""
									},
									"ctrlBindFieldId":"shipment_id"
								})
							]
						})
						,new GridCellHead(id+":grid:head:message",{
							"value":"Сообщение",
							"columns":[
								new GridColumn({
									"field":model.getField("message"),
									"formatFunction":function(fields, cell){
										return window.getApp().tmMessageFormat(fields, cell);
									}
								})
							]
						})
						
					]
				})
			]
		}),
		"pagination":options.detail? null : new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	});
	this.addElement(grid);
	
	if(options.detail){
		var self = this;
		grid.onGetData_orig = grid.onGetData;
		grid.onGetData = function(resp){
			if(resp && resp.getModel("ShipmentMediaList_Model").getRowCount()>0){
				DOMHelper.show("ShipmentDialog:media_cont");
				this.onGetData_orig.call(this, resp);
			}			
		}
	}
}
extend(ShipmentMediaList_View,ViewAjxList);

