/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends GridAjx
 * @requires core/extend.js
 * @requires controls/GridAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function SpecialVehicleMakeOrderGrid(id,options){
	options = options || {};	
	
	this.m_readPublicMethod = (new Vehicle_Controller()).getPublicMethod("get_special_vehicles_list");
	this.setDate(options.date);

	var self = this;
	var model = new SpecialVehicleList_Model();	
	CommonHelper.merge(options,{
		"model":model,
		"keyIds":["id"],
		"className":"table-bordered table-responsive table-make_order veh_special_grid",		
		"attrs":{"style":"width:100%;"},
		"readPublicMethod": this.m_readPublicMethod,
		"editInline":false,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdFilter":false,
			"cmdSearch":false,
			"cmdInsert":false,//new GridCmdInsert(id+":grid:cmd:insert",{"showCmdControl":false})
			"cmdAllCommands":false,
			"cmdExport":false,
			"cmdPrint":false,
			"cmdEdit":false,
			"cmdRefresh":false,
			"cmdDelete":false,
			"cmdCopy":false,
			"filters":null,
			"variantStorage":null,
			"addCustomCommandsAfter":function(commands){
				commands.push(new VehicleScheduleGridCmdShowPosition(id+":grid:cmd:showPos",{"showCmdControl":false}));
				commands.push(new VehicleScheduleGridCmdShowVehicle(id+":grid:cmd:showVeh",{"showCmdControl":false}));
			}
		}),
		"popUpMenu":new PopUpMenu(),
		"onEventSetCellOptions":function(opts){
			if(opts.gridColumn.getId()=="vehicles_ref"){
				opts.className = opts.className||"";
				var m = this.getModel();
				if(m.getFieldValue("no_tracker")){
					opts.title="Нет оборудования мониторинга";
					opts.className+=(opts.className.length? " ":"")+"veh_no_tracker";
				}
				else if(m.getFieldValue("tracker_no_signal")){
					opts.title="Нет сигнала более 8 часов";
					opts.className+=(opts.className.length? " ":"")+"veh_no_tracker_data";
				}
			}				
		},
		// "onEventSetRowOptions":function(opts){
		// 	opts.className = opts.className||"";
		// 	var m = this.getModel();
		// },
		
		"head":new GridHead(id+":veh_special_grid:head",{
			"elements":[
				new GridRow(id+"veh_special_grid:head:row0",{
					"elements":[
						new GridCellHead(id+":veh_special_grid:head:vehicles_ref",{
							"value":"Номер",
							"colAttrs": {"align": "center"},
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"formatFunction":(function(gridCont){
										return function(f, cell){
											let ref = f.vehicles_ref.getValue();
											if(!ref || ref.isNull()){
												return "";
											}
											//hover tooltip
											let cell_n = cell.getNode();										
											// this.m_toolTip = 
											(new ToolTip({
												"node": cell_n,
												"wait": 3000,
												"onHover": (function(cont, vehID){
													return function(ev){
														cont.showVehicleInfo(this, vehID);
													}
												})(gridCont, ref.getKey())
											}));
											return ref.getDescr();
										}
									})(self)
								})
							]								
						})
						,new GridCellHead(id+":veh_special_grid:head:make",{
							"value":"Марка",
							"title":"Марка ТС",
							"colAttrs":{"align":"left"},
							"columns":[
								new GridColumn({
									"field":model.getField("make"),
									"formatFunction":(function(gridCont){
										return function(f, cell){
											const vehMake = f.make.getValue();
											const vehPict = f.map_picture.getValue();
											const iSrc = vehPict? TRACK_CONSTANTS.IMG_PATH+vehPict: TRACK_CONSTANTS.VEH_IMG;
											const iNode = document.createElement("IMG");
											iNode.width = "20";
											iNode.height = "20";
											iNode.src = iSrc;
											cell.m_node.appendChild(iNode);

											if(vehMake && vehMake.length){
												const tNode = document.createElement("SPAN");
												tNode.textContent = vehMake;
												cell.m_node.appendChild(tNode);
											}
											return "";
										}
									})(self)
								})
							]
						})
						,new GridCellHead(id+":veh_special_grid:head:mileage",{
							"value":"Км",
							"title":"Пробег ТС за смену",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("mileage"),
									"formatFunction":(function(gridCont){
										return function(f, cell){
											const km = f.mileage.getValue();
											if(km === 0){
												return ""
											}
											return km;
										}
									})(self)
								})
							]
						})
						,new GridCellHead(id+":veh_special_grid:head:timing",{
							"value":"Время",
							"title":"Время работы ТС за смену",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("timing"),
									"formatFunction":(function(gridCont){
										return function(f, cell){
											const tm = f.timing.getValue();
											const parts = tm.split(":");
											if(parts.length>=3){
												return parts[0]+":"+parts[1];
											}
											return "";
										}
									})(self)
								})
							]
						})
						/*
						,new GridCellHead(id+":veh_schedule_grid:head:fuel_flow_start",{
							"value":"Ост.нач.",
							"title":"Остаток топлива на начало смены",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("fuel_flow_start")})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:fuel_flow_in",{
							"value":"Заправлено",
							"title":"Заправлено топлива за смену",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("fuel_flow_in")})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:fuel_flow_out",{
							"value":"Расход",
							"title":"Расход топлива за смену",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("fuel_flow_out")})
							]
						})
						*/
						,new GridCellHead(id+":veh_schedule_grid:head:fuel_flow_end",{
							"value":"Ост.кон.",
							"title":"Остаток топлива на конец смены",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("fuel_flow_end"),
									"formatFunction":(function(gridCont){
										return function(f, cell){
											const fuel = f.fuel_flow_end.getValue();
											if(fuel === 0){
												return ""
											}
											return fuel;
										}
									})(self)
								})
							]
						})
					]
				})
			]
		}),
		"pagination":null,
		"autoRefresh":true,
		"refreshInterval":1 * 60 * 1000,
		"rowSelect":true,
		"selectedRowClass":"order_current_row",
		"navigate":true,
		"navigateMouse":true,
		"focus":false
	});	
	
	SpecialVehicleMakeOrderGrid.superclass.constructor.call(this,id,options);
}

extend(SpecialVehicleMakeOrderGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

SpecialVehicleMakeOrderGrid.prototype.nodeClickable = function(node){
	return (this.getEnabled() && (node.nodeName==this.DEF_CELL_TAG_NAME||node.nodeName=="SPAN") && DOMHelper.getParentByTagName(node,this.DEF_BODY_TAG_NAME));
}

SpecialVehicleMakeOrderGrid.prototype.showVehicleInfoCont = function(ctrl, info){
	ctrl.popup(
		'<h4>'+ info.plate.getValue() +'</h4>'+
		'<table>'+
		'<tr>'+
			'<td>Марка:</td>'+
			'<td>'+ info.make.getValue() +'</td>'+
		'</tr>'+
		'<tr>'+
			'<td>Грузоподъемность:</td>'+
			'<td>'+ info.load_capacity.getValue() +'</td>'+
		'</tr>'+
		'<tr>'+
			'<td>Трэкер:</td>'+
			'<td>'+ info.tracker_id.getValue() +'</td>'+
		'</tr>'+
		'<tr>'+
			'<td>Послeдние данные:</td>'+
			'<td>'+ DateHelper.format(info.tracker_last_dt.getValue(), "d.m.y H:i") +'</td>'+
		'</tr>'+
		'<tr>'+
			'<td>Кол-во спутников:</td>'+
			'<td>'+ info.tracker_sat_num.getValue() +'</td>'+
		'</tr>'+
		'</table>',
		{"title":"Данные по ТС"}
	);
}

SpecialVehicleMakeOrderGrid.prototype.showVehicleInfo = function(ctrl, vehID){
	var pm = (new Vehicle_Controller()).getPublicMethod("get_object");
	pm.setFieldValue("id", vehID);
	pm.run({
		"ok":(function(cont){
			return function(resp){
				let m = resp.getModel("VehicleDialog_Model");
				if(m.getNextRow()){
					cont.showVehicleInfoCont(ctrl, m.getFields());
				}
			}
		})(this)
	});
}

SpecialVehicleMakeOrderGrid.prototype.setDate = function(dt){
	this.m_readPublicMethod.setFieldValue("date", dt);
}

