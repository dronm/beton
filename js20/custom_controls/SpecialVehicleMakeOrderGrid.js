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
	
	var self = this;
	var model = options.model;	
	CommonHelper.merge(options,{
		"model":model,
		"className":"table-bordered table-responsive table-make_order veh_special_grid",		
		"attrs":{"style":"width:100%;"},
		"readPublicMethod":(new Vehicle_Controller()).getPublicMethod("get_special_vehicles_list"),
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
				// commands.push(new VehicleScheduleGridCmdSetFree(id+":grid:cmd:setFree",{"showCmdControl":false}));
			}
		}),
		"popUpMenu":new PopUpMenu(),
		"onEventSetCellOptions":function(opts){
			if(opts.gridColumn.getId()=="vehicles_ref"){
				opts.className = opts.className||"";
				var m = this.getModel();
				if(m.getFieldValue("no_tracker")){
					opts.title="Нет оборудования мониторинга";
					opts.className+=(opts.className.length? " ":"")+"no_tracker";
				}
				else if(m.getFieldValue("tracker_no_data")){
					opts.title="Нет сигнала";
					opts.className+=(opts.className.length? " ":"")+"tracker_no_data";
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
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("make")})
							]
						})
						,new GridCellHead(id+":veh_special_grid:head:mileage",{
							"value":"Пробег",
							"title":"Пробег ТС за смену",
								"colAttrs,":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("mileage")})
							]
						})
						,new GridCellHead(id+":veh_special_grid:head:timing",{
							"value":"Время",
							"title":"Время работы ТС за смену",
								"colAttrs,":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("timing")})
							]
						})
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
						,new GridCellHead(id+":veh_schedule_grid:head:fuel_flow_end",{
							"value":"Ост.кон.",
							"title":"Остаток топлива на конец смены",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("fuel_flow_end")})
							]
						})
					]
				})
			]
		}),
		"pagination":null,
		"autoRefresh":false,
		"refreshInterval":null,
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

