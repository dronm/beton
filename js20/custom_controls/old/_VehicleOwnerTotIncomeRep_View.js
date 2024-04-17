/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 */
function VehicleOwnerTotIncomeRep_View(id,options){
	options = options || {};	
	
	var role_id = window.getApp().getServVar("role_id");
	
	var self = this;
	options.addElement = function(){
		if(role_id!="vehicle_owner"){
			this.addElement(new VehicleOwnerEdit(id+":vehicle_owner",{
				"labelClassName":"control-label " + window.getBsCol(1),
				"editContClassName":"input-group " + window.getBsCol(5),
			}));	
		}
		this.addElement(new EditPeriodMonth(id+":date_from",{
			"template": window.getApp().getTemplate("EditPeriodMonthFromTo")
		}));	
		this.addElement(new EditPeriodMonth(id+":date_to",{
			"template": window.getApp().getTemplate("EditPeriodMonthFromTo")
		}));	
		
		this.addElement(new ButtonCmd(id+":cmdApplyFilter",{
			"caption":"Сформировать",
			"title":"Построить отчет за период",
			"onClick":function(){
				self.cmdApplyFilter();
			}
		}));	
		
	}
	VehicleOwnerTotIncomeRep_View.superclass.constructor.call(this,id,options);
	
}

extend(VehicleOwnerTotIncomeRep_View,View);

VehicleOwnerTotIncomeRep_View.prototype.UPDATE_DELAY = 2000;
VehicleOwnerTotIncomeRep_View.prototype.MONEY_THOUSAND_DELIMETER = " ";
VehicleOwnerTotIncomeRep_View.prototype.MONEY_DECIMAL_DELIMETER = ",";
VehicleOwnerTotIncomeRep_View.prototype.COMMON_ITEM_ID_OFFSET = 10000;//добавляется к ИД общих услуг, чтобы не перекрывались

VehicleOwnerTotIncomeRep_View.prototype.isFilterValid = function(){
	var res = true;	
	var owner_ref = this.getElement("vehicle_owner").getValue();
	if(!owner_ref || owner_ref.isNull()){
		this.getElement("vehicle_owner").setNotValid("Не задан владелец");
		res = false;
	}	
	return res;
}

VehicleOwnerTotIncomeRep_View.prototype.getReportNode = function(){
	return document.getElementById(this.getId() + ":report");

}

VehicleOwnerTotIncomeRep_View.prototype.setTemplateContent = function(cont){
	var target_n = this.getReportNode();
	if(!target_n){
		throw new Error("Report node not found");
	}
	target_n.innerHTML = cont;
}

