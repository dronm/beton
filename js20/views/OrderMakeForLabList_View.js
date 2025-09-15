/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderMakeForLabList_View(id,options){	

	options.templateOptions = options.templateOptions || {};	

	options.className = "row";
	this.m_refreshMethod = (new Order_Controller()).getPublicMethod("get_make_orders_for_lab_form");

	var self = this;
	
	var constants = {
		"order_grid_refresh_interval":null,
		"first_shift_start_time":null,
		"day_shift_length":null,
		"order_step_min":null,
		"shift_length_time":"null"
	};
	window.getApp().getConstantManager().get(constants);

	//this.m_refreshInterval = constants.order_grid_refresh_interval.getValue()*1000;

	var st_time = constants.first_shift_start_time.getValue();
	var st_time_parts = st_time.split(":");
	var from_h=0,to_h=0;
	if(st_time_parts&&st_time_parts.length){
		from_h = parseInt(st_time_parts[0],10);
	}
	to_h = from_h + parseInt(constants.day_shift_length.getValue(),10);
	this.m_startShiftMS = DateHelper.timeToMS(st_time);
	this.m_endShiftMS = DateHelper.timeToMS((to_h-1).toString()+":59:59");

	
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.workHours = from_h+"-"+to_h;
	
	//prodution bases
	this.m_prodBaseList = [];	
	if(options.models&&options.models.ProductionBase_Model){			
		while(options.models.ProductionBase_Model.getNextRow()){
			this.m_prodBaseList.push({
				"productionBaseId": options.models.ProductionBase_Model.getFieldValue("id")
				,"productionBaseName": options.models.ProductionBase_Model.getFieldValue("name")
			})
		}
	}
	options.templateOptions.productionBases = this.m_prodBaseList;
	
	options.addElement = function(){
		
		var init_dt;
		if(options.models&&options.models.InitDate&&options.models.InitDate.getNextRow()){
			init_dt = DateHelper.strtotime(options.models.InitDate.getFieldValue("dt"));
		}
		
		var per_select = new EditPeriodShift(id+":order_make_filter",{
			"template":window.getApp().getTemplate( ((window.getWidthType()=="sm")? "EditPeriodShiftSM":"EditPeriodShift") ),
			"dateFrom":init_dt,
			"onChange":function(dateTime){
				var refr_inv = self.m_refreshInterval;
				self.setRefreshInterval(0);
				
				self.m_refreshMethod.setFieldValue("date",dateTime);
				window.setGlobalWait(true);
				
				var lab_v = self.getElement("lab_entry_grid");
				var lab_grid = lab_v.getElement("grid")
				lab_grid.setFilter(lab_v.getPeriodFilterFrom(dateTime));
				lab_grid.setFilter(lab_v.getPeriodFilterTo(dateTime));
				lab_grid.onRefresh();
				
				self.refresh(function(){
					window.setGlobalWait(false);
					self.setRefreshInterval(refr_inv);
				});
			}
		});
		this.addElement(per_select);	
			
		//orders
		var model = options.models.OrderMakeForLabList_Model;
		var grid = new OrderMakeGrid(id+":order_make_grid",{
			//edit comment
			"editViewClass":OrderMakeForLabDialog_View,
			"editWinClass":WindowFormModalBS,
			"editWinOptions":{
				"dialogWidth":"30%"
			},
			"model":options.models.OrderMakeForLabList_Model,
			"className":"table-bordered table-responsive table-make_order order_make_grid",
			"periodSelect":per_select,
			"listView":this,
			"stepMin":constants.order_step_min.getValue(),
			"shiftStart":constants.first_shift_start_time.getValue(),
			"shiftLength":constants.shift_length_time.getValue()
		});
		this.addElement(grid);
		grid.onRefresh = function(){
			self.refresh();
		}
		
		//assigning
		
		this.addElement(new AssignedVehicleList_View(id+":veh_assigning",{
			"models":options.models,
			"shortDescriptions":true,
			"noAutoRefresh":true
		}));
		
		for(var i = 0; i < this.m_prodBaseList.length; i++){
			var base_id = this.m_prodBaseList[i].productionBaseId;
			var m_id = "MatTotals" + base_id + "_Model";
			if(!options.models[m_id]){
				throw new Error("Model " + m_id + " not found!");
			}
			this.addElement(new MaterialMakeOrderGrid(id+":mat_totals_grid" + base_id,{
				"model": new MatTotals_Model({"data" : options.models[m_id].getData()}),
				"className":this.TABLE_CLASS,
				"refresh":function(){
					self.refresh();
				}
			}));
			var m_id = "MaterialStoreForOrderList" + base_id + "_Model";
			if(!options.models[m_id]){
				throw new Error("Model " + m_id + " not found!");
			}				
			this.addElement(new MaterialStoreForOrderList_View(id+":material_stores" + base_id,{
				"model": new MaterialStoreForOrderList_Model({"data" : options.models[m_id].getData()}),
				"listView":this
			}));			
			
			var m_id = "CementSiloForOrderList" + base_id + "_Model";
			if(!options.models[m_id]){
				throw new Error("Model " + m_id + " not found!");
			}				
			this.addElement(new CementSiloForOrderList_View(id+":production_sites" + base_id,{				
				"model": new CementSiloForOrderList_Model({"data" : options.models[m_id].getData()}),
				"listView":this,
				"baseId": base_id
			}));			
		}		
		
		//vehicles
		this.addElement(new VehicleScheduleMakeOrderGrid(id+":veh_schedule_grid",{"model":options.models.VehicleScheduleMakeOrderList_Model}));		
		
		//lab entities 30 days => Журнал испытания образцов
		//Там свой запрос
		this.addElement(new LabEntryList_View(id+":lab_entry_grid",{
			"listView":this
			,"dateTime": init_dt
		}));
		
		//Форма оператора		
		this.addElement(
			new OperatorList_View(id+":OperatorList_View",{
				"models":options.models,
				"fromLabList":true,
				"showProductionSites":false
			})
		);
				
	}
	
	//,"params":{"cond_date":cond_date}
	options.srvEvents = {
		"events":[
			{"id":"Graph.change"}
			,{"id":"VehicleScheduleState.insert"}
			,{"id":"VehicleScheduleState.update"}
			,{"id":"VehicleScheduleState.delete"}
			,{"id":"RAMaterialFact.change"}
			,{"id":"LabEntry.insert"}
			,{"id":"LabEntry.update"}
			,{"id":"LabEntry.delete"}
			,{"id": "Production.insert"}
			,{"id": "Production.update"}
			,{"id": "Production.delete"}
		]
		,"onWakeup": function(){
			self.refresh();
		}
		,"onEvent":function(json){
			self.srvEventsCallBack(json);
		}
		,"onSubscribed": function(){
			self.setRefreshInterval(self.FORCE_REFRESH_INTERVAL);
		}
		,"onClose": function(message){
			self.setRefreshInterval(self.m_httpRefreshInterval);
		}		
	}
	
	this.m_httpRefreshInterval = constants.order_grid_refresh_interval.getValue()*1000;
	
	OrderMakeForLabList_View.superclass.constructor.call(this,id,options);
		
}
extend(OrderMakeForLabList_View,View);

