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
VehicleOwnerTotIncomeRep_View.prototype.ERR_DATE = "Неверое значение";

VehicleOwnerTotIncomeRep_View.prototype.isFilterValid = function(){
	var res = true;	
	var owner_ref = this.getElement("vehicle_owner").getValue();
	if(!owner_ref || owner_ref.isNull()){
		this.getElement("vehicle_owner").setNotValid("Не задан владелец");
		res = false;
	}else{
		this.getElement("vehicle_owner").setValid();
	}
	//check date
	var from_ctrl = this.getElement("date_from");
	var from = from_ctrl.getDateFrom();
	if(!DateHelper.isValidDate(from)){
		from_ctrl.setNotValid(this.ERR_DATE);
		res = false;
	}
	var to_ctrl = this.getElement("date_to");
	var to = to_ctrl.getDateFrom();
	if(!DateHelper.isValidDate(to)){
		to_ctrl.setNotValid(this.ERR_DATE);
		res = false;
	}
	if(from.getTime() > to.getTime()){
		from_ctrl.setNotValid(this.ERR_DATE);
		to_ctrl.setNotValid(this.ERR_DATE);
		res = false;
	}
	from_ctrl.setValid();
	to_ctrl.setValid();
	
		
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
			new FieldBool("item_info"),			
			new FieldDate("period"),
			new FieldFloat("val"),
			new FieldInt("runs"),
			new FieldInt("self_runs"),
			new FieldFloat("avg_quant"),
			new FieldInt("avg_runs"),
			new FieldFloat("balance_beg"),
			new FieldInt("work_day_count")
		],
		"data":resp.getModelData("VehicleOwnerTotIncomeReport_Model")
	});

	//id, code, name, is_income
	var m_common = new VehicleTotRepCommonItemList_Model({
		"data":resp.getModelData("VehicleTotRepCommonItemList_Model")
	});

	var m_common_vals = new ModelXML("VehicleTotRepCommonItemValList_Model", {
		"fields":[
			new FieldInt("item_id"),
			new FieldString("item_name"),
			new FieldDate("period"),
			new FieldBool("is_income"),
			new FieldFloat("value")
		],
		"data":resp.getModelData("VehicleTotRepCommonItemValList_Model")
	});
	var common_vals = {}; //indexed	
	while(m_common_vals.getNextRow()){
		var item_id = m_common_vals.getFieldValue("item_id") + this.COMMON_ITEM_ID_OFFSET;
		var period = m_common_vals.getFieldValue("period");
		var ind = item_id.toString() + period.getMonth().toString() + period.getFullYear().toString();
		common_vals[ind] = m_common_vals.getFieldValue("value");
	}

	stat_vals = {"periods":{},"vehicles":{},"items":{}, "val_total":0, "self_run_total":0, "run_total":0, "quant_avg_total":0.0};
	var period_count = 0;
	var vehicle_count = 0;
	this.m_balance_beg = 0;
	
	while(m.getNextRow()){
		var id = m.getFieldValue("veh_id");
		var period_mon = m.getFieldValue("period");
		this.m_balance_beg = m.getFieldValue("balance_beg");
		
		if(!stat_vals.periods[period_mon]){
			stat_vals.periods[period_mon] = {"vehicles":{}, "period": period_mon};
			period_count++;
		}
		
		if(!stat_vals.vehicles[id]){
			stat_vals.vehicles[id] = {"runs":0, "quant_avg":0, "runs_self":0, "runs_avg":0.0};
			vehicle_count++;
		}
		
		if(!stat_vals.periods[period_mon].vehicles[id]){
			var runs = m.getFieldValue("runs");
			var runs_avg = Math.round(runs / m.getFieldValue("work_day_count") *100)/100;
			var quant_avg = m.getFieldValue("avg_quant");
			var runs_self = m.getFieldValue("self_runs");
			
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
	
	//Следующий месяц
	var to_descr = new Date(to.getTime());
	tmpl_opts.PERIOD_TO = DateHelper.format(new Date(to_descr.setMonth(to_descr.getMonth()+1)), "FF Y");
	
	var tmpl = window.getApp().getTemplate("VehicleOwnerTotIncomeRep_View");
	
	var per_ind = {} //period indexes		
	
	var old_veh_id, old_item_id = 0;
	var cur_veh, cur_row;
	m.reset();
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
				"VAL_TOTAL": this.formatFloatValue(0),
				"TOTAL_TABLE": false,
				"NOT_TOTAL_TABLE": true				
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
					"VAL": this.formatFloatValue(0)
				});				
				cur_veh.PERIOD_RUNS.push({
					"VAL": 0
				});				
				cur_veh.PERIOD_AVG_RUNS.push({
					"VAL_N": 0,
					"VAL": 0
				});				
				cur_veh.PERIOD_AVG_QUANT.push({
					"VAL_N": 0,
					"VAL": 0
				});				
				cur_veh.PERIOD_SELF_RUNS.push({
					"VAL_N": 0,
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
			var item_info = m.getFieldValue("item_info");
			
			cur_row = {
				"ITEM_NAME": item_name,
				"ITEM_ID": item_id,
				"ITEM_CLASS": item_class,
				"ITEM_INPUT": item_input,
				"ITEM_INFO": item_info, //Это статья 
				"NOT_COMMON_ITEM": true,
				"PERIODS": [],
				"VAL_TOTAL_N": 0,
				"VAL_TOTAL": this.formatFloatValue(0)
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
					"ITEM_INFO": item_info, //Это итог 
					"NOT_COMMON_ITEM": true,
					"ITEM_CLASS": item_class + " veh_owner_tot_income_totals",
					"PERIODS": new Array(period_count),
					"VAL_TOTAL_N": 0,
					"VAL_TOTAL": this.formatFloatValue(0),
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
		
		stat_vals.period_totals[per_ind_v].VAL_N += val; // * val_k
		stat_vals.period_totals[per_ind_v].VAL = this.formatFloatValue(stat_vals.period_totals[per_ind_v].VAL_N);
		stat_vals.val_total += val; // * val_k
		
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
		
		cur_veh.VAL_TOTAL_N = cur_veh.VAL_TOTAL_N + val;// * val_k
		cur_veh.VAL_TOTAL = this.formatFloatValue(cur_veh.VAL_TOTAL_N);
		
		cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N = cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N + val;// * val_k
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
		"VAL_TOTAL_N": stat_vals.val_total,
		"TOTAL_TABLE": true,
		"NOT_TOTAL_TABLE": false
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
				var val_tot = 0;
				for(p in stat_vals.periods){
					var period = stat_vals.periods[p].period;					
					var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];
					periods[per_ind_v] = {
						"VAL_N":0,
						"VAL":this.formatFloatValue(0),
						"ITEM_ID":item_id,
						"VEH_ID":undefined,
						"PERIOD":DateHelper.format(period, "Y-m-d")
					};
					var ind = item_id.toString() + period.getMonth().toString() + period.getFullYear().toString();
					if(common_vals[ind]){
						periods[per_ind_v].VAL = this.formatFloatValue(common_vals[ind]);
						val_tot+= common_vals[ind];
						
						cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N = cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N + common_vals[ind];
						cur_veh.PERIOD_TOTALS[per_ind_v].VAL = this.formatFloatValue(cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N);
						
						stat_vals.val_total+= common_vals[ind];
						cur_veh.VAL_TOTAL_N+= common_vals[ind];
						cur_veh.VAL_TOTAL = this.formatFloatValue(cur_veh.VAL_TOTAL_N);
					}					
				}				
				cur_veh.ROWS.push({
					"ITEM_NAME": m_common.getFieldValue("name"),
					"ITEM_ID": item_id,
					"ITEM_INPUT": false,
					"NOT_COMMON_ITEM": false,
					"COMMON_ITEM":true,
					"ITEM_CLASS": "veh_owner_tot_income_income veh_owner_tot_income_totals",
					"PERIODS": periods,
					"VAL_TOTAL_N": val_tot,
					"VAL_TOTAL": this.formatFloatValue(val_tot)
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
		var val_tot = 0;
		for(p in stat_vals.periods){
			var period = stat_vals.periods[p].period;
			var per_ind_v = per_ind[period.getMonth().toString() + period.getFullYear().toString()];			
			periods[per_ind_v] = {
				"VAL_N":0	,
				"ITEM_ID":item_id,
				"VEH_ID":undefined,
				"PERIOD":DateHelper.format(period, "Y-m-d")
			};
			var ind = item_id.toString() + period.getMonth().toString() + period.getFullYear().toString();
			if(common_vals[ind]){
				periods[per_ind_v].VAL = this.formatFloatValue(common_vals[ind]);
				val_tot+= common_vals[ind];
				
				cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N = cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N + common_vals[ind];
				cur_veh.PERIOD_TOTALS[per_ind_v].VAL = this.formatFloatValue(cur_veh.PERIOD_TOTALS[per_ind_v].VAL_N);
				stat_vals.val_total+= common_vals[ind];
				cur_veh.VAL_TOTAL_N+= common_vals[ind];
				cur_veh.VAL_TOTAL = this.formatFloatValue(cur_veh.VAL_TOTAL_N);
			}			
		}	
		cur_veh.ROWS.push({
			"ITEM_NAME": m_common.getFieldValue("name"),
			"ITEM_ID": item_id,
			"ITEM_INPUT": false,
			"NOT_COMMON_ITEM": false,			
			"COMMON_ITEM":true,
			"ITEM_CLASS": "veh_owner_tot_income_outcome veh_owner_tot_income_totals",
			"PERIODS": periods,
			"VAL_TOTAL_N": -val_tot,//расход
			"VAL_TOTAL": this.formatFloatValue(val_tot)
		});			
	} while(m_common.getNextRow());
	
	tmpl_opts.VEHICLES.push(cur_veh); //итоги
	tmpl_opts.BALANCE_END = this.formatFloatValue(this.m_balance_beg + stat_vals.val_total );
	
	Mustache.parse(tmpl);
	this.setTemplateContent(Mustache.render(tmpl, tmpl_opts));
	
	//update end balances
	this.updateValue(undefined, undefined, undefined, 0, this.getBalanceValues(1));
	this.updateBalanceEnd(this.getTotalTable());

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
		var row = DOMHelper.getParentByTagName(inputs[i], "tr");
		var el = new EditString(null, {
			"cmdClear":false,
			"editContClassName": window.getBsCol(12),
			"value": t,
			"enabled": ed,
			"title": title,
			"className": ("form-control " + (is_in? "moneyEditable" : "moneyEditableNeg")),
			"events":{
				"input": !ed? null : (function(vehId, itemId, period, rowInd, cellIndex, tableNode){
					return function(e){
						self.updateTotals(tableNode, rowInd, cellIndex);
						self.updateTotalTable(tableNode, rowInd, cellIndex, itemId);
						var v = self.parseFloatValue(this.getValue());
						if(v > 0 && DOMHelper.hasClass(this.m_node, "moneyEditableNeg")){
							v = v * -1;
						}
						self.updateValue(vehId, itemId, period, v, self.getBalanceValues(cellIndex));
					}
				})(parseInt(inputs[i].getAttribute("vehicle_id"), 10),
					parseInt(inputs[i].getAttribute("item_id"), 10),
					inputs[i].getAttribute("period"),
					row.rowIndex - 1,
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
		
		var row_index = DOMHelper.getParentByTagName(inputs[i], "tr").rowIndex - 1;		
		var cell_index = inputs[i].cellIndex;
		var item_id = parseInt(inputs[i].getAttribute("item_id"), 10);
		var period = inputs[i].getAttribute("period");
		
		var el = new EditString(null, {
			"cmdClear":false,
			"editContClassName": window.getBsCol(12),
			"value": t,
			"title":title,
			"className": ("form-control " + (is_in? "moneyEditable" : "moneyEditableNeg")),
			"events":{
				"input": (function(itemId, period, rowIndex, cellIndex){
					return function(e){
						var tot_table = self.getTotalTable();
						self.updateTotals(tot_table, rowIndex, cellIndex);
						self.updateBalanceEnd(tot_table);
						var v = self.parseFloatValue(this.getValue());
						if(v > 0 && DOMHelper.hasClass(this.m_node, "moneyEditableNeg")){
							v = v * -1;
						}
						self.updateCommonValue(itemId, period, v, self.getBalanceValues(cellIndex));
					}
				})(item_id,
					period,
					row_index,
					cell_index
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
	var bal = this.m_balance_beg;
	var tot_cells = tfeet[0].rows[0].cells;	
	
	for(var col = fromCellIndex; col < tot_cells.length - 1; col++){ //периоды = со второй по предпоследнюю
		var p = DateHelper.strtotime(tbody[0].rows[0].cells[col].getAttribute("period"));
		if(!DateHelper.isValidDate(p)){
			throw new Error('Not valid date');
		}
		for(var body_r = 0; body_r < tbody[0].rows.length; body_r++){
			if(DOMHelper.hasClass(tbody[0].rows[body_r].cells[col], "veh_owner_tot_income_info")){
				continue;//skeep
			}
			var sn = 1;
			if(DOMHelper.hasClass(tbody[0].rows[body_r].cells[col], "veh_owner_tot_income_outcome")){
				sn = -1;
			}
			var item_v = this.getNodeFloatValue(tbody[0].rows[body_r].cells[col]) * sn;
			bal+= item_v;
		}
		p = DateHelper.monthEnd(p);
		p.setDate(p.getDate() + 1);
		balance_values[DateHelper.format(p, "Y-m-d")] =  bal;
	}
/*		
	for(var col = fromCellIndex; col < tot_cells.length - 1; col++){ //периоды = со второй по предпоследнюю
		var p = DateHelper.strtotime(tbody[0].rows[0].cells[col].getAttribute("period"));
		if(!DateHelper.isValidDate(p)){
			throw new Error('Not valid date');
		}
		//Надо отнять информационные статьи за период (эта же колонка)
		var item_info_tot = 0;
		for(var body_r = 0; body_r < tbody[0].rows.length; body_r++){
			if(DOMHelper.hasClass(tbody[0].rows[body_r].cells[col], "veh_owner_tot_income_info")){
				var sn = 1;
				if(DOMHelper.hasClass(tbody[0].rows[body_r].cells[col], "veh_owner_tot_income_outcome")){
					sn = -1;
				}
				var item_v = this.getNodeFloatValue(tbody[0].rows[body_r].cells[col]) * sn;
				item_info_tot+= item_v;
			}			
		}
		p = DateHelper.monthEnd(p);
		p.setDate(p.getDate() + 1);
console.log(item_info_tot)		
		bal+= (this.getNodeFloatValue(tot_cells[col]) - item_info_tot);//
		balance_values[DateHelper.format(p, "Y-m-d")] =  bal;
	}
*/	
	return balance_values;	
}

VehicleOwnerTotIncomeRep_View.prototype.updateValueCont = function(callBack){
	var pm = (new VehicleTotRepItemValue_Controller()).getPublicMethod("update_values");
	pm.setFieldValue("values", CommonHelper.serialize(this.m_updateValues["values"]));
	pm.setFieldValue("common_values", CommonHelper.serialize(this.m_updateValues.common_values));	
	pm.setFieldValue("balance_vehicle_owner_id", this.m_updateValues.balance_vehicle_owner_id);
	pm.setFieldValue("balance_values", CommonHelper.serialize(this.m_updateValues.balance_values));
	pm.run({
		"ok":function(){
			if(callBack){
				callBack();
			}
		}
	});
	this.m_updateValuesTimeoutID = undefined;
	this.m_updateValues = undefined;
}

VehicleOwnerTotIncomeRep_View.prototype.formatFloatValue = function(number){
	return CommonHelper.numberFormat(number, 2, this.MONEY_DECIMAL_DELIMETER, this.MONEY_THOUSAND_DELIMETER);
}

VehicleOwnerTotIncomeRep_View.prototype.parseFloatValue = function(valueForParse){
	if(!valueForParse){
		return 0.0;
	}
	return parseFloat(valueForParse.replaceAll(this.MONEY_THOUSAND_DELIMETER, "").replaceAll(this.MONEY_DECIMAL_DELIMETER, "."));
}

//Trturns num without sign
VehicleOwnerTotIncomeRep_View.prototype.getNodeFloatValue = function(node){
	//var f = (!node||!node.value)? 0 : parseFloat(node.value.replaceAll(this.MONEY_THOUSAND_DELIMETER, "").replaceAll(this.MONEY_DECIMAL_DELIMETER, "."));
	//check input
	var inputs = node.getElementsByTagName("input");
	if(inputs && inputs.length){
		node = inputs[0];
	}
	var f = 0;
	if(node && node.rawValue!= undefined){
		f = node.rawValue;
		
	}else {
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

VehicleOwnerTotIncomeRep_View.prototype.setTotalValue = function(node, val){
	//no input tag here
	node.textContent = this.formatFloatValue(val);
}

VehicleOwnerTotIncomeRep_View.prototype.setInputValue = function(node, val){
	var inputs = node.getElementsByTagName("input");
	if(inputs && inputs.length){
		inputs[0].value = this.formatFloatValue(val);
	}	
}

//Итог по тек строке, заносим в тек строку, последнюю колонку
VehicleOwnerTotIncomeRep_View.prototype.setRowTotal = function(tbody, rowInd, k){
	var row_tot = 0;
	for(var c = 0; c < tbody.rows[rowInd].cells.length - 1; c++){ //пропустить послднюю
		row_tot+= this.getNodeFloatValue(tbody.rows[rowInd].cells[c]);
	}
	
	this.setTotalValue(tbody.rows[rowInd].cells[tbody.rows[rowInd].cells.length-1], row_tot * k);
}


//Итог по колонке в футер. Это итог по статьям (+/-), надо учесть знак
VehicleOwnerTotIncomeRep_View.prototype.setColTotal = function(tbody, tfoot, colInd){
	var col_tot = 0;
	for(var r = 0; r < tbody.rows.length; r++){
		var k = DOMHelper.hasClass(tbody.rows[r].cells[colInd], "veh_owner_tot_income_outcome")? -1 : 1;
		col_tot+= this.getNodeFloatValue(tbody.rows[r].cells[colInd]) * k;
	}	
	
	this.setTotalValue(tfoot.rows[0].cells[colInd], col_tot);
}

//Расчет итогов при изменении значения статьи
//1) Считаем итог по колонке: строки 0 ... КолСтрок, в той же колонке, берем число с учетом знака.
//	складываем в первую строку футера, в туже колонку, знак ставим у четом +-
//2) Считаем итог по тек.строке: колонки с 1 (0- статья) ... Последняя-1 (Последняя - всего в нее складываем).
//	считаем просто сумму по модулю, без знака. Кладем с учетом знака
//3) Считаем Итог по строке всего
VehicleOwnerTotIncomeRep_View.prototype.updateTotals = function(table, rowInd, colInd){
	var tbodies = table.getElementsByTagName('tbody');
	if(!tbodies || !tbodies.length){
		return;
	}
	var tbody = tbodies[0];
	
	var tfeet = table.getElementsByTagName('tfoot');
	if(!tfeet || !tfeet.length){
		return;
	}
	var tfoot = tfeet[0];
	
	var k = DOMHelper.hasClass(tbody.rows[rowInd].cells[colInd], "veh_owner_tot_income_outcome")? -1 : 1;
	
	//1)
	this.setColTotal(tbody, tfoot, colInd, k);
	
	//2)
	this.setRowTotal(tbody, rowInd, k);
	
	//3)
	this.setColTotal(tbody, tfoot, tbody.rows[rowInd].cells.length-1, 1);
}

VehicleOwnerTotIncomeRep_View.prototype.getTotalTable = function(){
	var tot_tables = DOMHelper.getElementsByAttr("veh_owner_tot_income_total_table", this.getNode(), "class", false);
	if(!tot_tables || !tot_tables.length){
		return;
	}
	return tot_tables[0];	
}

//Расчет итоговой таблицы
//Возьмем эту же ячейку во всех таблицах, кроме итоговой, все сложим по модулю,
//результат запишем в ячейку итоговой таблицы, которую найдем по item_id
//Пересчитаем итоги по итоговой таблице
VehicleOwnerTotIncomeRep_View.prototype.updateTotalTable = function(table, rowInd, colInd, itemId){
	var tbodies = table.getElementsByTagName('tbody');
	if(!tbodies || !tbodies.length){
		return;
	}
	var tbody = tbodies[0];
	var k = DOMHelper.hasClass(tbody.rows[rowInd].cells[colInd], "veh_owner_tot_income_outcome")? -1 : 1;
	
	var tot_table = this.getTotalTable();
	var tot_table_tbodies = tot_table.getElementsByTagName('tbody');
	if(!tot_table_tbodies || !tot_table_tbodies.length){
		return;
	}		
	
	var vh_tables = DOMHelper.getElementsByAttr("veh_owner_tot_income_veh_table", this.getNode(), "class", false);
	var item_tot = 0;
	for(var t = 0; t < vh_tables.length; t++){
		var vh_tbodies = vh_tables[t].getElementsByTagName('tbody');
		if(!vh_tbodies || !vh_tbodies.length){
			continue;
		}		
		item_tot+= this.getNodeFloatValue(vh_tbodies[0].rows[rowInd].cells[colInd]);
	}
	
	//Найдем строку, куда занести значение по item_id
	var tot_table_row = -1;
	for(var r = 0; r < tot_table_tbodies[0].rows.length; r++){
		if(tot_table_tbodies[0].rows[r].cells[colInd].getAttribute("item_id") == itemId){
			tot_table_row = r;			
			break;
		}
	}
	if(tot_table_row >= 0 ){
		this.setInputValue(tot_table_tbodies[0].rows[r].cells[colInd], item_tot * k);
		this.updateTotals(tot_table, r, colInd);
		this.updateBalanceEnd(tot_table);
	}
}

VehicleOwnerTotIncomeRep_View.prototype.updateBalanceEnd = function(totTable){
	var tot_table_tfeet = totTable.getElementsByTagName('tfoot');
	if(!tot_table_tfeet || !tot_table_tfeet.length){
		return;
	}		
	//var turn_over = this.getNodeFloatValue(tot_table_tfeet[0].rows[0].cells[tot_table_tfeet[0].rows[0].cells.length-1]);
	//отнять информационные статьи
	var turn_over = 0; //Собираем уже без учета инф статей
	var tbody = totTable.getElementsByTagName('tbody');							
	var item_info_tot = 0;
	for(var body_r = 0; body_r < tbody[0].rows.length; body_r++){
		for(var body_c = 1; body_c < tbody[0].rows[body_r].cells.length-1; body_c++){
			if(!DOMHelper.hasClass(tbody[0].rows[body_r].cells[body_c], "veh_owner_tot_income_info")){
				var sn = 1;
				if(DOMHelper.hasClass(tbody[0].rows[body_r].cells[body_c], "veh_owner_tot_income_outcome")){
					sn = -1;
				}
				var item_v = this.getNodeFloatValue(tbody[0].rows[body_r].cells[body_c]) * sn;
				turn_over+= item_v;
			}			
		}
	}
	document.getElementById("VehicleOwnerTotIncomeRep:balance_end").value = this.formatFloatValue(this.m_balance_beg + turn_over);			
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
VehicleOwnerTotIncomeRep_View.prototype.updateCommonValue = function(itemId, period, val, balanceValues){
	itemId = itemId - this.COMMON_ITEM_ID_OFFSET;
	this.updateValueInit();
	var key = period.toString();
	var key = itemId.toString() + period.toString();
	this.m_updateValues.common_values[key] = {
		"period": period,
		"item_id":itemId,
		"val": val
	};
	this.m_updateValues.balance_values = balanceValues;
	this.updateValueStartTimer();	
}

VehicleOwnerTotIncomeRep_View.prototype.cmdApplyFilterSaved = function(){
	var vehicle_owner_ctrl = this.getElement("vehicle_owner");
	vehicle_owner_ctrl.setValid();
	var owner_ref = this.getElement("vehicle_owner").getValue();
	var owner_id = owner_ref.getKey();
	
	window.setGlobalWait(true);
	this.setTemplateContent("");
	var self = this;
	
	var from = this.getElement("date_from").getDateFrom();
	var to = this.getElement("date_to").getDateFrom();
	var pm = (new VehicleOwner_Controller()).getPublicMethod("get_tot_income_report");
	pm.setFieldValue("date_from", from);
	pm.setFieldValue("date_to", to);	
	pm.setFieldValue("vehicle_owner_id", owner_id);	
	
	pm.run({
		"ok":function(resp){
			self.cmdApplyFilterCont(resp, from, to);
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	})	
}

VehicleOwnerTotIncomeRep_View.prototype.cmdApplyFilter = function(){
	if(!this.isFilterValid()){
		return;
	}
	
	if(this.m_updateValuesTimeoutID){
		var self = this;
		clearTimeout(this.m_updateValuesTimeoutID);
		this.updateValueCont(function(){
			self.cmdApplyFilterSaved();
		});
	}else{
		this.cmdApplyFilterSaved();
	}
}