VehicleOwnerTotIncomeRep_View.prototype.cmdApplyFilterCont = function(resp, from, to){
	DOMHelper.show(this.getId() + ":repPanel");
	
	var m = new ModelXML("VehicleOwnerTotIncomeReport_Model", {
		"fields":[
			new FieldInt("veh_id"),
			new FieldString("veh_plate"),
			new FieldInt("item_id"),
			new FieldString("item_name"),
			new FieldBool("item_is_income"),
			new FieldBool("item_input"),
			new FieldDate("period"),
			new FieldFloat("val"),
			new FieldInt("runs"),
			new FieldInt("self_runs"),
			new FieldFloat("avg_quant"),
			new FieldInt("avg_runs")
		],
		"data":resp.getModelData("VehicleOwnerTotIncomeReport_Model")
	});

	//id, code, name, is_income
	var m_common = new ModelXML("VehicleTotRepCommonItemList_Model", {
		"data":resp.getModelData("VehicleTotRepCommonItemList_Model")
	});

	var m_common_vals = new ModelXML("VehicleTotRepCommonItemValList_Model", {
		"fields":[
			new FieldInt("item_id"),
			new FieldString("item_name"),
			new FieldFloat("period"),
			new FieldBool("is_income"),
			new FieldFloat("value")
		],
		"data":resp.getModelData("VehicleTotRepCommonItemValList_Model")
	});

	var m_stat = new ModelXML("VehicleOwnerTotIncomeReportStat_Model", {
		"fields":[
			new FieldInt("id"),
			new FieldInt("runs"),
			new FieldFloat("quant"),
			new FieldFloat("quant_avg"),
			new FieldInt("runs_self"),
			new FieldDate("period_mon"),
			new FieldInt("work_day_count"),
			new FieldFloat("balance_beg")
		],
		"data":resp.getModelData("VehicleOwnerTotIncomeReportStat_Model")
	});

	stat_vals = {"periods":{},"vehicles":{},"items":{}, "val_total":0, "self_run_total":0, "run_total":0, "quant_avg_total":0.0};
	var period_count = 0;
	var vehicle_count = 0;
	this.m_balance_beg = 0;
	
	while(m_stat.getNextRow()){
		var id = m_stat.getFieldValue("id");
		var period_mon = m_stat.getFieldValue("period_mon");
		this.m_balance_beg = m_stat.getFieldValue("balance_beg");
		
		if(!stat_vals.periods[period_mon]){
			stat_vals.periods[period_mon] = {"vehicles":{}, "period": period_mon};
			period_count++;
		}
		
		if(!stat_vals.vehicles[id]){
			stat_vals.vehicles[id] = {"runs":0, "quant_avg":0, "runs_self":0, "runs_avg":0.0};
			vehicle_count++;
		}
		
		if(!stat_vals.periods[period_mon].vehicles[id]){
			var runs = m_stat.getFieldValue("runs");
			var runs_avg = Math.round(runs / m_stat.getFieldValue("work_day_count") *100)/100;
			var quant_avg = m_stat.getFieldValue("quant_avg");
			var runs_self = m_stat.getFieldValue("runs_self");
			
			stat_vals.periods[period_mon].vehicles[id] = {
				"runs": runs,
				"quant_avg": quant_avg,
				"runs_self": runs_self,
				"runs_avg": runs_avg
			};
			stat_vals.vehicles[id].runs+= runs;
			stat_vals.vehicles[id].quant_avg+= quant_avg;
			stat_vals.vehicles[id].runs_self+= runs_self;
			stat_vals.vehicles[id].runs_avg+= runs_avg;
		}
	}
	stat_vals.period_totals = new Array(period_count);
	stat_vals.period_runs = new Array(period_count);
	stat_vals.period_avg_runs = new Array(period_count);
	stat_vals.period_avg_quant = new Array(period_count);
	stat_vals.period_self_runs = new Array(period_count);

	var tmpl_opts = {
		"VEHICLES": []
	};
	tmpl_opts.BALANCE_BEG = this.formatFloatValue(this.m_balance_beg);
	tmpl_opts.BALANCE_END = this.formatFloatValue(0);
	tmpl_opts.PERIOD_FROM = DateHelper.format(from, "FF Y");	
	var d = new Date();
	d.setDate(to.getDate() + 1);
	tmpl_opts.PERIOD_TO = DateHelper.format(d, "FF Y");
	
	var tmpl = window.getApp().getTemplate("VehicleOwnerTotIncomeRep_View");
	
	var per_ind = {} //period indexes		
	
	var old_veh_id, old_item_id = 0;
	var cur_veh, cur_row;
	while(m.getNextRow()){
		var veh_id = m.getFieldValue("veh_id");
		var item_id = m.getFieldValue("item_id");
		var per = m.getFieldValue("period");
		
		if(old_veh_id != veh_id){
			//new vehicle
			cur_veh = {
				"PLATE": m.getFieldValue("veh_plate"),
				"ROWS": [],
				"PERIODS": [],
				"PERIOD_TOTALS": [],
				"PERIOD_RUNS": [],
				"PERIOD_AVG_RUNS": [],
				"PERIOD_AVG_QUANT": [],
				"PERIOD_SELF_RUNS": [],
				"RUN_TOTAL": stat_vals.vehicles[veh_id].runs,
				"SELF_RUN_TOTAL": stat_vals.vehicles[veh_id].runs_self,
				"AVG_RUN_TOTAL": Math.round(stat_vals.vehicles[veh_id].runs_avg / period_count * 100) / 100,
				"AVG_QUANT_TOTAL": Math.round(stat_vals.vehicles[veh_id].quant_avg / period_count * 100) / 100,
				"COL_COUNT":0,
				"VAL_TOTAL_N": 0,
				"VAL_TOTAL": "0.00"
			};
			tmpl_opts.VEHICLES.push(cur_veh);
						
			var loop_dt = new Date(from.getTime());
			var ind = 0;
			while(loop_dt <= to){
				var per_ind_v = loop_dt.getMonth().toString() + loop_dt.getFullYear().toString();				
				if(!per_ind[per_ind_v]){
					per_ind[per_ind_v] = ind;
					ind++;
				}
				cur_veh.PERIODS.push({"PERIOD": DateHelper.format(loop_dt, "FF y")});	
				cur_veh.PERIOD_TOTALS.push({
					"VAL_N": 0,
					"VAL": "0.00"
				});				
				cur_veh.PERIOD_RUNS.push({
					"VAL": 0
				});				
				cur_veh.PERIOD_AVG_RUNS.push({
					"VAL": 0
				});				
				cur_veh.PERIOD_AVG_QUANT.push({
					"VAL": 0
				});				
				cur_veh.PERIOD_SELF_RUNS.push({
					"VAL": 0
				});				
				
				loop_dt = new Date(loop_dt.setMonth(loop_dt.getMonth() + 1));				
			}
			
			old_veh_id = veh_id;
		}
		
		if(old_item_id != item_id){
			//new item - new row
			var item_name = m.getFieldValue("item_name");
			var item_id = m.getFieldValue("item_id");
			var item_input = m.getFieldValue("item_input");
			var item_is_income = m.getFieldValue("item_is_income");
			var item_class = item_is_income? "veh_owner_tot_income_income" : "veh_owner_tot_income_outcome";
			
			cur_row = {
				"ITEM_NAME": item_name,
				"ITEM_ID": item_id,
				"ITEM_CLASS": item_class,
				"ITEM_INPUT": item_input,
				"NOT_COMMON_ITEM": true,
				"PERIODS": [],
				"VAL_TOTAL_N": 0,
				"VAL_TOTAL": "0.00"
			}
			var loop_dt = new Date(from.getTime());
			while(loop_dt <= to){
				cur_row.PERIODS.push({"val": 0});
				loop_dt = new Date(loop_dt.setMonth(loop_dt.getMonth() + 1));
			}
			
			cur_veh.ROWS.push(cur_row);
			
			old_item_id = item_id;
			
			if(!stat_vals.items[item_id]){
				stat_vals.items[item_id] = {
					"ITEM_NAME": item_name,
					"ITEM_ID": item_id,
					"ITEM_INPUT": false,
					"NOT_COMMON_ITEM": true,
					"ITEM_CLASS": item_class + " veh_owner_tot_income_totals",
					"PERIODS": new Array(period_count),
					"VAL_TOTAL_N": 0,
					"VAL_TOTAL": "0.00",
					"item_is_income": item_is_income // Вспомошательное поле, в шаблоне не используется: доход/расход
				}
				//add all periods
				for(p in stat_vals.periods){
					var period = stat_vals.periods[p].period;
					var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];
					stat_vals.items[item_id].PERIODS[per_ind_v] = {
						"VAL_N":0	,
						"ITEM_ID":item_id,
						"VEH_ID":undefined,
						"PERIOD":DateHelper.format(period, "Y-m-d")
					};
				}
			}
		}
		var ind = per.getMonth().toString() + per.getFullYear().toString();
		var per_ind_v = per_ind[ind];
		
		var val = m.getFieldValue("val");
		var val_k = m.getFieldValue("item_is_income")? 1 : -1;
		cur_row.PERIODS[per_ind_v].VAL = this.formatFloatValue(val);
		cur_row.PERIODS[per_ind_v].ITEM_ID = item_id;
		cur_row.PERIODS[per_ind_v].VEH_ID = veh_id;
		cur_row.PERIODS[per_ind_v].PERIOD = DateHelper.format(per, "Y-m-d");

		stat_vals.items[item_id].PERIODS[per_ind_v].VAL_N += val;
		stat_vals.items[item_id].PERIODS[per_ind_v].VAL = this.formatFloatValue(stat_vals.items[item_id].PERIODS[per_ind_v].VAL_N); 
		stat_vals.items[item_id].VAL_TOTAL_N += val;
		stat_vals.items[item_id].VAL_TOTAL = this.formatFloatValue(stat_vals.items[item_id].VAL_TOTAL_N); 
		if(!stat_vals.period_totals[per_ind_v]){
			stat_vals.period_totals[per_ind_v] = {"VAL_N":0};
			stat_vals.period_runs[per_ind_v] = {"VAL_N":0};
			stat_vals.period_avg_runs[per_ind_v] = {"VAL_N":0};
			stat_vals.period_avg_quant[per_ind_v] = {"VAL_N":0};
			stat_vals.period_self_runs[per_ind_v] = {"VAL_N":0};
		}
		stat_vals.period_totals[per_ind_v].VAL_N += val * val_k;		
		stat_vals.period_totals[per_ind_v].VAL = this.formatFloatValue(stat_vals.period_totals[per_ind_v].VAL_N);
		stat_vals.val_total += val * val_k;
		
		if(!stat_vals.period_totals[per_ind_v].vehicles || !stat_vals.period_totals[per_ind_v].vehicles[veh_id]){
			stat_vals.period_totals[per_ind_v].vehicles = stat_vals.period_totals[per_ind_v].vehicles || {};
			stat_vals.period_totals[per_ind_v].vehicles[veh_id] = true;			
			
			stat_vals.period_runs[per_ind_v].VAL_N += stat_vals.periods[per].vehicles[veh_id].runs;
			stat_vals.period_runs[per_ind_v].VAL = stat_vals.period_runs[per_ind_v].VAL_N;
			stat_vals.run_total += stat_vals.periods[per].vehicles[veh_id].runs;
			
			stat_vals.quant_avg_total += stat_vals.periods[per].vehicles[veh_id].quant_avg;
		
			stat_vals.period_avg_runs[per_ind_v].VAL_N += stat_vals.periods[per].vehicles[veh_id].runs_avg;
			stat_vals.period_avg_quant[per_ind_v].VAL_N += stat_vals.periods[per].vehicles[veh_id].quant_avg;
			
			stat_vals.period_self_runs[per_ind_v].VAL_N += stat_vals.periods[per].vehicles[veh_id].runs_self;
			stat_vals.period_self_runs[per_ind_v].VAL = stat_vals.period_self_runs[per_ind_v].VAL_N;
			stat_vals.self_run_total += stat_vals.periods[per].vehicles[veh_id].runs_self;			
		}
		
		//******
		cur_row.VAL_TOTAL_N = cur_row.VAL_TOTAL_N + val;
		cur_row.VAL_TOTAL = this.formatFloatValue(cur_row.VAL_TOTAL_N);
		
		cur_veh.VAL_TOTAL_N = cur_veh.VAL_TOTAL_N + val * val_k;
		cur_veh.VAL_TOTAL = this.formatFloatValue(cur_veh.VAL_TOTAL_N);
		
		cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N = cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N + val * val_k;
		cur_veh.PERIOD_TOTALS[per_ind_v].VAL = this.formatFloatValue(cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N);
		cur_veh.COL_COUNT = cur_veh.PERIOD_TOTALS.length + 2;

		cur_veh.PERIOD_RUNS[per_ind_v].VAL = stat_vals.periods[per].vehicles[veh_id].runs;
		cur_veh.PERIOD_AVG_RUNS[per_ind_v].VAL = stat_vals.periods[per].vehicles[veh_id].runs_avg;
		cur_veh.PERIOD_SELF_RUNS[per_ind_v].VAL = stat_vals.periods[per].vehicles[veh_id].runs_self;
		cur_veh.PERIOD_AVG_QUANT[per_ind_v].VAL = stat_vals.periods[per].vehicles[veh_id].quant_avg;
	}

	//Это уже не авто, а итоги
	var cur_veh = {
		"PLATE": "Итого",
		"ROWS": [],
		"PERIODS": new Array(period_count),
		"PERIOD_TOTALS": stat_vals.period_totals,
		"PERIOD_RUNS": stat_vals.period_runs,
		"PERIOD_AVG_RUNS": stat_vals.period_avg_runs,
		"PERIOD_AVG_QUANT": stat_vals.period_avg_quant,
		"PERIOD_SELF_RUNS": stat_vals.period_self_runs,
		"RUN_TOTAL": stat_vals.run_total,
		"AVG_RUN_TOTAL": 0,
		"AVG_QUANT_TOTAL": 0,
		"SELF_RUN_TOTAL": stat_vals.self_run_total,
		"VAL_TOTAL": this.formatFloatValue(stat_vals.val_total),
		"TOTAL_TABLE": true
	};
	//итоги по периодам
	for(p in stat_vals.periods){
		var period = stat_vals.periods[p].period;
		var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];
		cur_veh.PERIODS[per_ind_v] = {"PERIOD": DateHelper.format(period, "FF y")};
		
		cur_veh.PERIOD_AVG_RUNS[per_ind_v].VAL = Math.round(cur_veh.PERIOD_AVG_RUNS[per_ind_v].VAL_N / vehicle_count * 100) / 100;
		cur_veh.AVG_RUN_TOTAL+= cur_veh.PERIOD_AVG_RUNS[per_ind_v].VAL;
		
		cur_veh.PERIOD_AVG_QUANT[per_ind_v].VAL = Math.round(cur_veh.PERIOD_AVG_QUANT[per_ind_v].VAL_N / vehicle_count * 100) / 100;
		cur_veh.AVG_QUANT_TOTAL+= cur_veh.PERIOD_AVG_QUANT[per_ind_v].VAL;		
	}
	cur_veh.AVG_RUN_TOTAL = Math.round(cur_veh.AVG_RUN_TOTAL / vehicle_count * 100) / 100;
	cur_veh.AVG_QUANT_TOTAL = Math.round(cur_veh.AVG_QUANT_TOTAL / vehicle_count * 100) / 100;
		
	//Порядок вывода статей в итогах:
	//	- Доходы по авто
	//	- Общие доходы
	//	- Расходы по авто
	//	- Общие расходы
	var income_done = false; //закончили с доходами
	for(var it in stat_vals.items){
		if(!income_done && !stat_vals.items[it].item_is_income){ //не выводили общие доходы и пошли статьи расхода
			//Сначала добавим общие доходы
			while(m_common.getNextRow()){
				if(!m_common.getFieldValue("is_income")){
					break;
				}
				var item_id = m_common.getFieldValue("id") + this.COMMON_ITEM_ID_OFFSET;
				var periods = new Array(period_count);
				for(p in stat_vals.periods){
					var period = stat_vals.periods[p].period;
					var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];
					periods[per_ind_v] = {
						"VAL_N":0	,
						"ITEM_ID":item_id,
						"VEH_ID":undefined,
						"PERIOD":DateHelper.format(period, "Y-m-d")
					};
				}				
				cur_veh.ROWS.push({
					"ITEM_NAME": m_common.getFieldValue("name"),
					"ITEM_ID": item_id,
					"ITEM_INPUT": false,
					"NOT_COMMON_ITEM": false,
					"COMMON_ITEM":true,
					"ITEM_CLASS": "veh_owner_tot_income_income veh_owner_tot_income_totals",
					"PERIODS": periods,
					"VAL_TOTAL_N": 0,
					"VAL_TOTAL": "0.00"
				});
			}
			income_done = true;
		}
		cur_veh.ROWS.push(stat_vals.items[it]);	
	}
	//+Общие расходы, первый расход уже есть, выводим и продолжаем
	do {
		var item_id = m_common.getFieldValue("id") + this.COMMON_ITEM_ID_OFFSET;
		var periods = new Array(period_count);
		for(p in stat_vals.periods){
			var period = stat_vals.periods[p].period;
			var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];
			periods[per_ind_v] = {
				"VAL_N":0	,
				"ITEM_ID":item_id,
				"VEH_ID":undefined,
				"PERIOD":DateHelper.format(period, "Y-m-d")
			};
		}						
		cur_veh.ROWS.push({
			"ITEM_NAME": m_common.getFieldValue("name"),
			"ITEM_ID": item_id,
			"ITEM_INPUT": false,
			"NOT_COMMON_ITEM": false,			
			"COMMON_ITEM":true,
			"ITEM_CLASS": "veh_owner_tot_income_outcome veh_owner_tot_income_totals",
			"PERIODS": periods,
			"VAL_TOTAL_N": 0,
			"VAL_TOTAL": "0.00"
		});			
	} while(m_common.getNextRow());
	
	tmpl_opts.VEHICLES.push(cur_veh); //итоги
	tmpl_opts.BALANCE_END = this.formatFloatValue(this.m_balance_beg + stat_vals.val_total );
	
	Mustache.parse(tmpl);
	this.setTemplateContent(Mustache.render(tmpl, tmpl_opts));
	
	//update end balances
	this.updateValue(undefined, undefined, undefined, 0, this.getBalanceValues(1));

	//events
	var self = this;
	
	var inputs = DOMHelper.getElementsByAttr("veh_owner_tot_income_input", this.getReportNode(), "class", false);
	for(var i = 0; i < inputs.length; i++){
		var t = inputs[i].textContent;
		DOMHelper.delNode(inputs[i].firstChild);
		var ed = DOMHelper.hasClass(inputs[i], "veh_owner_tot_income_input_edit");
		var is_in = DOMHelper.hasClass(inputs[i], "veh_owner_tot_income_income");
		var is_tot = DOMHelper.hasClass(inputs[i], "veh_owner_tot_income_totals");
		var title;
		if(is_tot && is_in){
			title = "Итог за месяц по статье доходов, рассчитывается автоматическти по всем ТС за период";
		}else if(is_tot && !is_in){
			title = "Итог за месяц по статье расходов, рассчитывается автоматическти по всем ТС за период";
		}else if(ed && is_in){
			title = "Статья доходов ТС, редактируется вручную";
		}else if(!ed && is_in){
			title = "Статья доходов ТС, рассчитывается автоматическти";
		}else if(ed && !is_in){
			title = "Статья расходов ТС, редактируется вручную";
		}else{
			title = "Статья расходов ТС, рассчитывается автоматическти";
		}
		
		var el = new EditString(null, {
			"cmdClear":false,
			"editContClassName": window.getBsCol(12),
			"value": t,
			"enabled": ed,
			"title": title,
			"className": ("form-control " + (is_in? "moneyEditable" : "moneyEditableNeg")),
			"events":{
				"input": !ed? null : (function(vehId, itemId, period, rowIndex, cellIndex, tableNode){
					return function(e){
						self.updateTotals(cellIndex, tableNode, itemId, period);
						var v = this.getValue();
						if(v > 0 && DOMHelper.hasClass(this.m_node, "moneyEditableNeg")){
							v = v * -1;
						}
						self.updateValue(vehId, itemId, period, v, self.getBalanceValues(cellIndex));
						
					}
				})(inputs[i].getAttribute("vehicle_id"),
					inputs[i].getAttribute("item_id"),
					inputs[i].getAttribute("period"),
					inputs[i].parentNode.rowIndex,
					inputs[i].cellIndex,
					DOMHelper.getParentByTagName(inputs[i], "TABLE")
				)
			}
		});
		this.setInputFormatterOptions(el);
		el.toDOM(inputs[i]);
	}
	
	//common inputs
	var inputs = DOMHelper.getElementsByAttr("veh_owner_tot_income_common_input", this.getReportNode(), "class", false);
	for(var i = 0; i < inputs.length; i++){
		var t = inputs[i].textContent;
		DOMHelper.delNode(inputs[i].firstChild);
		var is_in = DOMHelper.hasClass(inputs[i], "veh_owner_tot_income_income");
		if(is_in){
			title = "Общая статья доходов, редактируется вручную";
		}else{
			title = "Общая статья расходов, редактируется вручную";
		}
		var el = new EditString(null, {
			"cmdClear":false,
			"editContClassName": window.getBsCol(12),
			"value": t,
			"title":title,
			"className": ("form-control " + (is_in? "moneyEditable" : "moneyEditableNeg")),
			"events":{
				"input": (function(itemId, period, rowIndex, cellIndex, tableNode){
					return function(e){
						self.updateTotals(cellIndex, tableNode, itemId, period);
						/*
						self.updateTotals(rowIndex, cellIndex, tableNode, vehId, itemId, period);
						var v = this.getValue();
						if(v > 0 && DOMHelper.hasClass(this.m_node, "moneyEditableNeg")){
							v = v * -1;
						}
						self.updateValue(vehId, itemId, period, v, self.getBalanceValues(cellIndex));
						*/
						
					}
				})(inputs[i].getAttribute("item_id"),
					inputs[i].getAttribute("period"),
					inputs[i].parentNode.rowIndex,
					inputs[i].cellIndex,
					DOMHelper.getParentByTagName(inputs[i], "TABLE")
				)
			}
		});
		this.setInputFormatterOptions(el);
		el.toDOM(inputs[i]);
	}
	
}