OrderMakeForLabList_View.prototype.TABLE_CLASS = "table-bordered table-responsive table-striped table-make_order";
OrderMakeForLabList_View.prototype.COL_CLIENT_LEN = 20;
OrderMakeForLabList_View.prototype.COL_DEST_LEN = 10;
OrderMakeForLabList_View.prototype.COL_COMMENT_LEN = 15;
OrderMakeForLabList_View.prototype.COL_DESCR_LEN = 15;
OrderMakeForLabList_View.prototype.COL_DRIVER_LEN = 10;
OrderMakeForLabList_View.prototype.COL_PUMP_VEH_LEN = 10;

OrderMakeForLabList_View.prototype.FORCE_REFRESH_INTERVAL = 30*60*1000;

OrderMakeForLabList_View.prototype.m_startShiftMS;
OrderMakeForLabList_View.prototype.m_endShiftMS;


OrderMakeForLabList_View.prototype.setRefreshInterval = function(v){
	if(this.m_refreshInterval == v){
		return;
	}
console.log("OrderMakeForLabList_View.prototype.setRefreshInterval v="+v)
	this.m_refreshInterval = v;
	if (this.m_refreshTimer!=undefined){		
		console.log("clearing timer")
		window.clearInterval(this.m_refreshTimer);
	}
	if (v>0){
		var self = this;
		this.m_refreshTimer = setInterval(function(){
			self.refresh();
		},v);
	}
}

/**
 * Все обновляется разом за один запрос из нескольких моделей
 */
OrderMakeForLabList_View.prototype.refresh = function(callBack){
	this.m_refreshMethod.setFieldValue("date",this.getElement("order_make_filter").getDateFrom());
	var self = this;
	
	this.m_refreshMethod.run({
		"ok":function(resp){					
			self.onRefreshResponse(resp);
			if(callBack){
				callBack();
			}
		}
	})
}

OrderMakeForLabList_View.prototype.toDOM = function(p){
	
	OrderMakeForLabList_View.superclass.toDOM.call(this,p);
	
	if(!window.getApp().getAppSrv()){
		this.setRefreshInterval(this.m_httpRefreshInterval);
	}

	window.getApp().addCollapseOnClick();	
	window.getApp().initViewPanels(this);
}

OrderMakeForLabList_View.prototype.delDOM = function(){
	if (this.m_refreshTimer!=undefined){		
		window.clearInterval(this.m_refreshTimer);
	}
	OrderMakeForLabList_View.superclass.delDOM.call(this);
	
}
 
