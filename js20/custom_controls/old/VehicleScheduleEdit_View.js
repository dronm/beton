/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options

 http://localhost/beton_new/?c=VehicleSchedule_Controller&f=get_vehicle_owner_schedule&v=ViewXML&date_from=2023-07-01&date_to=2023-07-31&vehicle_owner_id=10
 */
function VehicleScheduleEdit_View(id,options){
	options = options || {};	
	
	var role_id = window.getApp().getServVar("role_id");
	
	var self = this;
	options.addElement = function(){
		if(role_id!="vehicle_owner"){
			this.addElement(new VehicleOwnerEdit(id+":vehicle_owner",{
			}));	
		}
		this.addElement(new EditPeriodDate(id+":period",{
		}));	

		this.addElement(new DriverEdit(id+":tmpl_driver",{
		}));	

		this.addElement(new ButtonCmd(id+":cmdApplyTemplate",{
			"caption":"Применить шаблон",
			"title":"Применить шаблон на выбранные транспортные средства",
			"onClick":function(){
				self.cmdApplyTemplate();
			}
		}));	

		this.addElement(new ButtonCmd(id+":cmdApplyDriver",{
			"caption":"Установить водителя",
			"title":"Установить выбранного водителя для выбраных транспортных средств в рабочие смены.",
			"onClick":function(){
				self.cmdApplyDriver();
			}
		}));	

		this.addElement(new ButtonCmd(id+":cmdApplyFilter",{
			"caption":"Заполнить",
			"title":"Построить расписание по выбранному владельцу за период",
			"onClick":function(){
				self.cmdApplyFilter();
			}
		}));	
	
	}

	VehicleScheduleEdit_View.superclass.constructor.call(this,id,options);
	
	//events
	$(".owner_schedule_day_tmpl").click(function(e){
		self.switchTmplDay(e.target);
	});
		
	
}

extend(VehicleScheduleEdit_View,View);

VehicleScheduleEdit_View.prototype.DRIVER_SHORT_CHAR_COUNT = 5;

VehicleScheduleEdit_View.prototype.cmdApplyTemplateCont = function(nodes){
	var drv_ref = this.getElement("tmpl_driver").getValue();
	for(var i = 0; i < nodes.length; i ++ ){
		var drv_nodes = DOMHelper.getElementsByAttr("owner_schedule_driver", nodes[i].node, "class", true);
		if(drv_nodes && drv_nodes.length){
			DOMHelper.delNode(drv_nodes[0]);
		}
	
		if(nodes[i].shift){
			DOMHelper.addClass(nodes[i].node, "owner_schedule_shift");
			this.addDriverNode(nodes[i].node, drv_ref);
		}else{
			if(nodes[i].weekend){
				DOMHelper.addClass(nodes[i].node, "owner_schedule_weekend");
			}
			DOMHelper.delClass(nodes[i].node, "owner_schedule_shift");
		}
	}
}

VehicleScheduleEdit_View.prototype.cmdApplyTemplate = function(){
	var vehicles = [];
	var all_nodes = [];
	var self = this;
	$(".owner_schedule_vehicle_mark").each(function(index) {
		if(this.checked){
			var days = [];				
			var driver_id;
			var nodes = DOMHelper.getElementsByAttr("owner_schedule_day", this.parentNode.parentNode, "class", false);
			for(var i = 0; i < nodes.length; i ++ ){
				var dt = nodes[i].getAttribute("dt");
				var day = DateHelper.strtotime(dt).getDay();
				if(day == 0){
					day = 7;
				}
				var is_shift = $(document.getElementById(self.getId() + ":tmpl:day" + day)).hasClass("owner_schedule_shift");
				if(is_shift && !driver_id){
					//drive MUST be
					var drv_ref = self.getElement("tmpl_driver").getValue();
					if(!drv_ref || drv_ref.isNull()){
						self.getElement("tmpl_driver").setNotValid("Не выбран");
						throw new Error("Необходимо выбрать водителя");
					}
					self.getElement("tmpl_driver").setValid();
					driver_id = drv_ref.getKey("id");
				}
				days.push({
					"date": dt,
					"shift": is_shift,
					"driver_id": is_shift? driver_id:0
				});
				all_nodes.push({
					"node": nodes[i],
					"shift":is_shift,
					"weekend":(day>=6)
				});
				
			}
			vehicles.push({
				"vehicle_id":this.parentNode.parentNode.getAttribute("vehicle_id"),
				"days": days
			});
		}
	});		
	this.setScheduleServerCall(vehicles, function(){
		self.cmdApplyTemplateCont(all_nodes);
	});		
}