VehicleOwnerTotIncomeRep_View.prototype.setInputFormatterOptions = function(el){
	el.m_formatterOptions = {"numeral": true,
			"numeralDecimalScale":2,		
			"numeralDecimalMark": this.MONEY_DECIMAL_DELIMETER,		
			"numeralThousandsGroupStyle": "thousand",
			"delimiter": this.MONEY_THOUSAND_DELIMETER,
			"rawValueTrimPrefix":true,
			"onValueChanged":(function(elem){
				return function (e) {
					if(e.target.rawValue > 0 && elem && elem.m_cleave && DOMHelper.hasClass(elem.m_node, "moneyEditableNeg")){
						elem.m_cleave.setRawValue(e.target.rawValue * -1);
					//}else if (!e.target.value || !e.target.value.length){
					//	elem.m_cleave.setRawValue("0,00");
					}
				}
			})(el)
	};	
}

VehicleOwnerTotIncomeRep_View.prototype.getBalanceValues = function(fromCellIndex){
	//остатоки по периодам = итоговая таблица foot Первая строка, колонка со второй по предпоследнюю
	var balance_values = {}; //ключ=период, занчение=остаток
	
	var tot_tb = DOMHelper.getElementsByAttr("veh_owner_tot_income_total_table", this.getNode(), "class", true);
	var tfeet = tot_tb[0].getElementsByTagName('tfoot');
	var tbody = tot_tb[0].getElementsByTagName('tbody');							
	var tot_cells = tfeet[0].rows[0].cells;
	var bal = this.m_balance_beg;
	for(var col = fromCellIndex; col < tot_cells.length - 1; col++){ //периоды = со второй по предпоследнюю
		var p = DateHelper.strtotime(tbody[0].rows[0].cells[col].getAttribute("period"));
		if(!DateHelper.isValidDate(p)){
			throw new Error('Not valid date');
		}
		p = DateHelper.monthEnd(p);
		p.setDate(p.getDate() + 1);
		bal+= this.getNodeFloatValue(tot_cells[col]);
		balance_values[DateHelper.format(p, "Y-m-d")] =  bal;
	}
	return balance_values;	
}

