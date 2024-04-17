/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function ShipmentForOrderList_View(id,options){	

	ShipmentForOrderList_View.superclass.constructor.call(this,id,options);

	this.m_makeGridListView = options.listView;

	var model = (options.models&&options.models.ShipmentForOrderList_Model)? options.models.ShipmentForOrderList_Model: new ShipmentForOrderList_Model();
	var contr = new Shipment_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var role = window.getApp().getServVar("role_id");	
	var is_client = (role=="client" || role=="weighing");
	
	var popup_menu = new PopUpMenu();
	
	var pagClass = window.getApp().getPaginationClass();
	var grid = new GridAjx(id+":grid",{
		"className":"table-bordered table-responsive table-make_order",
		"model":model,
		"controller":contr,
		"readPublicMethod":contr.getPublicMethod("get_list_for_order"),
		"editInline":!is_client,
		"editWinClass":null,
		"commands":is_client? null:new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdSearch":false,
			"cmdFilter":false,
			"cmdAllCommands":false,
			"cmdDelete":false,
			"addCustomCommandsAfter":function(commands){
				commands.push(new ShipmentGridCmdPrintInvoice(id+":grid:cmd:printInvoice"));
				commands.push(new ShipmentGridCmdPrintPass(id+":grid:cmd:printPass", {"grid": grid}));
				//commands.push(new ShipmentGridCmdPrintPassShip(id+":grid:cmd:printPassShip"));
				//commands.push(new ShipmentGridCmdPrintPassAll(id+":grid:cmd:printPassAll"));								
				//commands.push(new ShipmentGridCmdPrintTTN(id+":grid:cmd:printTTN"));				
				//commands.push(new ShipmentGridCmdPrintPutevoiList(id+":grid:cmd:printPutevoiList"));								
				commands.push(new ShipmentGridCmdChangeOrder(id+":grid:cmd:Change"));
				commands.push(new ShipmentGridCmdDelete(id+":grid:cmd:delete"));
			}
		}),
		"onEventSetRowOptions":function(opts){
			opts.className = opts.className||"";
			var m = this.getModel();
			if(m.getFieldValue("shipped")){
				opts.className+=(opts.className.length? " ":"")+"shipped";
			}
		},
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.ShipmentForOrderList_Model)? options.detailFilters.ShipmentForOrderList_Model:null,
		"head":new GridHead(id+":grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:id",{
							"value":"№",
							"className":window.getBsCol(1),
							"columns":[
								new GridColumn({
									"field":model.getField("id"),
									"ctrlClass":Edit,
									"ctrlOptions":{
										"enabled":false,
										"className":window.getBsCol(1)
									}
								})
							]
						})
						,is_client? null:new GridCellHead(id+":grid:head:production_sites_ref",{
							"value":"Завод",
							"className":window.getBsCol(2),
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_sites_ref"),
									"ctrlClass":ProductionSiteEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"required":true
									},
									"ctrlBindFieldId":"production_site_id"									
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Назн.",
							"className":window.getBsCol(1),
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time"),
									"dateFormat":"H:i",
									"ctrlClass":EditTime,
									"ctrlOptions":{
										"cmdClear":false,
										"enabled":(role=="owner")
									}									
								})
							]
						})
					
						,new GridCellHead(id+":grid:head:ship_date_time",{
							"value":"Отгр.",
							"className":window.getBsCol(1),
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnDateTime({									
									"field":model.getField("ship_date_time"),
									"dateFormat":"H:i",
									"ctrlClass":EditTime,
									"ctrlOptions":{
										"cmdClear":false,
										"enabled":(role=="owner")
									}									
								})
							]
						})
						,is_client? null:new GridCellHead(id+":grid:head:vs_state",{
							"value":"Статус",
							"className":window.getBsCol(2),
							"columns":[
								new EnumGridColumn_vehicle_states({
									"field":model.getField("vs_state"),
									"ctrlClass":Enum_vehicle_states,
									"ctrlOptions":{
										"enabled":false,
										"className":window.getBsCol(1)
									}
									
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicle_schedules_ref",{
							"value":"Экипаж",
							"className":window.getBsCol(3),
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicle_schedules_ref"),
									"ctrlClass":VehicleScheduleEdit,
									"ctrlBindFieldId":"vehicle_schedule_id",
									"ctrlOptions":{
										"labelCaption":"",
										"cmdClear":false,
										"cmdOpen":false,
										"required":true
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Количество",
							"className":window.getBsCol(2),
							"colAttrs":{"align":"right", "nowrap":"nowrap"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant"),
									"ctrlClass":EditFloat,
									"ctrlOptions":{
										"notZero":true
									}									
								})
							]
						})
					]
				})
			]
		}),
		"foot":new GridFoot(id+":grid:foot",{
			"autoCalc":true,			
			"elements":[
				new GridRow(id+":grid:foot:row0",{
					"elements":[
						new GridCell(id+":grid:foot:sp",{
							"value":"Итого",
							"colSpan":is_client? "4":"6"
						})												
						,new GridCellFoot(id+":features_grid:foot:tot_quant",{
							"attrs":{"align":"right", "nowrap":"nowrap"},
							"calcOper":"sum",
							"calcFieldId":"quant",
							"gridColumn":new GridColumnFloat({"id":"tot_quant"})
						})						
					]
				})		
			]
		}),
		"selectedRowClass":"order_current_row",
		"pagination":null,		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	});
	
	if(!is_client){
		var self = this;
		this.m_origGridEdit = grid.edit
		grid.edit = function(cmd,editOptions){
			if(self.m_makeGridListView&&self.m_makeGridListView.enableRefreshing){
				self.m_makeGridListView.enableRefreshing(false);
			}
			self.m_origGridEdit.call(self.getElement("grid"),cmd,editOptions);
		}
	
		this.m_origGridCloseEditView = grid.closeEditView;
		grid.closeEditView = function(res){
			if(self.m_makeGridListView&&self.m_makeGridListView.enableRefreshing){
				self.m_makeGridListView.enableRefreshing(true);
			}
			self.m_origGridCloseEditView.call(self.getElement("grid"),res);
		}
	}
		
	this.addElement(grid);
}
extend(ShipmentForOrderList_View,ViewAjx);