VehicleScheduleEdit_View.prototype.cmdApplyDriverCont = function(dNodes, drvRef){
	for(i = 0; i < dNodes.length; i++){
		dNodes[i].setAttribute("driver_id", drvRef.getKey());
		dNodes[i].setAttribute("title", drvRef.getDescr());
		dNodes[i].textContent = drvRef.getDescr().substring(0, this.DRIVER_SHORT_CHAR_COUNT);					
	}
}

VehicleScheduleEdit_View.prototype.cmdApplyDriver = function(){
	var drv_ref = this.getElement("tmpl_driver").getValue();
	if(!drv_ref || drv_ref.isNull()){
		this.getElement("tmpl_driver").setNotValid("Не выбран");
		return;
	}
	this.getElement("tmpl_driver").setValid();
	
	var driver_id = drv_ref.getKey();
	var d_nodes = [];//driver nodes
	var vehicles = [];//array of objects {"vehicle_id":VH_ID, "days":[{"date":DATE, "shift":true, "driver_id":DRIVER_ID}]}	
	$(".owner_schedule_vehicle_mark").each(function(index) {
		if(this.checked){				
			var add_vh = false;
			var days = [];
			var nodes = DOMHelper.getElementsByAttr("owner_schedule_day", this.parentNode.parentNode, "class", false);
			for(var i = 0; i < nodes.length; i ++ ){
				if($(nodes[i]).hasClass("owner_schedule_shift")){
					var drv_nodes = DOMHelper.getElementsByAttr("owner_schedule_driver", nodes[i], "class", true);
					if(drv_nodes && drv_nodes.length){
						d_nodes.push(drv_nodes[0]);
						days.push({
							"date": nodes[i].getAttribute("dt"),
							"shift": true,
							"driver_id": driver_id
						});
						add_vh = true;
					}
				}
			}
			if(add_vh){
				vehicles.push({
					"vehicle_id":this.parentNode.parentNode.getAttribute("vehicle_id"),
					"days": days
				});
			}
		}
	});
	
	var self = this;
	this.setScheduleServerCall(vehicles, function(){
		self.cmdApplyDriverCont(d_nodes, drv_ref)
	});	
}

VehicleScheduleEdit_View.prototype.markAll = function(n){
	$(".owner_schedule_vehicle_mark").each(function(index) {
		this.checked = n.checked;
	});
}