VehicleOwnerTotIncomeRep_View.prototype.updateValueCont = function(){
	var pm = (new VehicleTotRepItemValue_Controller()).getPublicMethod("update_values");
	pm.setFieldValue("values", CommonHelper.serialize(this.m_updateValues["values"]));
	pm.setFieldValue("common_values", CommonHelper.serialize(this.m_updateValues.common_values));	
	pm.setFieldValue("balance_vehicle_owner_id", this.m_updateValues.balance_vehicle_owner_id);
	pm.setFieldValue("balance_values", CommonHelper.serialize(this.m_updateValues.balance_values));
	pm.run();
	this.m_updateValuesTimeoutID = undefined;
	this.m_updateValues = undefined;
}

VehicleOwnerTotIncomeRep_View.prototype.formatFloatValue = function(number){
	return CommonHelper.numberFormat(number, 2, this.MONEY_DECIMAL_DELIMETER, this.MONEY_THOUSAND_DELIMETER);
}

VehicleOwnerTotIncomeRep_View.prototype.getNodeFloatValue = function(node){
	//var f = (!node||!node.value)? 0 : parseFloat(node.value.replaceAll(this.MONEY_THOUSAND_DELIMETER, "").replaceAll(this.MONEY_DECIMAL_DELIMETER, "."));
	var f = 0;
	if(node && node.rawValue!= undefined){
		f = node.rawValue;
		
	}else if(node){
		var v_for_parse = 0;
		if(node.value!= undefined){
			v_for_parse = node.value;
		}else if(node.textContent){
			v_for_parse = node.textContent;
		}
		f = parseFloat(v_for_parse.replaceAll(this.MONEY_THOUSAND_DELIMETER, "").replaceAll(this.MONEY_DECIMAL_DELIMETER, "."));
	}
	if(isNaN(f)){
		f = 0;
		
	}else if (f < 0){
		f = f * -1.0;
	}
	return f;
}

