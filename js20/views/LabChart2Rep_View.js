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
function LabChart2Rep_View(id,options){
	options = options || {};	

	options = options || {};
	
	var contr = new LabChart_Controller();	
	options.publicMethod = contr.getPublicMethod("get_lab_chart2");
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
		
	var chart_ctrl = new Control(id+":report:chart","canvas",{});
	options.reportControl = new ControlContainer(id+":report","DIV",{
		"elements":[
			new ControlContainer(id+":report:oks","DIV",{}),
			chart_ctrl			
		]
	});
		
	LabChart2Rep_View.superclass.constructor.call(this, id, options);
	
	chart_ctrl.getNode().height = 60;
	var ctx = chart_ctrl.getNode().getContext('2d');
	
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
				"text": "Зависимость ОК от p7,p28"
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
extend(LabChart2Rep_View, ViewReport);

/* Constants */
LabChart2Rep_View.prototype.P7_LIMIT_VAL = 80;
LabChart2Rep_View.prototype.P28_LIMIT_VAL = 100;

/* private members */

/* protected*/


/* public methods */

LabChart2Rep_View.prototype.rebuildLocal = function(){
	var data_sets = [];
	var oks = this.getReportControl().getElement("oks").getElements();
	data_sets.push(this.m_dataSets[0]);//0 = Граница
	for(var id in oks){
		if(oks[id] && oks[id].getValue()){						
			//0 = Граница
			data_sets.push(this.m_dataSets[parseInt(oks[id].getAttr("ok_ind"),10) + 1]);
		}
	}
	this.m_chart.data = {
		"labels": this.m_dates,
		"datasets": data_sets
	};
	this.m_chart.update();									
}

LabChart2Rep_View.prototype.onGetReportData = function(resp){
	var p_type = this.m_commands.getCmdFilter().getFilter().getFilter("p_type").binding.getControl().getValue();

	var m = new ModelXML("LabChart1_Model", {
		"data": resp.getModelData("LabChart1_Model"),
		"fields": {
			"dates":new FieldJSON("dates"),
			"vals":new FieldJSON("vals"),
			"oks":new FieldJSON("oks")
		}
	});
	var colors = window.getApp().getChartColors();		
	var limits = [];
	this.m_dataSets = [{}];//Limit!
	var self = this;
	this.m_dates = [];
	var vals = [];
	var oks_cont_ctrl = this.getReportControl().getElement("oks");
	var ok_ctrl_lb_class = "control-label "+window.getBsCol(1);
	oks_cont_ctrl.clear();
	if(m.getNextRow()){
		this.m_dates = m.getFieldValue("dates");		
		for(var i = 0; i< this.m_dates.length; i++){
			limits.push((p_type == "7")? this.P7_LIMIT_VAL : this.P28_LIMIT_VAL);
		}
		vals = m.getFieldValue("vals");		
		
		var oks = m.getFieldValue("oks");
		var val_colors = ["red", "orange", "yellow", "green","blue", "purple", "grey"];
		
		var color_p = 0;
		for(var i = 0; i < oks.length; i ++ ){			
			if (!vals["ok_"+oks[i]]){
				throw new Error("Значения для p="+oks[i]+" не найдены!");
			}
			
			//ok control for disabling
			oks_cont_ctrl.addElement(
				new EditCheckBox(this.getId()+"::report:oks:ok_"+i,{
					"labelClassName":ok_ctrl_lb_class,
					"labelAlign": "left",
					"checked":true,
					"labelCaption": "p"+p_type+" = " + oks[i],
					"attrs":{"ok_ind":i},
					"events":{
						"change":function(e){
							self.rebuildLocal();
						}
					}
				})	
			);
			
			this.m_dataSets.push(
				{"ok":oks[i],
				"label": "% Мпа p"+ p_type +"= "+oks[i],
			    	"data": vals["ok_"+oks[i]],
			    	"backgroundColor": colors[val_colors[color_p]],
			 	"borderColor": colors[val_colors[color_p]],
			   	"borderWidth":4,
			   	"fill":false
				}			
			);
			color_p +=1
			if(color_p==val_colors.length){
				color_p = 0;
			}
		}
		
		
	}

	this.m_dataSets[0] = {"label": "Граница",
	    	"data": limits,
	    	"backgroundColor":colors.red,
	 	"borderColor":colors.red,
	 	"borderDash":[5, 5],
	   	"borderWidth":3,
	   	"fill":false
	};

	this.m_chart.data = {
		"labels": this.m_dates,
		"datasets":this.m_dataSets
	};
	this.m_chart.update();		
	oks_cont_ctrl.toDOM();
}

