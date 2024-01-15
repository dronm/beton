/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2019
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function VehicleScheduleReportAll_View(id,options){

	options = options || {};
	
	options.publicMethod = (new VehicleSchedule_Controller()).getPublicMethod("get_schedule_report_all");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "VehicleScheduleReportAll";
	
	options.cmdMake = true;
	options.cmdPrint = true;
	options.cmdFilter = true;
	options.cmdExcel = true;
	options.cmdPdf = false;
	
	var period_ctrl = new EditPeriodDate(id+":filter-ctrl-period",{
		"field":new FieldDate("date")
	});
	
	options.filters = {
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
		,"vehicle":{
			"binding":new CommandBinding({
				"control":new VehicleEdit(id+":filter-ctrl-vehicle",{"contClassName":"form-group-filter"}),
				"field":new FieldInt("vehicle_id")
			}),
			"sign":"e"
		}
	};

	VehicleScheduleReportAll_View.superclass.constructor.call(this, id, options);
	
}
extend(VehicleScheduleReportAll_View,ViewReport);


VehicleScheduleReportAll_View.prototype.onGetReportData = function(respText){
	VehicleScheduleReportAll_View.superclass.onGetReportData.call(this, respText);	
	
	var self = this;
	$(".on_shift").click(function(e){
		self.changeProdBaseClick(e.target);		
		e.stopPropagation();
	});
	
}

//выбор производственнй базы

VehicleScheduleReportAll_View.prototype.changeProdBase = function(forDate, callback){
	(new WindowFormModalBS(this.getId()+":changePBase", {
		"contentHead": "База на " + DateHelper.format(forDate, "d/m/Y"),
		"content":new View(this.getId()+":changePBase:v", {
			"elements":[
				new ProductionBaseEdit(this.getId()+":changePBase:v:prod_base",{
					"required":true,
					"focus":true
				})	
			]
		}),
		"onClickOk":function(){
			var view = this.getContent();
			if(!view.validate()){
				return;
			}
			callback(view.getElement("prod_base").getValue());
			this.close();			
		},
		"cmdCancel":true
	})).open();
}

VehicleScheduleReportAll_View.prototype.changeProdBaseClick = function(changeNode){
	var self = this;
	var schedule_date = DateHelper.strtotime(changeNode.getAttribute("dt"));			
	this.changeProdBase(schedule_date, function(changeRef){
		var vehicle_id = changeNode.getAttribute("vehicle_id");
		var driver_id = changeNode.getAttribute("driver_id");						
		self.setSchedule(
			[schedule_date],
			[vehicle_id],
			driver_id,
			changeRef.getKey(),
			true,
			function(){
				changeNode.setAttribute("prod_base_id", changeRef.getKey());
				changeNode.setAttribute("title", changeRef.getDescr());
				changeNode.textContent = changeRef.getDescr();
			}
		);				
	});		
}

VehicleScheduleReportAll_View.prototype.setSchedule = function(scheduleDates, vehicles, driverId, prodBaseId, isShift, callback){
	var vehiles_pm = [];//{"vehicle_id":VH_ID, "days":[{"date":DATE, "shift":true, "driver_id":DRIVER_ID}]}	
	for(var i = 0; i < vehicles.length; i++){
		var days = [];
		for(var n = 0; n < scheduleDates.length; n++){
			days.push({
				"date": DateHelper.format(scheduleDates[n], "Y-m-d"),
				"shift": isShift,
				"driver_id": driverId,
				"prod_base_id": prodBaseId
			});
		}
		vehiles_pm.push({
			"vehicle_id": vehicles[i],
			"days": days
		});
	}
	this.setScheduleServerCall(vehiles_pm, callback);	
}

VehicleScheduleReportAll_View.prototype.setScheduleServerCall = function(vehicles, callback){
	if(!vehicles.length){
		if(callback)callback();
		return;
	}
	var pm = (new VehicleSchedule_Controller()).getPublicMethod("set_schedule");
	pm.setFieldValue("vehicles", CommonHelper.serialize(vehicles));
	pm.run({
		"ok":function(){
			if(callback){
				callback();
			}
		}
	});
	//console.log("setScheduleServerCall vehicles=", vehicles)
	//if(callback)callback();
}