VehicleOwnerTotIncomeRep_View.prototype.updateTotalTableTotals = function(itemId, period){
	//total table
	var tot_tb = DOMHelper.getElementsByAttr("veh_owner_tot_income_total_table", this.getNode(), "class", true);
	if(!tot_tb || !tot_tb.length){
	}
	var tbodies = tot_tb[0].getElementsByTagName('tbody');
	if(!tbodies || !tbodies.length){
		return;
	}
	var tfeet = tot_tb[0].getElementsByTagName('tfoot');
	if(!tfeet || !tfeet.length){
		return;
	}
	
	var tbody = tbodies[0];
	var tfoot = tfeet[0];
	
	//all inputs of the same item+period
	var input_cells = DOMHelper.getElementsByAttr("veh_owner_tot_income_input", this.getNode(), "class", false);
	var tot_per = 0;
	for(i = 0; i < input_cells.length; i++){
		if(input_cells[i].getAttribute("item_id") == itemId && input_cells[i].getAttribute("period") == period){
			var inp = input_cells[i].getElementsByTagName('input');
			if(!inp || !inp.length){
				continue;
			}
			if(!DOMHelper.hasClass(input_cells[i], "veh_owner_tot_income_input_edit")){
				var v_old = this.getNodeFloatValue(inp[0]);
				
				var k = DOMHelper.hasClass(inp[0], "moneyEditableNeg")? -1 : 1;
				inp[0].value = this.formatFloatValue(tot_per * k);
				
				var delta = tot_per - v_old;
				//update total row value
				var par = DOMHelper.getParentByTagName(inp[0], "TR");
				if(par){
					//Итог по строке в итоговой таблице
					if(par.children && par.children.length){		
						this.set_total_to_text_node(par.children[par.children.length - 1], delta, k);
					}
					
					//итого по периоду
					var tot_n = tfoot.rows[0].cells[input_cells[i].cellIndex];
					this.set_total_to_text_node(tot_n, delta * k);
					
					//всего
					var par = DOMHelper.getParentByTagName(tot_n, "TR");
					if(par){
						if(par.children && par.children.length){										
							var tot_n = par.children[par.children.length - 1];
							var v = this.getNodeFloatValue(tot_n);
							var tot_val = (v + (delta * k)) * k;
							tot_n.textContent = this.formatFloatValue(tot_val);	
							
							//balance end 
							var balance_end = this.m_balance_beg + tot_val * k;
							document.getElementById("VehicleOwnerTotIncomeRep:balance_end").value = this.formatFloatValue(balance_end);
							
						}
					}
					
				}
			}else{
				tot_per += this.getNodeFloatValue(inp[0]);
			}
		}
	}
}

