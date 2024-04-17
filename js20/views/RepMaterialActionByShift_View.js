/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function RepMaterialActionByShift_View(id,options){

	options = options || {};
	
	var contr = new RawMaterial_Controller();	
	options.publicMethod = contr.getPublicMethod("get_material_actions_by_shift_list");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "RepMaterialActionByShift";
	
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
		,"material":{
			"binding":new CommandBinding({
				"control":new MaterialSelect(id+":filter-ctrl-material",{"labelCaption":"Материал:","contClassName":"form-group-filter"}),
				"field":new FieldInt("material_id")
			}),
			"sign":"e"
		}
	};

	RepMaterialActionByShift_View.superclass.constructor.call(this, id, options);
	
}
extend(RepMaterialActionByShift_View,ViewReport);


