/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 *
 * @param {int} options.periodKey
 * @param {string} options.periodValueType
 */
function PeriodValueList_View(id,options){	

	PeriodValueList_View.superclass.constructor.call(this,id,options);

	var model = (options.models && options.models.PeriodValue_Model)? options.models.PeriodValue_Model : new PeriodValue_Model();
	var contr = new PeriodValue_Controller();
	
	var filtered = false;
	if(options.periodOptions){		
		filtered = true;
		var key = (typeof(options.periodOptions.key)=="function")? options.periodOptions.key() : options.periodOptions.key;
		contr.getPublicMethod("update").setFieldValue("key", key);
		contr.getPublicMethod("update").setFieldValue("period_value_type", options.periodOptions.valueType);
		contr.getPublicMethod("insert").setFieldValue("key", key);
		contr.getPublicMethod("insert").setFieldValue("period_value_type", options.periodOptions.valueType);
	}else{
		options.periodOptions = {};
	}
	
	options.periodOptions.gridClass = options.periodOptions.gridClass || GridColumn;
	options.periodOptions.ctrlClass = options.periodOptions.ctrlClass || EditString;
	options.periodOptions.ctrlOptions = options.periodOptions.ctrlOptions || {};
	
	options.periodOptions.gridOptions = options.periodOptions.gridOptions || {};
	options.periodOptions.gridOptions.field = model.getField("val");
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	

	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"field":new FieldDateTime("date_time")
	});
	
	var filters = filtered? null:{
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
		,"period_value_type": filtered? null : {
			"binding":new CommandBinding({
				"control":new Enum_period_value_types(id+":filter-ctrl-period_value_type",{
					"labelCaption":"Вид значения:"
				}),
				"field":new FieldString("period_value_type")}),
			"sign":"e"		
		}
	}	
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters":filters
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						filtered? null : new GridCellHead(id+":grid:head:period_value_type",{
							"value":"Вид значений",
							"columns":[
								new EnumGridColumn_period_value_types({
									"field":model.getField("period_value_type")
								})
							]
						})
						,filtered? null : new GridCellHead(id+":grid:head:key",{
							"value":"Ключ",
							"columns":[
								new GridColumn({
									"field":model.getField("key")
								})
							]
						})
					
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
								})
							]
						})
						,new GridCellHead(id+":grid:head:val",{
							"value":"Значение",
							"columns":[
								new options.periodOptions.gridClass(options.periodOptions.gridOptions)
							]
						})						
					]
				})
			]
		}),
		"pagination":filtered? null : new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh": filtered,
		"refreshInterval":filtered? 0 : constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true,
		"filters":filtered? [
				{"field":"period_value_type", "sign":"e", "val":options.periodOptions.valueType}
				,{"field":"key", "sign":"e", "val":key}
				] : null
	}));	
	
}
extend(PeriodValueList_View,ViewAjx);