VehicleOwnerTotIncomeRep_View.prototype.updateTotals = function(cellIndex, tableNode, itemId, period){
	//totals
	var tbodies = tableNode.getElementsByTagName('tbody');
	if(!tbodies || !tbodies.length){
		return;
	}
	var tbody = tbodies[0];
	var period_tot = 0;
	var total = 0;
	for (var r = 0; r < tbody.rows.length; r++) {
		var row_tot = 0; //итог по строке
		var k = DOMHelper.hasClass(tbody.rows[r].cells[0], "veh_owner_tot_income_income")? 1 : -1;
		for (var c = 1; c < tbody.rows[r].cells.length - 1; c++) {
			var n = tbody.rows[r].cells[c].getElementsByTagName('input');
			if(n && n.length){					
				var n_val = this.getNodeFloatValue(n[0]);
				if(isNaN(n_val)){
					n_val = 0;
				}
				
				if(tbody.rows[r].cells[c].cellIndex == cellIndex){						
					period_tot+= (n_val * k);
				}
				
				row_tot+= n_val;
			}
		}
		//последняя колонка в таблице - это итог
		total+= row_tot;
		tbody.rows[r].cells[tbody.rows[r].cells.length - 1].textContent = this.formatFloatValue(row_tot * k);
	}
	
	var tfeet = tableNode.getElementsByTagName('tfoot');
	if(!tfeet || !tfeet.length || !tfeet[0].rows){
		return;
	}
	var tfoot = tfeet[0];		
	//Итог по периоду в текущей таблице
	for (var c = 1; c < tfoot.rows[0].cells.length - 1; c++) {
		if(tfoot.rows[0].cells[c].cellIndex == cellIndex){
			tfoot.rows[0].cells[c].textContent = this.formatFloatValue(period_tot);
			break;
		}
	}					
	//Всего в текущей таблице
	tfoot.rows[0].cells[tfoot.rows[0].cells.length - 1].textContent = this.formatFloatValue(total);
	
	//total table
	this.updateTotalTableTotals(itemId, period);
}

