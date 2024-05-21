/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2019

 * @extends GridAjx
 * @requires core/extend.js
 * @requires controls/GridAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function VehicleScheduleMakeOrderGrid(id,options){
	options = options || {};	
	
	var self = this;
	var model = options.model;	
	CommonHelper.merge(options,{
		"model":model,
		"className":"table-bordered table-responsive table-make_order veh_schedule_grid",		
		"attrs":{"style":"width:100%;"},
		"readPublicMethod":(new VehicleSchedule_Controller()).getPublicMethod("get_current_veh_list"),
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
				commands.push(new VehicleScheduleGridCmdSetFree(id+":grid:cmd:setFree",{"showCmdControl":false}));
				commands.push(new VehicleScheduleGridCmdSetOut(id+":grid:cmd:setOut",{"showCmdControl":false}));
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
					opts.className+=(opts.className.length? " ":"")+"no_tracker";
				}
				else if(m.getFieldValue("tracker_no_data")){
					opts.title="Нет сигнала";
					opts.className+=(opts.className.length? " ":"")+"tracker_no_data";
				}
			}				
		},
		"onEventSetRowOptions":function(opts){
			opts.className = opts.className||"";
			var m = this.getModel();
			var veh_state = m.getFieldValue("state");
				
			opts.className+=(opts.className.length? " ":"")+"veh_in_make_list";
			if (m.getFieldValue("is_late")){
				opts.className+=(opts.className.length? " ":"")+"veh_late";
			}
			else{
				opts.className+=(opts.className.length? " ":"")+ "veh_"+veh_state;
			}
			if (m.getFieldValue("is_late_at_dest")){
				opts.className+=(opts.className.length? " ":"")+"veh_late_at_dest";
			}

			if (veh_state=="shift"){
				opts.className+=(opts.className.length? " ":"")+"veh_shift";
			}
		},
		
		"head":new GridHead(id+":veh_schedule_grid:head",{
			"elements":[
				new GridRow(id+"veh_schedule_grid:head:row0",{
					"elements":[
						new GridCellHead(id+":veh_schedule_grid:head:vehicles_ref",{
							"value":"Номер",
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"master":true,
									"detailViewClass":VehicleRun_View,
									"detailViewOptions":{
										"detailFilters":{
											"VehicleRun_Model":[
												{
												"masterFieldId":"id",
												"field":"schedule_id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									},
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
						,new GridCellHead(id+":veh_schedule_grid:head:drivers_ref",{
							"value":"Водитель",
							"columns":[
								new GridColumn({
									"field":model.getField("drivers_ref"),
									"formatFunction":function(fields,cell){
										var dr_name = window.getApp().formatCell(fields.drivers_ref,cell,VehicleScheduleMakeOrderList_View.prototype.COL_DRIVER_LEN);
										var tel = fields.driver_tel.getValue();
										var ext = window.getApp().getServVar("tel_ext");
										if(!tel || !tel.length || !ext || !ext.length){
											return dr_name;
										}											
										else{
											//phone
											var cell_n = cell.getNode();
											var c_tag = document.createElement("I");
											c_tag.className = "fa fa-phone";
											c_tag.title="Набрать номер водителя";
											c_tag.setAttribute("tel",tel);
											EventHelper.add(c_tag,"click",(function(t){
												return function(){
													window.getApp().makeCall(t);
												}
												})(tel)
											);
											cell_n.appendChild(c_tag);
											
											//msg
											var c_tag = document.createElement("I");
											c_tag.className = "fa fa-send";
											c_tag.title="Отправить сообщение водителю";											
											EventHelper.add(c_tag,"click",(function(id,descr){
												return function(){
													window.getApp().sendNotification(new RefType({
														"dataType":"drivers",
														"keys":{"id": id},
														"descr":descr
													}));
												}
												})(fields.drivers_ref.getValue().getKey("id"),fields.drivers_ref.getValue().getDescr())
											);
											cell_n.appendChild(c_tag);
											
											var c_tag = document.createElement("SPAN");
											c_tag.textContent = " "+dr_name;
											cell_n.appendChild(c_tag);
											
											return "";
										}
									}
								})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:owner",{
							"value":"Владелец",
							"columns":[
								new GridColumn({
									"field":model.getField("owner"),
									"formatFunction":function(fields,cell){
										return window.getApp().formatCell(fields.owner,cell,VehicleScheduleMakeOrderList_View.prototype.COL_OWNER_LEN);
									}
								})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:load_capacity",{
							"value":"Гр",
							"title":"Грузоподъемность",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("load_capacity")})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:state",{
							"value":"Сост.",
							"columns":[
								new GridColumn({
									"field":model.getField("state"),
									"formatFunction":function(fields, cell){
										if(!fields.state){
											return "";
										}
										var st = fields.state.getValue();
										if(st == "shift"){
											cell.getNode().title = "Должен работать согласно графика";
											return "смена";
											
										}else if(st == "free"){											
											var b_descr = self.getProdBaseDescr(fields, 6);
											cell.getNode().title = "Свободен на базе: " + b_descr;
											self.setBaseChangeEvent(
												cell.getNode(),
												fields.state.getValue(),
												(b_descr&&b_descr.length)? b_descr : "база",
												fields.id.getValue(),
												fields.vehicles_ref.getValue().getDescr()
											);
										
										}else if(st == "assigned"){	
											var b_descr = self.getProdBaseDescr(fields, 3);
											cell.getNode().title = "Назначен на базе: " + b_descr;
											self.setBaseChangeEvent(
												cell.getNode(),
												fields.state.getValue(),
												"назн." + b_descr,
												fields.id.getValue(),
												fields.vehicles_ref.getValue().getDescr()
											);
											

										}else if(st == "busy"){	
											var b_descr = self.getProdBaseDescr(fields, 10);
											cell.getNode().title = "Отгружен с базы: " + b_descr;
											return "отгр." + b_descr.substring(0, 3);
											
										}else if(st == "left_for_dest"){	
											cell.getNode().title = "Едет на объект";
											return "-> объект"
										
										}else if(st == "at_dest"){	
											cell.getNode().title = "Находится на объекте: " + fields.destination_name.getValue();
											return "объект";
											
										}else if(st == "left_for_base"){	
											var b_descr = self.getProdBaseDescr(fields, 10);
											cell.getNode().title = "Едет на базу: " + b_descr;
											return "-> " + b_descr.substring(0, 3);
											
										}else if(st == "out_from_shift"){		
											cell.getNode().title = "Закончил смену";
											return "сошёл(см)";
											
										}else if(st == "out"){		
											cell.getNode().title = "Закончил работу с добавочной смены";
											return "сошёл";
											
										}else if(st == "shift_added"){		
											cell.getNode().title = "Добавочная смена";
											return "доб.см.";
											
										}else{
											return "";
										}
									}
								})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:inf_on_return",{
							"value":"Вр.",
							"title":"Время",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("inf_on_return")})
							]
						})
						,new GridCellHead(id+":veh_schedule_grid:head:runs",{
							"value":"Р-сы",
							"title":"Количество рейсов",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({"field":model.getField("runs")})
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
	
	VehicleScheduleMakeOrderGrid.superclass.constructor.call(this,id,options);
}

extend(VehicleScheduleMakeOrderGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

VehicleScheduleMakeOrderGrid.prototype.nodeClickable = function(node){
	return (this.getEnabled() && (node.nodeName==this.DEF_CELL_TAG_NAME||node.nodeName=="SPAN") && DOMHelper.getParentByTagName(node,this.DEF_BODY_TAG_NAME));
}

VehicleScheduleMakeOrderGrid.prototype.getProdBaseDescr = function(fields, smCount){
	var res = "";
	var ref = fields.production_bases_ref.getValue();
	if(ref && !ref.isNull()){
		res+= " ";
		res+= ref.getDescr().substring(0, smCount);
	}
	return res;
}

VehicleScheduleMakeOrderGrid.prototype.setBaseChangeCont = function(vsId, productionBaseId, curSt, vhDescr){
	var pm = this.getReadPublicMethod().getController().getPublicMethod("set_production_base");
	pm.setFieldValue("id", vsId);
	pm.setFieldValue("production_base_id", productionBaseId);
	pm.setFieldValue("last_state", curSt);
	var self = this;
	pm.run({
		"ok":function(resp){
			self.onRefresh(function(){
				window.showTempNote("Для ТС " + vhDescr+" устновлена новая база", null, 3000);
			});
		}
	});	
	
}

VehicleScheduleMakeOrderGrid.prototype.setBaseChange = function(vsId, curSt, vhDescr){
	var self = this;
	(new WindowFormModalBS("VSChange",{
		"content":new EditJSON("VSChange:cont",{
			"elements":[
				new ProductionBaseEdit("VSChange:cont:production_bases_ref",{
					"required":true
				})
			]
		}),
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Замена базы для ТС " + vhDescr,
		"onClickCancel":function(){
			this.close();
		},
		"onClickOk":function(){
			var view = this.getContent();
			if(!view.validate()){
				return;
			}
			var res = view.getValueJSON();
			self.setBaseChangeCont(
				vsId,
				res.production_bases_ref.getKey("id"),
				curSt,
				vhDescr
			);
			this.close();
		}
	})).open();

}

VehicleScheduleMakeOrderGrid.prototype.setBaseChangeEvent = function(cellNode, curSt, stDescr, vsId, vhDescr){
	var st_t = document.createElement("a");
	st_t.textContent = stDescr;
	st_t.setAttribute("vs_id", vsId);
	st_t.setAttribute("vh_descr", vhDescr);
	st_t.setAttribute("cur_st", curSt);				
	var self = this;
	EventHelper.add(st_t, "click", function(e){
		self.setBaseChange(e.target.getAttribute("vs_id"), e.target.getAttribute("cur_st"), e.target.getAttribute("vh_descr"));		
	});
	
	cellNode.appendChild(st_t);
}

VehicleScheduleMakeOrderGrid.prototype.showVehicleInfoCont = function(ctrl, info){
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

VehicleScheduleMakeOrderGrid.prototype.showVehicleInfo = function(ctrl, vehID){
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
