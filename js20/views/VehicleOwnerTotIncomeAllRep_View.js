
function VehicleOwnerTotIncomeAllRep_View(id,options){

	options = options || {};
	
	var contr = new VehicleOwner_Controller();	
	options.publicMethod = contr.getPublicMethod("get_tot_income_report_all");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "VehicleOwnerTotIncomeAllRep";
	
	options.cmdMake = true;
	options.cmdPrint = true;
	options.cmdFilter = true;
	options.cmdExcel = true;
	options.cmdPdf = false;
	
	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"valueFrom":(options.templateParams)? options.templateParams.date_from:DateHelper.getStartOfShift(DateHelper.time()),
		"valueTo":(options.templateParams)? options.templateParams.date_to:DateHelper.getEndOfShift(DateHelper.time()),
		"field":new FieldDateTime("date_time")
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
	};

	VehicleOwnerTotIncomeAllRep_View.superclass.constructor.call(this, id, options);
	
}
extend(VehicleOwnerTotIncomeAllRep_View,ViewReport);
