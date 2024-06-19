/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2020
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function RepMaterialAction_View(id,options){

	options = options || {};
	
	var contr = new RawMaterial_Controller();	
	options.publicMethod = contr.getPublicMethod("get_material_actions_list");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "RepMaterialAction";
	
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
		,"production_base":{
			"binding":new CommandBinding({
				"control":new ProductionBaseEdit(id+":filter-ctrl-production_base",{"labelCaption":"База:","contClassName":"form-group-filter"}),
				"field":new FieldInt("production_base_id")
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

	RepMaterialAction_View.superclass.constructor.call(this, id, options);
	
	// period_ctrl.getControlPeriodSelect().setValue("shift");
}
extend(RepMaterialAction_View,ViewReport);

RepMaterialAction_View.prototype.fillParams = function(){	
	var pm = this.getPublicMethod();
	try{
		this.m_filter.applyFiltersToPublicMethod(pm);
	}
	catch(e){
		throw Error(e.message);
	}
}