//можно выводить отрицательные итоги, k=-1
VehicleOwnerTotIncomeRep_View.prototype.set_total_to_text_node = function(totNode, delta, k){
	if(k == undefined){
		k = 1;
	}
	var v = this.getNodeFloatValue(totNode);
	totNode.textContent = this.formatFloatValue((v + delta) * k);	
}

VehicleOwnerTotIncomeRep_View.prototype.updateValueInit = function(){
	if(!this.m_updateValues){
		var owner_ctrl = this.getElement("vehicle_owner").getValue();
		if(!owner_ctrl || owner_ctrl.isNull()){
			throw new Error("Не задан владелец!");
		}
		var owner_id = owner_ctrl.getKey();
		this.m_updateValues = {"values":{}, "common_values":{}, "balance_values": {}, "balance_vehicle_owner_id": owner_id};
	}	
}

VehicleOwnerTotIncomeRep_View.prototype.updateValueStartTimer = function(){
	if(this.m_updateValuesTimeoutID){
		return;
	}
	var self = this;
	this.m_updateValuesTimeoutID = setTimeout(function(){
		self.updateValueCont();
	}, this.UPDATE_DELAY);	
}

//Обновление vehicle_tot_rep_item_vals
VehicleOwnerTotIncomeRep_View.prototype.updateValue = function(vehId, itemId, period, val, balanceValues){
	this.updateValueInit();
	if(vehId && itemId && period){
		var key = vehId.toString() + itemId.toString() + period.toString();
		this.m_updateValues["values"][key] = {
			"vehicle_id":vehId,
			"item_id":itemId,
			"period": period,
			"val": val
		};	
	}
	this.m_updateValues.balance_values = balanceValues;
	this.updateValueStartTimer();	
}