VehicleScheduleEdit_View.prototype.changeDriver = function(forDate, callback){
	(new WindowFormModalBS(this.getId()+":changeDr", {
		"contentHead": "Водитель на " + DateHelper.format(forDate, "d/m/Y"),
		"content":new View(this.getId()+":changeDr:v", {
			"elements":[
				new DriverEdit(this.getId()+":changeDr:v:driver",{
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
			callback(view.getElement("driver").getValue());
			this.close();			
		},
		"cmdCancel":true
	})).open();
}

VehicleScheduleEdit_View.prototype.addDriverNode = function(n, drvRef){
	var self = this;
	var drv_tag = document.createElement("SPAN");
	drv_tag.setAttribute("class", "owner_schedule_driver");
	drv_tag.setAttribute("driver_id", drvRef.getKey("id"));
	drv_tag.setAttribute("title", drvRef.getDescr());
	drv_tag.textContent = drvRef.getDescr().substring(0, this.DRIVER_SHORT_CHAR_COUNT);
	n.appendChild(drv_tag);
	
	//event
	EventHelper.add(drv_tag, "click", function(e){
		self.changeDriverClick(e.target);		
		e.stopPropagation();
	});
	return drv_tag;	
}

VehicleScheduleEdit_View.prototype.markDayOnNode = function(n){
	var schedule_date = DateHelper.strtotime(n.getAttribute("dt"));
	var is_busy = !$(n).hasClass("owner_schedule_shift");
	var vehicle_id = n.parentNode.getAttribute("vehicle_id");
	if(!is_busy){
		this.setSchedule(
			[schedule_date],
			[vehicle_id],
			0,
			false,
			function(){
				$(n).removeClass("owner_schedule_shift");
				var day = schedule_date.getDay();
				if(day == 0 || day == 6){
					$(n).addClass("owner_schedule_weekend");
				}
				$(n).find(".owner_schedule_driver").eq(0).remove();			
			}
		);
		
	}else{
		var drv_n = $(n).find(".owner_schedule_driver").eq(0);
		var driver_id = drv_n.attr("driver_id");
		var drv_ref;
		if(!driver_id){
			//tempate driver
			drv_ref = this.getElement("tmpl_driver").getValue();
			if(drv_ref && !drv_ref.isNull()){
				driver_id = drv_ref.getKey("id");
			}
		}else{
			drv_ref = new RefType({"key":{"id": driver_id}, "descr": drv_n.attr("title")});
		}
		if(driver_id){
			var self = this;
			this.setSchedule(
				[schedule_date],
				[vehicle_id],
				driver_id,
				true,
				function(){
					self.addDriverNode(n, drv_ref);
					$(n).addClass("owner_schedule_shift");
					$(n).removeClass("owner_schedule_weekend");
				}
			);
		}else{
			//select driver
			var self = this;
			this.changeDriver(schedule_date, function(drvRef){				
				self.setSchedule(
					[schedule_date],
					[vehicle_id],
					drvRef.getKey(),
					true,
					function(){
						self.addDriverNode(n, drvRef);
						$(n).addClass("owner_schedule_shift");
						$(n).removeClass("owner_schedule_weekend");
					}
				);
			});
		}
	}	
}

VehicleScheduleEdit_View.prototype.changeDriverClick = function(drvNode){
	var self = this;
	var n = drvNode.parentNode;
	var schedule_date = DateHelper.strtotime(n.getAttribute("dt"));			
	this.changeDriver(schedule_date, function(drvRef){
		if($(n.parentNode).find(".owner_schedule_vehicle_mark").first().get()[0].checked){
			//multy vehicle mode
			var vehicles = [];
			var d_nodes = [];
			var is_busy = !$(n).hasClass("owner_schedule_shift");
			//get all other checked vehices					
			$(".owner_schedule_vehicle_mark").each(function(index) {
				if(this.checked){				
					var nodes = DOMHelper.getElementsByAttr(n.getAttribute("dt"), this.parentNode.parentNode, "dt", true);
					if(!nodes || !nodes.length){
						throw new Error("element with dt tag not found");
					}					
					var drv_nodes = DOMHelper.getElementsByAttr("owner_schedule_driver", nodes[0], "class", true);
					if(!drv_nodes || !drv_nodes.length){
						//Может быть при групповом добавлении, если у кого-то нет водителя
						drv_nodes = [self.addDriverNode(d_nodes[0], drvRef)];
					}					
					d_nodes.push(drv_nodes[0]);
					vehicles.push(nodes[0].parentNode.getAttribute("vehicle_id"));
				}
			});
			self.setSchedule(
				[schedule_date],
				vehicles,
				drvRef.getKey(),
				is_busy,
				function(){
					for(i = 0; i < d_nodes.length; i++){
						d_nodes[i].setAttribute("driver_id", drvRef.getKey());
						d_nodes[i].setAttribute("title", drvRef.getDescr());
						d_nodes[i].textContent = drvRef.getDescr().substring(0, self.DRIVER_SHORT_CHAR_COUNT);					
					}
				}
			);
			
		}else{
			//one vehicle
			var vehicle_id = n.parentNode.getAttribute("vehicle_id");			
			self.setSchedule(
				[schedule_date],
				[vehicle_id],
				drvRef.getKey(),
				true,
				function(){
					drvNode.setAttribute("driver_id", drvRef.getKey());
					drvNode.setAttribute("title", drvRef.getDescr());
					drvNode.textContent = drvRef.getDescr().substring(0, self.DRIVER_SHORT_CHAR_COUNT);
				}
			);				
		}
	});	
}

VehicleScheduleEdit_View.prototype.markDayClick = function(n){
	//mark
	if($(n.parentNode).find(".owner_schedule_vehicle_mark").first().get()[0].checked){
		//multy vehicle mode
		var schedule_date = DateHelper.strtotime(n.getAttribute("dt"));
		var is_busy = !$(n).hasClass("owner_schedule_shift");
		var vehicles = [];
		var d_nodes = [];
		//get all other checked vehices					
		$(".owner_schedule_vehicle_mark").each(function(index) {
			if(this.checked){				
				var nodes = DOMHelper.getElementsByAttr(n.getAttribute("dt"), this.parentNode.parentNode, "dt", true);
				if(!nodes || !nodes.length){
					throw new Error("element with dt tag not found");
				}					
				d_nodes.push(nodes[0]);
				vehicles.push(nodes[0].parentNode.getAttribute("vehicle_id"));
			}
		});
		
		if(!is_busy){
			this.setSchedule(
				[schedule_date],
				vehicles,
				0,
				false,
				function(){
					for(i = 0; i < d_nodes.length; i++){
						$(d_nodes[i]).removeClass("owner_schedule_shift");
						var day = schedule_date.getDay();
						if(day == 0 || day == 6){
							$(d_nodes[i]).addClass("owner_schedule_weekend");
						}
						$(d_nodes[i]).find(".owner_schedule_driver").eq(0).remove();			
					}
				}
			);
			
		}else{
			var drv_n = $(n).find(".owner_schedule_driver").eq(0);
			var driver_id = drv_n.attr("driver_id");
			var drv_ref;
			if(!driver_id){
				//tempate driver
				drv_ref = this.getElement("tmpl_driver").getValue();
				if(drv_ref && !drv_ref.isNull()){
					driver_id = drv_ref.getKey("id");
				}
			}else{
				drv_ref = new RefType({"key":{"id": driver_id}, "descr": drv_n.attr("title")});
			}
			if(driver_id){
				var self = this;
				this.setSchedule(
					[schedule_date],
					vehicles,
					driver_id,
					true,
					function(){
						for(i = 0; i < d_nodes.length; i++){
							self.addDriverNode(d_nodes[i], drv_ref);
							$(d_nodes[i]).addClass("owner_schedule_shift");
							$(d_nodes[i]).removeClass("owner_schedule_weekend");
						}
					}
				);
			}else{
				//select driver
				var self = this;
				this.changeDriver(schedule_date, function(drvRef){				
					self.setSchedule(
						[schedule_date],
						vehicles,
						drvRef.getKey(),
						true,
						function(){
							for(i = 0; i < d_nodes.length; i++){
								self.addDriverNode(d_nodes[i], drvRef);
								$(d_nodes[i]).addClass("owner_schedule_shift");
								$(d_nodes[i]).removeClass("owner_schedule_weekend");
							}
						}
					);
				});
			}
		
		}
	}else{
		//one node
		this.markDayOnNode(n);
	}
}

VehicleScheduleEdit_View.prototype.setScheduleServerCall = function(vehicles, callback){
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

VehicleScheduleEdit_View.prototype.setSchedule = function(scheduleDates, vehicles, driverId, isShift, callback){
	var vehiles_pm = [];//{"vehicle_id":VH_ID, "days":[{"date":DATE, "shift":true, "driver_id":DRIVER_ID}]}	
	for(var i = 0; i < vehicles.length; i++){
		var days = [];
		for(var n = 0; n < scheduleDates.length; n++){
			days.push({
				"date": DateHelper.format(scheduleDates[n], "Y-m-d"),
				"shift": isShift,
				"driver_id": driverId
			});
		}
		vehiles_pm.push({
			"vehicle_id": vehicles[i],
			"days": days
		});
	}
	this.setScheduleServerCall(vehiles_pm, callback);	
}

VehicleScheduleEdit_View.prototype.isFilterValid = function(){
	var res = true;
	
	var role_id = window.getApp().getServVar("role_id");
	if(role_id!="vehicle_owner"){
		var owner_ref = this.getElement("vehicle_owner").getValue();
		if(!owner_ref || owner_ref.isNull()){
			this.getElement("vehicle_owner").setNotValid("Не задан владелец");
			res = false;
		}
	}
	var period = this.getElement("period");
	var from = period.getControlFrom().getValue();
	if(!from || !DateHelper.isValidDate(from)){
		period.getControlFrom().setNotValid("Неверное значение");
		res = false;
	}
	
	var to = period.getControlTo().getValue();
	if(!to || !DateHelper.isValidDate(to)){
		period.getControlTo().setNotValid("Неверное значение");
		res = false;
	}
	
	return res;
}

VehicleScheduleEdit_View.prototype.setTemplateContent = function(cont){
	var target_n = document.getElementById(this.getId() + ":schedule");
	if(!target_n){
		throw new Error("Report node not found");
	}
	target_n.innerHTML = cont;
}

VehicleScheduleEdit_View.prototype.cmdApplyFilterCont = function(resp, from, to){
	/*
	var tmpl_n = document.getElementById(this.getId() + ":tmpl");
	if(!tmpl_n){
		throw new Error("Template node not found");
	}
	var tmpl = tmpl_n.innerHTML;
	tmpl = tmpl.replaceAll("[[", "{{");
	tmpl = tmpl.replaceAll("]]", "}}");
	*/
	
	var m = new ModelXML("VehicleOwnerSchedule_Model", {
		"fields":[
			new FieldDate("schedule_date"),
			new FieldJSON("vehicles_ref"),
			new FieldJSON("drivers_ref")
		],
		"data":resp.getModelData("VehicleOwnerSchedule_Model")
	});
	var tmpl = window.getApp().getTemplate("VehicleScheduleEdit_View");
	var week_days = ["вс","пн","вт","ср","чт","пт","сб"];	
	var tmpl_opts = {
		"DAY_COUNT": 0,
		"DAYS":[],
		"ROWS":[]
	};

	var loop_dt = new Date(from.getTime());
	while(loop_dt <= to){
		var day = loop_dt.getDay();
		tmpl_opts.DAYS.push({
			"DAY": loop_dt.getDate(),
			"DOW": week_days[day],
			"WEEKEND": (day==6 || day == 0)
		});
		loop_dt= new Date(loop_dt.setDate(loop_dt.getDate() + 1));			
	}
	tmpl_opts.DAY_COUNT = tmpl_opts.DAYS.length;

	var old_vh = "", old_dt, row;
	while(m.getNextRow()){
		
		var dt = m.getFieldValue("schedule_date");
		
		var vh = m.getFieldValue("vehicles_ref").getDescr();
		var dr = m.getFieldValue("drivers_ref").getDescr();
		if(old_vh != vh){
			//new vehicle = new row
			
			//complete old vehicle - add empty days up to End date
			if(old_dt){
				old_dt = new Date(old_dt.setDate(old_dt.getDate() + 1));
				while(old_dt <= to){
					var day = old_dt.getDay();
					row.DAYS.push({
						"DATE": DateHelper.format(old_dt, "Y-m-d"),
						"NO_SHIFT": true,
						"WEEKEND": (day==6 || day == 0)
					});
					old_dt = new Date(old_dt.setDate(old_dt.getDate() + 1));			
				}
				tmpl_opts.ROWS.push(row);				
			}
			
			row = {
				"DAYS": [],
				"VEHICLE": vh,
				"VEHICLE_ID":m.getFieldValue("vehicles_ref").getKey("id")
			};
			
			//add empty days up to current date
			loop_dt = new Date(from.getTime());
			while(loop_dt < dt){
				var day = loop_dt.getDay();
				row.DAYS.push({
					"DATE": DateHelper.format(loop_dt, "Y-m-d"),
					"NO_SHIFT": true,
					"WEEKEND": (day==6 || day == 0)
				})
				loop_dt = new Date(loop_dt.setDate(loop_dt.getDate() + 1));			
			}			
			
			old_vh = vh;
		}
		
		//add missing dates between previous and currnt
		if(old_dt){
			loop_dt = new Date(old_dt.setDate(old_dt.getDate() + 1));
			while(loop_dt < dt){
				var day = old_dt.getDay();
				row.DAYS.push({
					"DATE": DateHelper.format(loop_dt, "Y-m-d"),
					"NO_SHIFT": true,
					"WEEKEND": (day==6 || day == 0)
				});
				loop_dt = new Date(loop_dt.setDate(loop_dt.getDate() + 1));			
			}
		}
		
		//add curren date as shift
		row.DAYS.push({
			"DATE": DateHelper.format(dt, "Y-m-d"),
			"SHIFT": true,
			"DRIVER": dr,
			"DRIVER_SHORT": dr.substring(0, this.DRIVER_SHORT_CHAR_COUNT),
			"DRIVER_ID": m.getFieldValue("drivers_ref").getKey("id")
		});
		
		old_dt = dt;
	}
	//complete last vehicle - add empty days up to End date
	if(row){
		old_dt = new Date(old_dt.setDate(old_dt.getDate() + 1));
		while(old_dt <= to){
			var day = old_dt.getDay();
			row.DAYS.push({
				"DATE": DateHelper.format(old_dt, "Y-m-d"),
				"NO_SHIFT": true,
				"WEEKEND": (day==6 || day == 0)
			})
			old_dt = new Date(old_dt.setDate(old_dt.getDate() + 1));			
		}
		tmpl_opts.ROWS.push(row);	
	}
	
	//missing vehicles
	var mis_veh = new ModelXML("MissingVehicle_Model", {
		"fields":[
			new FieldJSON("vehicles_ref")
		],
		"data":resp.getModelData("MissingVehicle_Model")
	});	
	while(mis_veh.getNextRow()){
		var row = {
			"DAYS": [],
			"VEHICLE": mis_veh.getFieldValue("vehicles_ref").getDescr(),
			"VEHICLE_ID": mis_veh.getFieldValue("vehicles_ref").getKey("id")
		};
	
		var loop_dt = new Date(from.getTime());
		while(loop_dt <= to){
			var day = loop_dt.getDay();
			row.DAYS.push({
				"DATE": DateHelper.format(loop_dt, "Y-m-d"),
				"NO_SHIFT": true,
				"WEEKEND": (day==6 || day == 0)
			})
			loop_dt = new Date(loop_dt.setDate(loop_dt.getDate() + 1));			
		}
		tmpl_opts.ROWS.push(row);	
	}
	
	Mustache.parse(tmpl);
	this.setTemplateContent(Mustache.render(tmpl, tmpl_opts));
	
	//events
	var self = this;
	$("#owner_schedule_mark_all").change(function(e){
		self.markAll(e.target);
	});
	
	$(".owner_schedule_day").click(function(e){
		self.markDayClick(e.target);
	});
	
	$(".owner_schedule_driver").click(function(e){
		self.changeDriverClick(e.target);		
		e.stopPropagation();
	});
}

VehicleScheduleEdit_View.prototype.cmdApplyFilter = function(){
	if(!this.isFilterValid()){
		return;
	}
	
	var owner_ref;
	var vehicle_owner_ctrl = this.getElement("vehicle_owner");
	if(vehicle_owner_ctrl){
		vehicle_owner_ctrl.setValid();
		owner_ref = this.getElement("vehicle_owner").getValue();
	}
	
	var period = this.getElement("period");
	period.getControlFrom().setValid();
	period.getControlTo().setValid();		
	var from = period.getControlFrom().getValue();
	var to = period.getControlTo().getValue();
	
	window.setGlobalWait(true);
	this.setTemplateContent("");
	var self = this;
	
	var pm = (new VehicleSchedule_Controller()).getPublicMethod("get_vehicle_owner_schedule");
	pm.setFieldValue("date_from", from);
	pm.setFieldValue("date_to", to);	
	pm.setFieldValue("vehicle_owner_id", owner_ref? owner_ref.getKey() : 0);	
	
	pm.run({
		"ok":function(resp){
			self.cmdApplyFilterCont(resp, from, to);
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	})
}

VehicleScheduleEdit_View.prototype.switchTmplDay = function(dayNode){
	if($(dayNode).hasClass("owner_schedule_shift")){
		$(dayNode).removeClass("owner_schedule_shift");
	}else{
		$(dayNode).addClass("owner_schedule_shift");
	}
}

