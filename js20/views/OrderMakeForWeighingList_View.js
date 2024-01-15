/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderMakeForWeighingList_View(id,options){	

	options.templateOptions = options.templateOptions || {};	

	options.className = "row";
	this.m_refreshMethod = (new Order_Controller()).getPublicMethod("get_make_orders_for_weighing_form");

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

	//date set
	var init_dt,cond_date;
	if(options.models&&options.models.InitDate&&options.models.InitDate.getNextRow()){			
		var d_s = options.models.InitDate.getFieldValue("dt");
		init_dt = DateHelper.strtotime(d_s);
	}
	
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
		
		//сканирование
		this.addElement(new RawMaterialTicketClose_View(id+":ticket_close",{
			"model":options.models.RawMaterialTicketCarrierAggList_Model,
			"listView":this
		}));			
		
		/*
		this.addElement(new CementSiloForOrderList_View(id+":production_sites",{
			"model":options.models.CementSiloForOrderList_Model,
			"listView":this
		}));		
		this.addElement(new MaterialStoreForOrderList_View(id+":material_stores",{
			"model":options.models.MaterialStoreForOrderList_Model,
			"listView":this
		}));			
		//material totals
		var model = options.models.MatTotals_Model;
		this.addElement(new MaterialMakeOrderGrid(id+":mat_totals_grid",{
			"model":model,
			"className":this.TABLE_CLASS
		}));
		*/
		//material totals + production_sites + material_stores
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
			//production sites
			var m_id = "CementSiloForOrderList" + base_id + "_Model";
			if(!options.models[m_id]){
				throw new Error("Model " + m_id + " not found!");
			}
			this.addElement(new CementSiloForOrderList_View(id+":production_sites" + base_id,{
				"model": new CementSiloForOrderList_Model({"data" : options.models[m_id].getData()}),
				"listView":this
			}));
			
			var m_id = "MaterialStoreForOrderList" + base_id + "_Model";
			if(!options.models[m_id]){
				throw new Error("Model " + m_id + " not found!");
			}
			this.addElement(new MaterialStoreForOrderList_View(id+":material_stores" + base_id,{
				"model": new MaterialStoreForOrderList_Model({"data" : options.models[m_id].getData()}),
				"listView":this
			}));			
		}		
		
		//orders
		var per_select = new EditPeriodShift(id+":order_make_filter",{
			"template":window.getApp().getTemplate( ((window.getWidthType()=="sm")? "EditPeriodShiftSM":"EditPeriodShift") ),
			"dateFrom":init_dt,
			"onChange":function(dateTime){
				window.setGlobalWait(true);
				self.refresh(function(){
					window.setGlobalWait(false);
				}, true);
			}
		});
		this.addElement(per_select);	
		var grid = new OrderMakeGrid(id+":order_make_grid",{
			"model":options.models.OrderMakeList_Model,
			"periodSelect":per_select,
			"className":"table-bordered table-responsive table-make_order order_make_grid",
			"listView":this,
			"stepMin":constants.order_step_min.getValue(),
			"shiftStart":constants.first_shift_start_time.getValue(),
			"shiftLength":constants.shift_length_time.getValue()
		});
		this.addElement(grid);
		
	}
	
	//,"params":{"cond_date":cond_date}
	options.srvEvents = {
		"events":[
			{"id":"Graph.change"}
			,{"id":"RAMaterialFact.change"}
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
	
	OrderMakeForWeighingList_View.superclass.constructor.call(this,id,options);	
		
}
extend(OrderMakeForWeighingList_View,View);

OrderMakeForWeighingList_View.prototype.TABLE_CLASS = "table-bordered table-responsive table-striped table-make_order";
OrderMakeForWeighingList_View.prototype.COL_CLIENT_LEN = 20;
OrderMakeForWeighingList_View.prototype.COL_DEST_LEN = 10;
OrderMakeForWeighingList_View.prototype.COL_COMMENT_LEN = 15;
OrderMakeForWeighingList_View.prototype.COL_DESCR_LEN = 15;
OrderMakeForWeighingList_View.prototype.COL_DRIVER_LEN = 10;
OrderMakeForWeighingList_View.prototype.COL_PUMP_VEH_LEN = 10;

OrderMakeForWeighingList_View.prototype.FORCE_REFRESH_INTERVAL = 30*60*1000;

OrderMakeForWeighingList_View.prototype.m_startShiftMS;
OrderMakeForWeighingList_View.prototype.m_endShiftMS;


OrderMakeForWeighingList_View.prototype.setRefreshInterval = function(v){
	if(this.m_refreshInterval == v){
		return;
	}
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
OrderMakeForWeighingList_View.prototype.refresh = function(callBack){
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

OrderMakeForWeighingList_View.prototype.toDOM = function(p){
	
	OrderMakeForWeighingList_View.superclass.toDOM.call(this,p);
	
	if(!window.getApp().getAppSrv()){
		this.setRefreshInterval(this.m_httpRefreshInterval);
	}
	
	window.getApp().addCollapseOnClick();
	window.getApp().initViewPanels(this);
	
	this.getElement("ticket_close").getElement("barcode").focus();
}

OrderMakeForWeighingList_View.prototype.delDOM = function(){
	if (this.m_refreshTimer!=undefined){		
		window.clearInterval(this.m_refreshTimer);
	}
	OrderMakeForWeighingList_View.superclass.delDOM.call(this);
	
}
 
OrderMakeForWeighingList_View.prototype.onRefreshResponse = function(resp){
	/*
	if(resp.modelExists("CementSiloForOrderList_Model")){
		this.getElement("production_sites").setData(resp.getModel("CementSiloForOrderList_Model"));
	}
	if(resp.modelExists("MaterialStoreForOrderList_Model")){
		this.getElement("material_stores").setData(resp.getModel("MaterialStoreForOrderList_Model"));
	}	
	//mat totals
	if(resp.modelExists("MatTotals_Model")){
		var grid = this.getElement("mat_totals_grid");
		grid.getModel().setData(resp.getModelData("MatTotals_Model"));
		grid.onGetData();
	}
	*/
	//cement + stors + mat total
	for(var i = 0; i < this.m_prodBaseList.length; i++){
		var base_id = this.m_prodBaseList[i].productionBaseId;
		if(resp.modelExists("CementSiloForOrderList" + base_id + "_Model")){
			this.getElement("production_sites" + base_id).setData(resp.getModel("CementSiloForOrderList" + base_id + "_Model"));
		}
		if(resp.modelExists("MaterialStoreForOrderList" + base_id + "_Model")){
			this.getElement("material_stores" + base_id).setData(resp.getModel("MaterialStoreForOrderList" + base_id + "_Model"));
		}
		if(resp.modelExists("MatTotals" + base_id + "_Model")){
			var grid = this.getElement("mat_totals_grid" + base_id);
			grid.getModel().setData(resp.getModelData("MatTotals" + base_id + "_Model"));
			grid.onGetData();
		}		
	}

	if(resp.modelExists("RawMaterialTicketCarrierAggList_Model")){
		var grid = this.getElement("ticket_close").getElement("grid");
		grid.getModel().setData(resp.getModelData("RawMaterialTicketCarrierAggList_Model"));
		grid.onGetData();
	}	
	
	if(resp.modelExists("OrderMakeList_Model")){
		var grid = this.getElement("order_make_grid");
		grid.getModel().setData(resp.getModelData("OrderMakeList_Model"));
		grid.onGetData();
	}	
	
}

OrderMakeForWeighingList_View.prototype.runSpecificUpdateMethod = function(meth){
	var pm = (new Order_Controller()).getPublicMethod(meth);
	pm.setFieldValue("date", (new FieldDateTime("d",{"value": DateHelper.time()})).getValueXHR());
	var self = this;
	pm.run({
		"ok":function(resp){
			self.onRefreshResponse(resp);
		}
	});
}

OrderMakeForWeighingList_View.prototype.srvEventsCallBack = function(json){
	if(json.controllerId=="RAMaterialFact" || json.controllerId=="Production"){
		this.runSpecificUpdateMethod("get_make_orders_for_weighing_form");
	}
}