//Обновление vehicle_tot_rep_item_vals
VehicleOwnerTotIncomeRep_View.prototype.updateCommonValue = function(period, val, balanceValues){
	this.updateValueInit();
	var key = period.toString();
	this.m_updateValues.common_values[key] = {
		"period": period,
		"vehicle_owner_id": this.m_vehicleOwner_id,
		"val": val
	};
	this.m_updateValues.balance_values = balanceValues;
	this.updateValueStartTimer();	
}

VehicleOwnerTotIncomeRep_View.prototype.cmdApplyFilter = function(){
	if(!this.isFilterValid()){
		return;
	}
	
	var vehicle_owner_ctrl = this.getElement("vehicle_owner");
	vehicle_owner_ctrl.setValid();
	var owner_ref = this.getElement("vehicle_owner").getValue();
	this.m_vehicleOwner_id = owner_ref.getKey();
	
	window.setGlobalWait(true);
	this.setTemplateContent("");
	var self = this;
	
	var from = this.getElement("date_from").getDateFrom();
	var to = this.getElement("date_to").getDateFrom();
	var pm = (new VehicleOwner_Controller()).getPublicMethod("get_tot_income_report");
	pm.setFieldValue("date_from", from);
	pm.setFieldValue("date_to", to);	
	pm.setFieldValue("vehicle_owner_id", this.m_vehicleOwner_id);	
	
	pm.run({
		"ok":function(resp){
			self.cmdApplyFilterCont(resp, from, to);
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	})
}

