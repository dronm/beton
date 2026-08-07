/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function RepVehicleFuelFlow_View(id,options){

	options = options || {};
	
	var contr = new Vehicle_Controller();	
	options.publicMethod = contr.getPublicMethod("fuel_report");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "RepVehicleFuelFlow";
	
	options.cmdMake = true;
	options.cmdPrint = true;
	options.cmdFilter = false;
	options.cmdExcel = true;
	options.cmdPdf = false;
	
	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"valueFrom":(options.templateParams)? options.templateParams.date_from:DateHelper.getStartOfShift(DateHelper.time()),
		"valueTo":(options.templateParams)? options.templateParams.date_to:DateHelper.getEndOfShift(DateHelper.time()),
		"field":new FieldDateTime("date_time"),
		"cmdUpFast":false,
		"cmdDownFast":false,
		"periodSelectOptions":{"periodShift":true, "value": "shift"}
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
				"control":new VehicleEdit(id+":filter-ctrl-vehicle",{"labelCaption":"ТС:","contClassName":"form-group-filter"}),
				"field":new FieldInt("vehicle_id")
			}),
			"sign":"e"
		}
	};

	this.m_filter = new ModelFilter({"filters":options.filters});	

	options.openFilterOnInit = false;
	options.addElement = function(){
		this.addElement(new GridCmdFilterView(id+":filter_view",{
			"filter":this.m_filter,
			"cmdSet":false,
			"cmdUnset":false
		}));	
	}

	RepVehicleFuelFlow_View.superclass.constructor.call(this, id, options);
	
	// period_ctrl.getControlPeriodSelect().setValue("shift");
}
extend(RepVehicleFuelFlow_View,ViewReport);

RepVehicleFuelFlow_View.prototype.fillParams = function(){	
	var pm = this.getPublicMethod();
	try{
		this.m_filter.applyFiltersToPublicMethod(pm);
	}
	catch(e){
		throw Error(e.message);
	}
}

