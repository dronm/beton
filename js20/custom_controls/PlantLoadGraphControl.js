/* Copyright (c) 2019-2024
 *	Andrey Mikhalevich, Katren ltd.
 */
 
function PlantLoadGraphControl(id,options){	
	PlantLoadGraphControl.superclass.constructor.call(this,id,"canvas",options);
	
	this.getNode().height = 60;
	var ctx = this.getNode().getContext('2d');

	var constants = {"chart_step_quant":null,"chart_max_quant":null};
	window.getApp().getConstantManager().get(constants);
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
				"text": "Выполнение заявок"
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
						"labelString":"Время, ч."
					},
					"gridLines":{
						"color":"rgba(0, 0, 0, 0)",
					}					
				}],
				"yAxes":[{
					"display": true,
					"ticks":{
						"min": 0,
		    				"max": constants.chart_max_quant.getValue(),
		    				"stepSize":constants.chart_step_quant.getValue()
					},					
					"scaleLabel":{
						"display": true,
						"labelString":"Объём, м3"
					},
					"gridLines":{
						"color":"rgba(0, 0, 0, 0)"
					}										
				}]
			}
		}	    
	});
		
	this.setModel(options.model);
}
extend(PlantLoadGraphControl,Control);

PlantLoadGraphControl.prototype.setModel = function(model){
//console.log("PlantLoadGraphControl.prototype.setModel")
	if (model.getNextRow()){
		//this.setAttr("src","data:image/png;base64,"+model.getFieldValue("pic"));
		var chart_data_s = model.getFieldValue("chart_data");
		if(this.m_chartDataPrevStr && this.m_chartDataPrevStr==chart_data_s)return;
		
		this.m_chartDataPrevStr = chart_data_s;
		var chart_data = CommonHelper.unserialize(chart_data_s);
		
		var colors = window.getApp().getChartColors();
		this.m_chart.data = {
			"labels":chart_data.times,
			"datasets":[
				{"label": "Макс.загрузка",
			    	"data":chart_data.norm,
			    	"backgroundColor":colors.red,//colors.red "#E5E5E5"
			 	"borderColor":colors.red,//colors.red
			 	"borderDash":[5, 5],
			   	"borderWidth":3,
			   	"fill":false
				}
				,{"label": "Отгрузки",
			    	"data":chart_data.shipments,
			    	"backgroundColor":colors.yellow,//colors.yellow "#E7411B"
			 	"borderColor":colors.yellow,
			   	"borderWidth":4,
			   	"fill":false //true
				}
				
				,{"label": "Заявки",
			    	"data":chart_data.orders,
			    	"backgroundColor":colors.green,//colors.green "#38383E"
			 	"borderColor":colors.green,//"#38383E"
			   	"borderWidth":4,
			   	"fill":false //true
				}
			]
		};
		this.m_chart.update();		
	}
}

PlantLoadGraphControl.prototype.clearGraph = function(){
	//this.setAttr("src","");
}