OrderMakeForLabList_View.prototype.onRefreshResponse = function(resp){

	if(resp.modelExists("OrderMakeForLabList_Model")){
		var grid = this.getElement("order_make_grid");
		if(!grid.getLocked()){		
			grid.getModel().setData(resp.getModelData("OrderMakeForLabList_Model"));
			grid.onGetData();
		}
	}
	
	//cement + stors + mat total
	for(var i = 0; i < this.m_prodBaseList.length; i++){
		var base_id = this.m_prodBaseList[i].productionBaseId;
		if(this.m_showProductionSites && resp.modelExists("CementSiloForOrderList" + base_id + "_Model")){
			this.getElement("production_sites" + base_id).setData(resp.getModel("CementSiloForOrderList" + base_id + "_Model"));
		}		
		if(this.m_showProductionSites && resp.modelExists("MaterialStoreForOrderList" + base_id + "_Model")){
			this.getElement("material_stores" + base_id).setData(resp.getModel("MaterialStoreForOrderList" + base_id + "_Model"));
		}
		if(resp.modelExists("MatTotals" + base_id + "_Model")){
			var grid = this.getElement("mat_totals_grid" + base_id);
			grid.getModel().setData(resp.getModelData("MatTotals" + base_id + "_Model"));
			grid.onGetData();
		}				
	}
		
	//assigning
	if(resp.modelExists("AssignedVehicleList_Model")){
		this.getElement("veh_assigning").setData(resp.getModelData("AssignedVehicleList_Model"));
	}
		
	//vehicles
	if(resp.modelExists("VehicleScheduleMakeOrderList_Model")){
		var grid = this.getElement("veh_schedule_grid");
		grid.getModel().setData(resp.getModelData("VehicleScheduleMakeOrderList_Model"));
		grid.onGetData();
	}
	
	//operator list
	if(resp.modelExists("OperatorList_Model")){
		this.getElement("OperatorList_View").getElement("grid").onGetData(resp);
	}

}

OrderMakeForLabList_View.prototype.runSpecificUpdateMethod = function(meth, lsn){
	var pm = (new Order_Controller()).getPublicMethod(meth);
	pm.setFieldValue("date",this.getElement("order_make_filter").getDateFrom());
	if(lsn && pm.fieldExists("lsn")){
		pm.setFieldValue("lsn", lsn);
	}
	var self = this;
	pm.run({
		"ok":function(resp){
			self.onRefreshResponse(resp);
		}
	});
}

OrderMakeForLabList_View.prototype.srvEventsCallBack = function(json){
// console.log("OrderMakeForLabList_View.prototype.srvEventsCallBack",json)
	if(json.controllerId=="Graph"){
		//analyse cond_date!
		this.runSpecificUpdateMethod("get_make_orders_form_ord", (json.params && json.params.lsn)? json.params.lsn:null);
		
		this.getElement("OperatorList_View").getElement("grid").onRefresh();
		
	}
	else if(json.controllerId=="VehicleScheduleState"){
		this.runSpecificUpdateMethod("get_make_orders_for_lab_form_veh", (json.params && json.params.lsn)? json.params.lsn:null);
	}
	else if(json.controllerId=="RAMaterialFact"){
		this.runSpecificUpdateMethod("get_make_orders_for_lab_form_mat", (json.params && json.params.lsn)? json.params.lsn:null);
	}
	else if(json.controllerId=="Production"){
		this.getElement("OperatorList_View").getElement("grid").onRefresh();
	}
	
}

/*
OrderMakeForLabList_View.prototype.openLabEntryForm = function(concreteTypeId){
	var win_w = $( window ).width();
	var h = $( window ).height()-20;//win_w/3*2;
	var left = win_w/3;
	var w = win_w/3*2;//left - 20;
	
	var constants = {"lab_days_for_avg":null};
	window.getApp().getConstantManager().get(constants);
	
	var cur_d = DateHelper.time();
	var from_d = (new FieldDateTime("from",{"value":new Date(cur_d.getTime()-constants.lab_days_for_avg.getValue()*24*60*60*1000)})).getValueXHR();
	var to_d = (new FieldDateTime("to",{"value":cur_d})).getValueXHR();
	
	var filter = new VariantStorage_Model();
	filter.setFieldValue("user_id",0);
	filter.setFieldValue("storage_name","LabEntryList");
	filter.setFieldValue("variant_name","LabEntryList");
	filter.setFieldValue("filter_data",{
		"period":{
			"value":{"period":"all"},
			"bindings":[
				{"field":"start_time","sign":"ge","value":from_d}
				,{"field":"start_time","sign":"le","value":to_d}
			]
		},
		"concrete_type":{
			"field":"concrete_type_id","sign":"e","value":new RefType({"keys":{"id":concreteTypeId},"descr":""})
		}
	});
	filter.recInsert();
	filter.getRow(0);
	
	this.m_labForm = new WindowForm({
		"id":"labForm",
		"height":h,
		"width":w,
		"left":left,
		"top":10,
		"URLParams":"c=LabEntry_Controller&f=get_list&t=LabEntryList&v=Child&cond_fields=date_time,date_time,concrete_type_id&cond_sgns=ge,le,e&cond_vals="+from_d+","+to_d+","+concreteTypeId,
		"name":"labForm",
		"params":{
			"editViewOptions":{				
				"variantStorage":{
					"name":"LabEntryList",
					"model":filter
				}
			}
		},
		"onClose":function(){
			self.m_labForm.close();
			delete self.m_labForm;			
		}
	});
	this.m_labForm.open();
	
}
*/

