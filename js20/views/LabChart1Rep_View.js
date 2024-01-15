/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends ViewReport
 * @requires core/extend.js
 * @requires controls/ViewReport.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function LabChart1Rep_View(id,options){
	options = options || {};	

	options = options || {};
	
	var contr = new LabChart_Controller();	
	options.publicMethod = contr.getPublicMethod("get_lab_chart1");
	options.reportViewId = "ViewXML";
	//options.templateId = "LabEntryReport";
	
	options.cmdMake = true;
	options.cmdPrint = false;
	options.cmdFilter = true;
	options.cmdExcel = false;
	options.cmdPdf = false;
	
	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"field":new FieldDate("date_time")
	});
	
	var bs_col = window.getApp().getBsCol();	
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
		,"production_site":{
			"binding":new CommandBinding({
				"control":new ProductionSiteEdit(id+":filter-ctrl-production_site",{"labelCaption":"Завод:","contClassName":"form-group-filter"}),
				"field":new FieldInt("production_site_id")
			}),
			"sign":"e"
		}
		
		,"concrete_type":{
			"binding":new CommandBinding({
				"control":new ConcreteTypeEdit(id+":filter-ctrl-concrete_type",{"labelCaption":"Марка:","contClassName":"form-group-filter"}),
				"field":new FieldInt("concrete_type_id")
			}),
			"sign":"e"
		}
		,"p_type":{
			"binding":new CommandBinding({
				"control":new EditRadioGroup(id+":p_val",{
					"elements": [
						new EditRadio(id+":p_val:p7",{
							"checked": true
							,"name":"p_type"
							,"value":"7"
							,"labelCaption": "p7"
							,"labelClassName" : "control-label "+bs_col+"1"
						})
						,new EditRadio(id+":p_val:p28",{
							"name":"p_type"
							,"value":"28"
							,"labelCaption": "p28"
							,"labelClassName" : "control-label "+bs_col+"1"
						})
					]
				}),
				"field":new FieldInt("p_type")
			}),
			"sign":"e"
		}
		
	};
		
	options.reportControl = new Control(id+":report","canvas",{});
		
	LabChart1Rep_View.superclass.constructor.call(this, id, options);
	
	options.reportControl.getNode().height = 60;
	var ctx = options.reportControl.getNode().getContext('2d');
	
	this.m_chart = new Chart(ctx, {
		"type":"line",
		"options": {
			"responsive": true,
			"elements":{
				"point":{
					"radius": 0
				}
			},			
			"title": {
				"display": false,
				"text": "% МПа от времени"
			},
			"tooltips": {
				"mode": "index",
				"intersect": false
			},
			"hover": {
				"mode":"nearest",
				"intersect":true
			},
			"scales": {
				"xAxes":[{
					"display": true,
					"scaleLabel":{
						"display":false,
						"labelString":"Дни"
					},
					"gridLines":{
						"color":"rgba(0, 0, 0, 0)",
					}					
				}],
				"yAxes":[{
					"display": true,
					"ticks":{
						"min": 50,
		    				"max": 120,
		    				"stepSize":5
					},					
					"scaleLabel":{
						"display": true,
						"labelString":"ОК"
					},
					"gridLines":{
						"color":"rgba(0, 0, 0, 0)"
					}										
				}]
			}
		}	    
	});	
}

//ViewObjectAjx,ViewAjxList
extend(LabChart1Rep_View, ViewReport);

/* Constants */
LabChart1Rep_View.prototype.P7_LIMIT_VAL = 80;
LabChart1Rep_View.prototype.P28_LIMIT_VAL = 100;

/* private members */

/* protected*/


/* public methods */

LabChart1Rep_View.prototype.onGetReportData = function(resp){
	var p_type = this.m_commands.getCmdFilter().getFilter().getFilter("p_type").binding.getControl().getValue();

	var m = new ModelXML("LabChart1_Model", {
		"data": resp.getModelData("LabChart1_Model"),
		"fields": {
			"dates":new FieldJSON("dates"),
			"vals":new FieldJSON("vals")
		}
	});
	var dates = [];
	var vals = [];
	var limits = [];
	if(m.getNextRow()){
		dates = m.getFieldValue("dates");
		vals = m.getFieldValue("vals");
		var v_val = (p_type == "7")? this.P7_LIMIT_VAL : this.P28_LIMIT_VAL;
		for(var i = 0; i < vals.length; i ++ ){
			limits.push(v_val);
		}
	}
	var colors = window.getApp().getChartColors();		
	this.m_chart.data = {
		"labels": dates,
		"datasets":[
			{"label": "Граница",
		    	"data": limits,
		    	"backgroundColor":colors.red,
		 	"borderColor":colors.red,
		 	"borderDash":[5, 5],
		   	"borderWidth":3,
		   	"fill":false
			}		
			,{"label": "% Мпа p"+ p_type +" по дням",
		    	"data": vals,
		    	"backgroundColor":colors.green,//colors.yellow "#E7411B"
		 	"borderColor":colors.green,
		   	"borderWidth":4,
		   	"fill":false //true
			}
		]
	};
	this.m_chart.update();		
	
}

