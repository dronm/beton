/** Copyright (c) 2019 - 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderDialog_View(id,options){	

	options = options || {};
	options.controller = options.controller || new Order_Controller();
	options.model = options.model || ((options.models&&options.models.OrderDialog_Model)? options.models.OrderDialog_Model: new OrderDialog_Model());

	this.m_isGarbage = options.isGarbage;
	
	options.cmdSave = false;

	var app = window.getApp();
	var constants = {"def_order_unload_speed":null,"def_lang":null};
	app.getConstantManager().get(constants);
	
	var role_id = app.getServVar("role_id");
	this.m_readOnly = (role_id=="lab_worker" || options.readOnly);
	
	var bool_bs_cl = "control-label "+window.getBsCol(5);
	var obj_bs_cl = ("control-label "+window.getBsCol(2));
	
	const self = this;
	
	options.addElement = function(){
		this.addElement(new AvailOrderTimeControl(id+":avail_time",{
			"controller":options.controller,
			"onSetTime":function(newTime){
				self.getElement("date_time_time").setValue(DateHelper.format(newTime,"H:i"));
				if(self.m_onChangeTime){
					self.m_onChangeTime();
				}
			},
			"onSetSpeed":function(newSpeed){
				self.getElement("unload_speed").setValue(Math.round(newSpeed,2));
			}		
		}));
	
	
		this.addElement(new EditString(id+":number",{
			"enabled":false,
			"attrs":{"style":"width:150px;display:inline;","class":"form-control"},
			"inline":true,
			"cmdClear":false
		}));

		var date_time_ctrl = new EditDate(id+":date_time_date",{
			"required":true,
			"value":options.dateTime_date? options.dateTime_date : DateHelper.time(),
			"attrs":{"style":"width:150px;display:inline;","class":"form-control"},
			"inline":true,
			"cmdClear":false,			
			"onSelect":function(){
				self.getAvailSpots();
				if(self.m_onChangeDate){
					self.m_onChangeDate();
				}
			},			
			"events":{
				"onkeyup":function(e){
					self.getAvailSpots();
					if(self.m_onChangeDate){
						self.m_onChangeDate();
					}
				}
			}
		});	
		this.addElement(date_time_ctrl);
		
		this.addElement(new OrderTimeSelect(id+":date_time_time",{
			"required":true,
			"value":options.dateTime_time,
			"attrs":{"style":"width:150px;display:inline;","class":"form-control"},
			"inline":true,
			"events":{
				"change":function(){
					if(self.m_onChangeTime){
						self.m_onChangeTime();
					}
				}
			}
		}));	
	
		this.addElement(new EditCheckBox(id+":pay_cash",{
			"labelCaption":"Оплата на месте:",
			"className":"",
			"labelClassName":bool_bs_cl,
			"events":{
				"change":function(){
					self.getElement("calc").setPayCash();
				}
			}
		}));	

		this.addElement(new EditCheckBox(id+":payed",{
			"labelCaption":"Оплачено:",
			"className":"",
			"labelClassName":bool_bs_cl
		}));	

		this.addElement(new EditCheckBox(id+":under_control",{
			"labelCaption":"На контроле:",
			"className":"",
			"labelClassName":bool_bs_cl
		}));	

		this.addElement(new EditCheckBox(id+":ext_production",{
			"labelCaption":"Не отправлять в производство автоматически:",
			"labelClassName":obj_bs_cl
			//"className":"",
			//"labelClassName":bool_bs_cl
		}));	

		this.addElement(new EditNum(id+":f_val",{
			"labelCaption": "Значение F:",
			"title": "Значение F смеси"
		}));	
		this.addElement(new EditNum(id+":w_val",{
			"labelCaption": "Значение W:",
			"title": "Значение W смеси"
		}));	
	
		//*****************
		var client_ctrl = new ClientEdit(id+":client",{
			"cmdInsert":true,
			"labelClassName":obj_bs_cl,
			"acPublicMethodId":"complete_for_order",
			"acModel":new OrderClient_Model(),
			"onSelect":function(f){
				self.onSelectClient(f);
				var calc_ctrl = self.getElement("calc");
				if(calc_ctrl){
					calc_ctrl.setClientSpec();
				}				
			},
			// "focused":true,
			"required":true,
			"onClear":function(){
				self.getElement("client").getErrorControl().setValue("","info");
				self.getElement("contact_list").reset();
				var calc_ctrl = self.getElement("calc");
				if(calc_ctrl){
					calc_ctrl.setClientSpec();
				}
			}			
		});
		this.m_clientResetKeys = client_ctrl.resetKeys;
		client_ctrl.resetKeys = function(){
			self.m_clientResetKeys.call(self.getElement("client"));
			self.setClientId(null);
			self.setClientDebt(0, undefined);
		}
		this.addElement(client_ctrl);		
		
		
		this.addElement(new EditFloat(id+":unload_speed",{
			"labelCaption":"Скорость разгрузки:",
			"value":constants.def_order_unload_speed.getValue(),
			"labelClassName":obj_bs_cl,
			"editContClassName":("input-group "+window.getBsCol(2)),
			"buttonOpen": new ButtonCtrl(id+":btn_open", {
				"control": this,
				"glyph": "glyphicon-menu-hamburger",
				"onClick": function(){
					self.showUnloadSpeedSchema();
				}
			}),
			"events":{
				"onchange":function(){
					self.getElement("calc").recalcTotal();						
					self.getAvailSpots();				
				},
				"onkeyup":function(e){
					self.getElement("calc").recalcTotal();						
					self.getAvailSpots();
				}
			}			
		}));

		this.addElement(new OrderContactList(id+":contact_list", {
			"readOnly": this.m_readOnly,
			"rowOptions": {"labelClassName": obj_bs_cl},
			"formatFunction": function(fields){
				// [] is authoritative; only a missing/null projection uses old fields.
				var value = fields.contact_list && fields.contact_list.getValue();
				if(value != null) return value;
				var get = OrderContactEdit.fieldValue;
				var name = get(fields, "descr"), tel = get(fields, "phone_cel");
				if(!name && !tel) return [];
				return [{
					contact: {name: name || "", tel: tel || ""},
					contact_id: get(fields, "contact_id"),
					tm_exists: get(fields, "tm_exists"), tm_activated: get(fields, "tm_activated"),
					tm_photo: get(fields, "tm_photo"), tm_id: get(fields, "tm_id"),
					max_data: get(fields, "max_data")
				}];
 			}
 		}));

		/*
		this.addElement(new LangEditRef(id+":lang",{
			"labelClassName":obj_bs_cl,
			"value":constants.def_lang.getValue()
		}));	
		*/
		this.addElement(new UserEditRef(id+":user",{
			"labelClassName":obj_bs_cl,
			"labelCaption":"Автор документа:",
			"enabled":(role_id=="owner"),
			"value":new RefType({"keys":{"id":app.getServVar("user_id")},"descr":app.getServVar("user_name"),"dataType":"users"})
		}));
			
		this.addElement(new EditString(id+":comment_text",{
			"labelClassName":obj_bs_cl,			
			"labelCaption":"Комментарий:",
			"maxLength":500
		}));	
		
		this.addElement(new OrderCalc_View(id+":calc",{
			"readOnly":this.m_readOnly,
			"calc":false,
			"getAvailSpots":function(){
				self.getAvailSpots();
			},
			"getPayCash":function(){
				return self.getElement("pay_cash").getValue();
			},
			"dialogContext":this
		}));	
		
		this.addElement(new ShipmentMediaList_View(id+":media",{
			"detail":true
		}));				

		this.addElement(new ButtonHistory(id+":cmdHistory",{
			tableName: "orders",
			visible: false, //disabled at start
			getRecordId: () => {
				const fieldId = self.m_isGarbage? "order_id" : "id";
				return self.getElement(fieldId).getValue();
			}
		}));				
	}
	
	OrderDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("number")})
		,new DataBinding({"control":this.getElement("date_time_date"),"field":this.m_model.getField("date_time")})
		,new DataBinding({"control":this.getElement("date_time_time"),"field":this.m_model.getField("date_time")})
		,new DataBinding({"control":this.getElement("pay_cash")})
		,new DataBinding({"control":this.getElement("under_control")})
		,new DataBinding({"control":this.getElement("payed")})
		,new DataBinding({"control":this.getElement("client"),"field":this.m_model.getField("clients_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("destination"),"field":this.m_model.getField("destinations_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("client_specification"), "field":this.m_model.getField("client_specifications_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("quant")})
		,new DataBinding({"control":this.getElement("unload_speed")})
		,new DataBinding({"control":this.getElement("comment_text")})
		,new DataBinding({"control":this.getElement("calc").getElement("concrete_type"),"field":this.m_model.getField("concrete_types_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("pump_vehicle"),"field":this.m_model.getField("pump_vehicles_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("unload_type")})
		,new DataBinding({"control":this.getElement("contact_list")})
		//,new DataBinding({"control":this.getElement("lang"),"field":this.m_model.getField("langs_ref")})
		,new DataBinding({"control":this.getElement("user"),"field":this.m_model.getField("users_ref")})
		,new DataBinding({"control":this.getElement("calc").getElement("destination_cost")})
		,new DataBinding({"control":this.getElement("calc").getElement("concrete_cost")})
		,new DataBinding({"control":this.getElement("calc").getElement("unload_price")})
		,new DataBinding({"control":this.getElement("calc").getElement("total")})
		,new DataBinding({"control":this.getElement("ext_production")})
		,new DataBinding({"control":this.getElement("f_val")})
		,new DataBinding({"control":this.getElement("w_val")})
	];
	this.setDataBindings(r_bd);
	
	//write
	if(!this.m_readOnly){
		OrderContactList.configurePublicMethod(options.controller.getPublicMethod("insert"));
		OrderContactList.configurePublicMethod(options.controller.getPublicMethod("update"));
	}

	if(this.m_readOnly){
		this.setWriteBindings([
			new CommandBinding({"control":this.getElement("comment_text")})
		]);
	}
	else{
		this.setWriteBindings([
			new CommandBinding({
				"func":function(pm){
					self.setPublicMethodDateTime(pm);
					if(self.getTotalEditModified()){
						pm.setFieldValue("total_edit",!self.m_model.getFieldValue("total_edit"));
					}
					else{
						pm.unsetFieldValue("total_edit");
					}
					return true;
				}
			})
			,new CommandBinding({"control":this.getElement("pay_cash")})
			,new CommandBinding({"control":this.getElement("under_control")})
			,new CommandBinding({"control":this.getElement("payed")})
			,new CommandBinding({"control":this.getElement("client"),"fieldId":"client_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("destination"),"fieldId":"destination_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("client_specification"), "fieldId":"client_specification_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("quant")})
			,new CommandBinding({"control":this.getElement("unload_speed")})
			,new CommandBinding({"control":this.getElement("comment_text")})		
			,new CommandBinding({"control":this.getElement("calc").getElement("concrete_type"),"fieldId":"concrete_type_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("pump_vehicle"),"fieldId":"pump_vehicle_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("unload_type")})
			,new CommandBinding({"control":this.getElement("contact_list")})
			//,new CommandBinding({"control":this.getElement("lang"),"fieldId":"lang_id"})
			,new CommandBinding({"control":this.getElement("user"),"fieldId":"user_id"})
			,new CommandBinding({"control":this.getElement("calc").getElement("destination_cost"),"fieldId":"destination_price"})
			,new CommandBinding({"control":this.getElement("calc").getElement("concrete_cost"),"fieldId":"concrete_price"})
			,new CommandBinding({"control":this.getElement("calc").getElement("unload_cost"),"fieldId":"unload_price"})
			,new CommandBinding({"control":this.getElement("calc").getElement("total")})
			,new CommandBinding({"control":this.getElement("ext_production")})
			,new CommandBinding({"control":this.getElement("f_val")})
			,new CommandBinding({"control":this.getElement("w_val")})
		]);
	}
	
	this.addDetailDataSet({
		"control":this.getElement("media").getElement("grid"),
		"controlFieldId": ["order_id"],
		"value": [function(){
			return self.m_model.getFieldValue("id");
		}]
	});		
		
}
extend(OrderDialog_View,ViewObjectAjx);

//callbacks
OrderDialog_View.prototype.m_onChangeDate;
OrderDialog_View.prototype.m_onChangeTime;

OrderDialog_View.prototype.m_ref1c; //initialized from db, then changed
OrderDialog_View.prototype.m_clientRef1c; 

OrderDialog_View.prototype.updateOrder1cInfo = function(){
	//if ref_1c exists - show print info
	//otherwise - show create order 
	const ref_1c = this.m_ref1c; //order ref
	console.log("OrderDialog_View, ref_1c:",ref_1c)
	const self = this;

	const ctrl = this.getElement('calc').getElement("client_specification").getErrorControl();
	if(this.m_onOrderInfoClick){
		EventHelper.del(ctrl.getNode(), "click", this.m_onOrderInfoClick);
	}
	let txt, txtType, txtTitle;
	if(!ref_1c?.m_keys?.ref_1c){
		txt = "Новый счет";
		txtTitle = "Создать новый счет в 1с";
		txtType = "info";
		this.m_onOrderInfoClick = function(event) {
			self.createNewOrder();
		};
	}else{
		txt = ref_1c.m_descr;
		txtTitle = "Открыть печатную форму счета";
		txtType = "warn";
		this.m_onOrderInfoClick = function(event) {
			self.printOrder();
		};
	}
	ctrl.setValue(txt, txtType);
	ctrl.getNode().setAttribute("title", txtTitle);
	DOMHelper.addClass(ctrl.getNode(), "tmInvite");
	EventHelper.add(ctrl.getNode(), "click", this.m_onOrderInfoClick);
}
// Updates gui info on this.m_clientRef1c
OrderDialog_View.prototype.updateClientRef1cInfo = function(){
	DOMHelper.delNode("order_client_ref_1c");

	if (!this.m_clientRef1c?.m_keys?.ref_1c) {
		const self = this;
		const inf_cont = this.getElement("client").getErrorControl().getNode();
		const no_ref_tag = document.createElement("DIV");
		no_ref_tag.textContent = "Связать с 1с для выписки счетов и взаиморасчетов";
		no_ref_tag.setAttribute("id", "order_client_ref_1c");
		no_ref_tag.setAttribute("class", "text-danger");
		no_ref_tag.setAttribute("style", "cursor: pointer;");
		no_ref_tag.addEventListener("click", function(event) {
			event.preventDefault(); // Prevent default anchor behavior
			//f.id.getValue()
			const clientRef = self.getElement("client").getValue();
			if(clientRef && !clientRef.isNull()){
				self.setRef1cForClient(clientRef.getKey("id")); //OrderClient model
			}
		});
		inf_cont.appendChild(no_ref_tag);
		// DOMHelper.show(inf_cont);
	}
}

// onSelectClient is called when a client is selected, it shows client previous shipment quants.
OrderDialog_View.prototype.onSelectClient = function(f){
	this.getElement("contact_list").setSuggestedContact(f.descr.getValue(), f.phone_cel.getValue());
	var inf;
	if(f.quant.getValue()){
		inf = DateHelper.format(f.date_time.getValue(),"d/m/y")+","+f.destinations_ref.getValue().getDescr()+","+f.concrete_types_ref.getValue().getDescr()+","+f.quant.getValue()+"м3";
	}
	else{
		inf = "Еще не брал";
	}
 // console.log("onSelectClient",f)	
	var debt = f.client_debt.getValue();
	if(debt != undefined && debt!=0){
		inf = inf + ", " + this.getClientDebtText(debt, f.client_debt_date.getValue());
		this.setClientDebt(debt, f.client_debt_date.getValue());
	}
	this.getElement("client").getErrorControl().setValue(inf,"info");

	this.m_clientRef1c = f.ref_1c.getValue(); //client reference to 1c
	// if(typeof this.m_clientRef1c === "string"){
	// 	this.m_clientRef1c = JSON.parse(this.m_clientRef1c);
	// }
	this.updateClientRef1cInfo();

	this.setClientId(f.id.getValue());
}


OrderDialog_View.prototype.getAvailSpots = function(){
	this.getElement("avail_time").refresh(
		this.getElement("date_time_date").getValue(),
		this.getElement("calc").getElement("quant").getValue(),
		this.getElement("unload_speed").getValue()
	);
}

OrderDialog_View.prototype.getModified = function(cmd){
	return (
		OrderDialog_View.superclass.getModified.call(this,cmd) || this.getDateModified() || this.getTotalEditModified()
	);
}

OrderDialog_View.prototype.getTotalEditModified = function(pm){
	return (this.getElement("calc").getElement("total").getEditAllowed()!=this.m_model.getFieldValue("total_edit"));
}

OrderDialog_View.prototype.getDateModified = function(pm){
	return (this.getElement("date_time_date").getModified()||this.getElement("date_time_time").getModified());
}

OrderDialog_View.prototype.setPublicMethodDateTime = function(pm){
	if(this.getDateModified() && pm){
		var dt = this.getElement("date_time_date").getValue();
		if(dt){
			dt = DateHelper.dateStart(dt);
			dt = new Date(dt.getTime()+ DateHelper.timeToMS(this.getElement("date_time_time").getValue()));
		}
		pm.setFieldValue("date_time",dt);
	}
	else if(pm){
		pm.unsetFieldValue("date_time");
	}
}

OrderDialog_View.prototype.setClientId = function(clientId){
	this.getElement("contact_list").setClientId(clientId);

 	var dest_ac = this.getElement("calc").getElement("destination").getAutoComplete();
	var pm = dest_ac && dest_ac.getPublicMethod();
	if(pm){
		if(clientId) pm.setFieldValue("client_id", clientId);
		else pm.getField("client_id").resetValue();
	}
}

OrderDialog_View.prototype.getClientDebtText = function(clientDebt, clientDebtDate){
	let clientDebtPref = "";
	if(clientDebt > 0){
		clientDebtPref = "Долг: ";		
	}else if (clientDebt < 0) {
		clientDebtPref = "Мы должны: ";		
		clientDebt = -1 * clientDebt;
	}
	let clientDebtText = CommonHelper.numberFormat(clientDebt, 2, ",", " " );	
	let clientDebtDateText = "";
	if(clientDebtDate){
		clientDebtDateText = " на " + DateHelper.format(clientDebtDate,"d/m/y H:i");
	}

	return clientDebtPref + clientDebtText + " руб." + clientDebtDateText;
}

OrderDialog_View.prototype.setClientDebt = function(clientDebt, clientDebtDate){
	var debt_n = document.getElementById(this.getId()+":client_debt");
	if(clientDebt != undefined && clientDebt != 0){		
		if(clientDebt > 0){
			DOMHelper.addClass(debt_n, "text-danger");
			
		}else if (clientDebt < 0){
			DOMHelper.addClass(debt_n, "text-success");
		}
		// var client_debt_s = CommonHelper.numberFormat(clientDebt, 2, ",", " " );
		DOMHelper.setText(debt_n, this.getClientDebtText(clientDebt, clientDebtDate));	
		DOMHelper.show(debt_n);
	}else{
		DOMHelper.setText(debt_n, "");	
		DOMHelper.hide(debt_n);
	}
}

OrderDialog_View.prototype.onGetData = function(resp,cmd){
	if(cmd === true) cmd = "copy"; // Legacy ViewAjx callers use true for copy.
	OrderDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	var m = this.getModel();

	this.m_ref1c = m.getFieldValue("ref_1c");
	this.m_clientRef1c = m.getFieldValue("client_ref_1c");

	var f = m.getField("clients_ref");
	if(!f.isNull() && f.getValue()){
		this.setClientId(f.getValue().getKey());
	} else{
		this.setClientId(null);
	}
	
	var ctrl_calc = this.getElement("calc");
	
	ctrl_calc.getElement("total").setEditAllowed(m.getFieldValue("total_edit"));	
	ctrl_calc.changeUnloadType();
	ctrl_calc.setDestinationPrice(m.getFieldValue("destination_price"),m.getFieldValue("destination_distance"),m.getFieldValue("destination_time_rout"))
	ctrl_calc.setConcretePrice(m.getFieldValue("concrete_price"));
	ctrl_calc.setClientSpec();
	
	var id = this.getId();
	
	//last modif
	var last_modif_users_ref = m.getFieldValue("last_modif_users_ref");	
	if(last_modif_users_ref&&!last_modif_users_ref.isNull()){
		const n = document.getElementById(id+":cmd-cont");
		if(n){
			n.style = "float:left;";
		}
		n_user = document.getElementById(id+":last_modif_user");
		if(n_user){
			DOMHelper.setText(n_user, last_modif_users_ref.getDescr());
		}
		n_time = document.getElementById(id+":last_modif_date_time");
		if(n_time){
			DOMHelper.setText(n_time, DateHelper.format(m.getFieldValue("last_modif_date_time"),"d/m/y H:i"));
		}
	}

	//debts
	this.setClientDebt(m.getFieldValue("client_debt"), m.getFieldValue("client_debt_date"));
	
	//create
	/*
	var create_users_ref = m.getFieldValue("users_ref");	
	if(create_users_ref&&!create_users_ref.isNull()){
		var id =this.getId();
		document.getElementById(id+":cmd-cont").style = "float:left;";
		DOMHelper.setText(document.getElementById(id+":create_user"), create_users_ref.getDescr());
		DOMHelper.setText(document.getElementById(id+":create_date_time"), DateHelper.format(m.getFieldValue("create_date_time"),"d/m/y H:i"));
	}
	*/
	this.getElement("user").getErrorControl().setValue("Время создания: "+DateHelper.format(m.getFieldValue("create_date_time"),"d/m/y H:i"),"warn");	
	
	//tm
	if(cmd == "copy") this.getElement("contact_list").prepareCopy();
	
	if(this.m_readOnly){
		this.setEnabled(false);
		this.getElement("comment_text").setEnabled(true);
		this.getControlOK().setEnabled(true);
	}


	if(cmd == "edit"){
		this.getElement("cmdHistory").setVisible(true);

		this.getElement("client").getErrorControl().setLevel("info");
		this.getElement("calc").getElement("client_specification").getErrorControl().setLevel("info");
		this.updateClientRef1cInfo();
		this.updateOrder1cInfo();
	}else if (this.m_isGarbage){
		this.getElement("cmdHistory").setVisible(true);
	}

	if(cmd=="insert" || cmd=="copy"){
		this.getElement("client").focus();
	}else{
		this.getElement("calc").getElement("quant").focus();
	}
}


//model is ClientModel from complete_for_order method.
OrderDialog_View.prototype.setRef1cForClient = function(clientId){
	(new ClientSetRef1c(clientId, function(){
		DOMHelper.delNode("order_client_ref_1c");
	}).open());
}

OrderDialog_View.prototype.onAfterUpsert = function(resp, initControls){
	OrderDialog_View.superclass.onAfterUpsert.call(this, resp, initControls);
	if(resp && resp.modelExists("OrderContactsSaved_Model")){
		var saved = resp.getModel("OrderContactsSaved_Model");
		if(saved.getNextRow()){
			var value = saved.getFieldValue("contact_list");
			if(this.getModel().fieldExists("contact_list")) this.getModel().getField("contact_list").setValue(value);
			if(initControls) this.getElement("contact_list").setInitValue(value);
		}
	}
};

//returns current ref 1c: from database or newly selected
OrderDialog_View.prototype.getRef1c = function(){

}


OrderDialog_View.prototype.createNewOrderFinish = function(model){
	model.getNextRow();
	const ref_1c = model.getFieldValue("ref_1c");
	if(typeof ref_1c == "string"){
		this.m_ref1c = new RefType(JSON.parse(ref_1c));
	}else{
		this.m_ref1c = ref_1c;
	}
	console.log("finish model",this.m_ref1c)
	this.updateOrder1cInfo();
	window.showTempNote("Сформирован счет в 1с",null,5000);
}

OrderDialog_View.prototype.createNewOrderCont = function(){
	const pm = (new Order_Controller()).getPublicMethod("new_order_1c");
	pm.setFieldValue("id", this.getElement("id").getValue());
	const self = this;
	pm.run({
		ok:function(resp){
			self.createNewOrderFinish(resp.getModel("Order1c_Model"));
		}
	});
}

OrderDialog_View.prototype.createNewOrder = function(){
	//save if modified
	if(this.getModified()){
		const self = this;
		this.onSave(function(){
			self.createNewOrderCont();
		})
	}else{
		this.createNewOrderCont();
	}
}

OrderDialog_View.prototype.printOrderCont = function(){
	const pm = (new Order_Controller()).getPublicMethod("print_order_1c");
	pm.setFieldValue("id", this.getElement("id").getValue());
	// pm.download();
	const offset = 0;
	const h = $( window ).width()/3*2;
	const left = $( window ).width()/2;
	const w = left - 20;
	pm.openHref("ViewPDF","location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);
}

OrderDialog_View.prototype.printOrder = function(){
	//downdload file and show
	if(this.getModified()){
		const self = this;
		this.onSave(function(){
			self.printOrderCont();
		})
	}else{
		this.printOrderCont();
	}
}
OrderDialog_View.prototype.showUnloadSpeedSchema = function(){
	this.m_unloadListView = new UnloadSpeedSchemaList_View(
		this.getId()+":form:body:unloadSpeedSchema",{
			"autoRefresh": true
		}
	);
	
	const self = this;
	this.m_unloadListForm = new WindowFormModalBS(this.getId()+":form",{
		"cmdCancel": false,
		"cmdOk":true,
		"controlOkCaption":"Закрыть",
		"controlOkTitle":"Закрыть форму",
		"onClickOk":function(){
			self.closeSelect();
		},				
		"content":this.m_unloadListView,
		"contentHead":"",
		"dialogWidth":"30%"
	});

	this.m_unloadListForm.open();
}

OrderDialog_View.prototype.closeSelect = function(){
	if (this.m_unloadListView){
		this.m_unloadListView.delDOM();
		delete this.m_unloadListView;
	}
	if (this.m_unloadListForm){
		this.m_unloadListForm.close();
		delete this.m_unloadListForm;
	}
}
