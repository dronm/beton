/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 http://localhost/beton_new/?c=Driver_Controller&f=work_time_report&v=ViewXML&month_date=2026-04-24
 */
function DriverWorkTimeReport_View(id,options){
	options = options || {};	
	
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEAD_TITLE = "Табель водителей";

	const self = this;
	options.addElement = function(){
		// this.addElement(new EditDate(id+":month_date",{ }));	
		const init_dt = new Date();
		var per_select = new EditPeriodMonth(id+":month_date",{
			"dateFrom":init_dt,
			"onChange":function(dateTime){
				self.cmdBuildReport(dateTime);
			}
		});
		this.addElement(per_select);	

		this.addElement(new VehicleEdit(id+":vehicles_ref",{ 
			editContClassName: "input-group "+ window.getBsCol(4),
			labelClassName: "control-label "+ window.getBsCol(1),
		}));	
		this.addElement(new DriverEditRef(id+":drivers_ref",{ 
			editContClassName: "input-group "+ window.getBsCol(3),
			labelClassName: "control-label "+ window.getBsCol(1),
		}));	

		this.addElement(new ButtonCmd(id+":cmdBuildReport",{
			"caption":"Заполнить",
			"title":"Построить расписание за период",
			"onClick":function(){
				self.cmdBuildReport(self.getElement("month_date").getDateFrom());
			}
		}));	
	}

	DriverWorkTimeReport_View.superclass.constructor.call(this,id,options);

	this.cmdBuildReport(new Date());
}

extend(DriverWorkTimeReport_View,View);

DriverWorkTimeReport_View.prototype.cmdBuildReport = function(selectedDate){
	var pm = (new Driver_Controller()).getPublicMethod("work_time_report");
	pm.setFieldValue("month_date", selectedDate);

	const vehRef = this.getElement("vehicles_ref").getValue();
	if(!vehRef || vehRef.isNull()){
		pm.unsetFieldValue("vehicle_id");
	}else{
		pm.setFieldValue("vehicle_id", vehRef.getKey("id"));
	}

	const drRef = this.getElement("drivers_ref").getValue();
	if(!drRef || drRef.isNull()){
		pm.unsetFieldValue("driver_id");
	}else{
		pm.setFieldValue("driver_id", drRef.getKey("id"));
	}

	const self = this;
	window.setGlobalWait(true);

	DOMHelper.hide(this.getId()+":report-panel")
	this.setTemplateContent("");

	pm.run({
		"ok":function(resp){
			const data = resp.getModelData("WorkTimeReport_Model");
			self.showReport(data);
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	});
}
DriverWorkTimeReport_View.prototype.showReport = function(data){
	const model = new ModelXML("WorkTimeReport_Model", {
		"fields": [
			new FieldJSON("vehicles_ref"),
			new FieldJSON("drivers_ref"),
			new FieldJSON("time_data")
		],
		"data": data
	});

	const weekDays = ["вс", "пн", "вт", "ср", "чт", "пт", "сб"];

	const tmplOpts = {
		DAY_COUNT: 0,
		DAYS: [],
		ROWS: [],
		TOTALS: [],
		GRAND_TOTAL: 0
	};

	const dayTotals = [];

	while(model.getNextRow()){
		const vRef = model.getFieldValue("vehicles_ref");
		const drRef = model.getFieldValue("drivers_ref");

		let timeData = model.getFieldValue("time_data");

		if(typeof timeData === "string"){
			timeData = JSON.parse(timeData);
		}

		if(!Array.isArray(timeData)){
			timeData = [];
		}

		if(!tmplOpts.DAY_COUNT){
			tmplOpts.DAY_COUNT = timeData.length;

			for(let i = 0; i < timeData.length; i++){
				const dayParts = String(timeData[i].day).split("-");
				const dayN = dayParts[2];

				const dateObj = new Date(
					Number(dayParts[0]),
					Number(dayParts[1]) - 1,
					Number(dayParts[2])
				);

				const day = dateObj.getDay();

				tmplOpts.DAYS.push({
					DAY: dayN,
					DOW: weekDays[day],
					WEEKEND: Boolean(timeData[i].is_day_off)
				});

				dayTotals.push(0);
			}
		}

		const row = {
			VEHICLE: vRef ? vRef.getDescr() : "",
			DRIVER: drRef ? drRef.getDescr() : "",
			DAYS: [],
			HOUR_TOTAL: 0
		};

		for(let i = 0; i < timeData.length; i++){
			const hours = Number(timeData[i].hours || 0);

			row.DAYS.push({
				SHIFT: hours > 0,
				NO_SHIFT: hours === 0,
				WEEKEND: Boolean(timeData[i].is_day_off),
				HOURS: hours
			});

			row.HOUR_TOTAL += hours;
			tmplOpts.GRAND_TOTAL += hours;
			dayTotals[i] += hours;
		}

		tmplOpts.ROWS.push(row);
	}

	for(let i = 0; i < dayTotals.length; i++){
		const hours = dayTotals[i];

		tmplOpts.TOTALS.push({
			EXISTS: hours > 0,
			NOT_EXISTS: hours === 0,
			HOURS: hours
		});
	}

	const tmpl = window.getApp().getTemplate("DriverWorkTimeReport_View");
	Mustache.parse(tmpl);
	this.setTemplateContent(Mustache.render(tmpl, tmplOpts));
};

DriverWorkTimeReport_View.prototype.setTemplateContent = function(cont){
	var target_n = document.getElementById(this.getId() + ":report");
	if(!target_n){
		throw new Error("Report node not found");
	}
	target_n.innerHTML = cont;
	DOMHelper.show(this.getId()+":report-panel")
}
