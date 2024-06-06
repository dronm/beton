/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderDialog_View(id,options){	

	options = options || {};
	options.controller = options.controller || new Order_Controller();
	options.model = options.model || ((options.models&&options.models.OrderDialog_Model)? options.models.OrderDialog_Model: new OrderDialog_Model());
	
	options.cmdSave = false;

	var app = window.getApp();
	var constants = {"def_order_unload_speed":null,"def_lang":null};
	app.getConstantManager().get(constants);
	
	var role_id = app.getServVar("role_id");
	this.m_readOnly = (role_id=="lab_worker" || options.readOnly);
	
	var bool_bs_cl = "control-label "+window.getBsCol(5);
	var obj_bs_cl = ("control-label "+window.getBsCol(2));
	
	var self = this;
	
	options.addElement = function(){
		this.addElement(new AvailOrderTimeControl(id+":avail_time",{
			"controller":options.controller,
			"onSetTime":function(newTime){
				self.getElement("date_time_time").setValue(DateHelper.format(newTime,"H:i"));
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
			},			
			"events":{
				"onkeyup":function(e){
					self.getAvailSpots();
				}
			}
		});	
		this.addElement(date_time_ctrl);
		
		this.addElement(new OrderTimeSelect(id+":date_time_time",{
			"required":true,
			"value":options.dateTime_time,
			"attrs":{"style":"width:150px;display:inline;","class":"form-control"},
			"inline":true
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
			"focus": true,
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
			"focused":true,
			"required":true,
			"onClear":function(){
				self.getElement("client").getErrorControl().setValue("","info");
				self.getElement("descr").reset();
				self.onClearDescr();
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
			self.setClientDebt(0);
		}
		this.addElement(client_ctrl);		
		
		
		this.addElement(new EditFloat(id+":unload_speed",{
			"labelCaption":"Скорость разгрузки:",
			"value":constants.def_order_unload_speed.getValue(),
			"labelClassName":obj_bs_cl,
			"editContClassName":("input-group "+window.getBsCol(2)),
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

		var descr_ac_model = new ModelXML("OrderDescr_Model",{
			"fields":{
				"descr":new FieldString("descr"),
				"phone_cel":new FieldString("phone_cel"),
				//"langs_ref":new FieldJSON("langs_ref"),
				//"clients_ref":new FieldJSON("clients_ref"),
				//"client_tels_ref":new FieldJSON("client_tels_ref"),
				"contact_id":new FieldInt("contact_id"),
				"tm_id":new FieldInt("tm_id"),
				"tm_exists":new FieldBool("tm_exists"),
				"tm_activated":new FieldBool("tm_activated"),
				"tm_photo":new FieldString("tm_photo")
			}
		})
		
		
		this.addElement(new EditString(id+":descr",{
			"labelCaption":"Контакт:",
			"labelClassName":obj_bs_cl,
			"maxLength":500,
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acController":options.readOnly? null : options.controller,
			"acModel":descr_ac_model,
			"acPublicMethod":options.readOnly? null : options.controller.getPublicMethod("complete_descr"),
			"acPatternFieldId":"descr",
			"acKeyFields":[descr_ac_model.getField("descr")],
			"acDescrFunction":function(f){
				var tm = (f.tm_exists.getValue()&&f.tm_activated.getValue());
				return f.descr.getValue()+" "+CommonHelper.maskFormat(f.phone_cel.getValue(), window.getApp().getPhoneEditMask()) + (tm? " (Telegarm)":" (СМС)");
			},
			"acOnCompleteTextOut": function(textHTML,modelRow){
				var pref = "";
				if(modelRow&&modelRow.tm_photo.getValue()){
					//Contact photo
					pref = "<img class='contactPhoto' src='data:image/png;base64, "+modelRow.tm_photo.getValue()+"'/img>";
				}
				DOMHelper.delNodesOnClass("contactPhoto");
				return pref + textHTML;
			},			
			"acICase":"1",
			"acMid":"1",
			"acEnabled":false,			
			"onSelect":function(f){
				self.onSelectDescr(f);
			},
			"onClear":function(){
				self.onClearDescr();
				self.m_selectedContactId = undefined;
			},
			"events":{
				"blur":function(){
					self.onLeaveContact();
				}/*,
				"change":function(){
					//self.m_selectedContactId = undefined;
					console.log("descr change")
				}*/
			},
			"buttonSelect": new SendNotificationBtn(id+":btnSendNotif",{
				"getRef":function(callBack){
					self.getContactRef(callBack);
				}
			})
		}));

		this.addElement(new EditPhone(id+":phone_cel",{
			"labelClassName":obj_bs_cl,
			"labelCaption":"Телефон:",
			"events":{
				"blur":function(){
					self.onLeaveContact();
				},
				"keyup":function(){
					var v = self.getElement("phone_cel").getValue();
					if(v && v.length==10){
						self.onLeaveContact();
					}
				}
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
		,new DataBinding({"control":this.getElement("descr")})
		,new DataBinding({"control":this.getElement("phone_cel")})
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
					if(self.m_selectedContactId){
						pm.setFieldValue("contact_id", self.m_selectedContactId);
					}else{
						pm.unsetFieldValue("contact_id");
					}
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
			,new CommandBinding({"control":this.getElement("descr")})
			,new CommandBinding({"control":this.getElement("phone_cel")})
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

//contact_id value. Has no associated control field
OrderDialog_View.prototype.m_selectedContactId;

OrderDialog_View.prototype.showTMInvite = function(){
	var tm_ctrl = this.getElement("descr").getErrorControl();
	tm_ctrl.setValue("Пригласить в Telegram","info");
	DOMHelper.addClass(tm_ctrl.getNode(), "tmInvite");
	if(!this.m_onTMInviteClick){			
		var self = this;
		this.m_onTMInviteClick = function(){
			self.onTMInviteClick();
		}
	}
	EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);

}
OrderDialog_View.prototype.showPhoto = function(ctrl, base64Data){
	ctrl.popup(
		'<div><img src="data:image/png;base64, '+base64Data+'"/></div>',
		{"title":"Данные по контакту"}
	);
}
OrderDialog_View.prototype.showTMInf = function(activated, photo, tmId){
	var tm_ctrl = this.getElement("descr").getErrorControl();
	tm_ctrl.setValue(activated? "Пользователь Telegram" : "Сообщение отправлено, Telegram не активирован", "info");	
	DOMHelper.delNodesOnClass("contactPhoto");
	if(photo && tmId){
		var img = DOMHelper.elem("IMG", {"class":"contactPhoto", "src": "data:image/png;base64, "+photo});
		this.photoDetail = new ToolTip({
			"node": img,
			"wait":2,
			"onHover":(function(cont, id){
				return function(event){
					if(!cont.photoDetailData){
						cont.photoDetailData = [];
					}
					if(!cont.photoDetailData[id]){
						var pm = (new TmUser_Controller()).getPublicMethod("get_object");
						pm.setFieldValue("id", id);
						var ctrl = this;
						pm.run({
							"ok":function(resp){
								var m = resp.getModel("TmUserDialog_Model");
								if(m.getNextRow()){
									cont.photoDetailData[id] = m.getFieldValue("tm_photo");
									cont.showPhoto(ctrl, cont.photoDetailData[id]);
								}
							}																
						});
					}else{
						cont.showPhoto(this, cont.photoDetailData[id]);
					}													
				}
			})(this, tmId)
		});
	
		tm_ctrl.m_node.parentNode.insertBefore(img, tm_ctrl.m_node);
	}
}

OrderDialog_View.prototype.hideTMInvite = function(){
	var tm_ctrl = this.getElement("descr").getErrorControl();
	tm_ctrl.setValue("","info");
	if(this.m_onTMInviteClick){
		EventHelper.add(tm_ctrl.getNode(), "click", this.m_onTMInviteClick);
	}	
	DOMHelper.delNodesOnClass("contactPhoto");
}

OrderDialog_View.prototype.onSelectDescr = function(f){
	this.getElement("phone_cel").setValue(f.phone_cel.getValue());
	//this.getElement("lang").setValue(f.langs_ref.getValue());
	this.m_selectedContactId = f.contact_id.getValue();	
	var descr = f.descr.getValue();
	this.getElement("descr").setValue(descr);	
	if(descr && descr.length && !f.tm_exists.getValue()){
		this.showTMInvite();
		
	}else if(descr && descr.length){
		this.showTMInf(f.tm_activated.getValue(), f.tm_photo.getValue(), f.tm_id.getValue());
	}
}

OrderDialog_View.prototype.onLeaveContact = function(){
	//нет контакта, есть имя и тел
	var descr = this.getElement("descr").getValue();
	var phone_cel = this.getElement("phone_cel").getValue();
	if(!this.m_selectedContactId && descr && descr.length && phone_cel && phone_cel.length==10){
		//new contact
		this.showTMInvite();
	}
}

OrderDialog_View.prototype.onClearDescr = function(f){
	this.getElement("phone_cel").reset();
	this.hideTMInvite();
}

OrderDialog_View.prototype.onTMInviteClick = function(){
	var self = this;
	self.getContactRef(function(ref){
		window.getApp().TMInviteContact(ref, function(){
			self.hideTMInvite();
		});
	});
}

OrderDialog_View.prototype.onSelectClient = function(f){
	var ctrl;
	ctrl = this.getElement("descr");
	if(!ctrl.isNull()){
		ctrl.setValue(f.descr.getValue());
	}
	ctrl = this.getElement("phone_cel");
	if(!ctrl.isNull()){
		ctrl.setValue(f.phone_cel.getValue());
	}
	var inf;
	if(f.quant.getValue()){
		inf = DateHelper.format(f.date_time.getValue(),"d/m/y")+","+f.destinations_ref.getValue().getDescr()+","+f.concrete_types_ref.getValue().getDescr()+","+f.quant.getValue()+"м3";
	}
	else{
		inf = "Еще не брал";
	}
console.log(f)	
	var debt = f.client_debt.getValue();
	if(debt != undefined && debt!=0){
		inf = inf + ", " + this.getClientDebtText(debt);
		this.setClientDebt(debt);
	}
	this.getElement("client").getErrorControl().setValue(inf,"info");
	
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
	var descr_ac = this.getElement("descr").getAutoComplete();
	var dest_ac = this.getElement("calc").getElement("destination").getAutoComplete();
	if(!descr_ac || !dest_ac){
		return;
	}
	let descr_ac_pm = descr_ac.getPublicMethod();
	let dest_ac_pm = dest_ac.getPublicMethod();
	if(!descr_ac_pm || !dest_ac_pm){
		return
	}

	if(clientId){
		descr_ac_pm.setFieldValue("client_id",clientId);
		dest_ac_pm.setFieldValue("client_id",clientId);
	}
	else{
		descr_ac_pm.getField("client_id").resetValue();
		dest_ac_pm.getField("client_id").resetValue();		
	}
	
	descr_ac.setEnabled((clientId!==null));
}

OrderDialog_View.prototype.getClientDebtText = function(client_debt){
	var client_debt_pref = "";
	if(client_debt){
		client_debt_pref = "Долг: ";		
	}
	var client_debt_s = CommonHelper.numberFormat(client_debt, 2, ",", " " );	
	return client_debt_pref + client_debt_s + " руб.";
}

OrderDialog_View.prototype.setClientDebt = function(client_debt){
	var debt_n = document.getElementById(this.getId()+":client_debt");
	if(client_debt != undefined && client_debt != 0){		
		if(client_debt){
			DOMHelper.addClass(debt_n, "text-danger");
			
		}else if (client_debt < 0){
			DOMHelper.addClass(debt_n, "text-success");
		}
		var client_debt_s = CommonHelper.numberFormat(client_debt, 2, ",", " " );
		DOMHelper.setText(debt_n, this.getClientDebtText(client_debt));	
		DOMHelper.show(debt_n);
	}else{
		DOMHelper.setText(debt_n, "");	
		DOMHelper.hide(debt_n);
	}
}

OrderDialog_View.prototype.onGetData = function(resp,cmd){
	OrderDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	var m = this.getModel();

	var f = m.getField("clients_ref");
	if(!f.isNull()&&f.getValue()){
		this.setClientId(f.getValue().getKey());
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
		document.getElementById(id+":cmd-cont").style = "float:left;";
		DOMHelper.setText(document.getElementById(id+":last_modif_user"), last_modif_users_ref.getDescr());
		DOMHelper.setText(document.getElementById(id+":last_modif_date_time"), DateHelper.format(m.getFieldValue("last_modif_date_time"),"d/m/y H:i"));
	}

	//debts
	this.setClientDebt(m.getFieldValue("client_debt"));
	
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
	this.m_selectedContactId = m.getFieldValue("contact_id");	
	var descr = m.getFieldValue("descr");
	if(descr && descr.length && !m.getFieldValue("tm_exists")){
		this.showTMInvite();
	}else if(descr && descr.length){
		this.showTMInf(m.getFieldValue("tm_activated"), m.getFieldValue("tm_photo"), m.getFieldValue("tm_id"));
	}
	
	if(this.m_readOnly){
		this.setEnabled(false);
		this.getElement("comment_text").setEnabled(true);
		this.getControlOK().setEnabled(true);
	}
}

OrderDialog_View.prototype.getContactRef = function(callBack){
	var self = this;
	if(!this.m_selectedContactId){
		//no contact - create on descr + tel
		var descr = this.getElement("descr").getValue();
		if(!descr || !descr.length){
			window.showTempError("Не указано имя прораба!",null,5000);
			return;
		}
		var phone_cel = this.getElement("phone_cel").getValue();
		if(!phone_cel || !phone_cel.length){
			window.showTempError("Не указан телефон прораба!",null,5000);
			return;
		}
		var pm = (new Contact_Controller()).getPublicMethod("upsert");
		pm.setFieldValue("name", descr);
		pm.setFieldValue("tel", phone_cel);
		pm.run({
			"ok":function(resp){
				var m = resp.getModel("Ref_Model");
				if(m.getNextRow()){
					var r = m.getFieldValue("ref");
					self.m_selectedContactId = r.getKey();
					callBack(CommonHelper.unserialize(r));
				}
			}
		});						
	}else{
		callBack(new RefType({
			"keys": {"id": this.m_selectedContactId},
			"descr": this.getElement("descr").getValue(),
			"dataType": "contacts"
			})
		);
	}
}


