/** Copyright (c) 2026, Andrey Mikhalevich, Katren ltd.
 * A single editable contact; owned by OrderContactList.
 * @extends ControlContainer
 */
function OrderContactEdit(id, options){
	options = Object.assign({}, options || {});
	var value = options.value;
	delete options.value;
	this.m_readOnly = !!options.readOnly;
	this.m_onChange = options.onChange;
	this.m_clientId = options.clientId || null;
	this.m_revision = 0;
	this.m_removed = false;
	this.m_settingValue = false;
	this.m_pendingRef = false;
	this.m_linkId = null;
	this.m_contactId = null;
	this.m_identity = "";
	this.m_messengerKey = null;
	this.m_rendered = false;
	var self = this;
	var labelClass = options.labelClassName || "control-label "+window.getBsCol(2);
	options.className = options.className || "order-contact-row well well-sm";
	options.addElement = function(){
		var editOptions = {
			labelCaption: "Контакт:", labelClassName: labelClass, maxLength: 250,
			enabled: !self.m_readOnly,
			onClear: function(){ self.clearContact(); },
			events: {
				input: function(){ self.onEdit(); },
				change: function(){ self.onEdit(); },
				blur: function(){ self.onLeaveContact(); }
			},
			buttonSelect: new SendNotificationBtn(id+":btnSendNotif", {
				enabled: !self.m_readOnly,
				getRef: function(callback){ self.getContactRef(callback); }
			})
		};
		if(!self.m_readOnly){
			// PublicMethod objects contain mutable request fields; sharing the dialog's
			// instance makes one row's autocomplete overwrite another row's query.
			var ControllerClass = options.controllerClass || Order_Controller;
			self.m_controller = new ControllerClass();
			var model = new ModelXML("OrderDescr_Model", {fields: {
				descr: new FieldString("descr"), phone_cel: new FieldString("phone_cel"),
				contact_id: new FieldInt("contact_id"), tm_id: new FieldInt("tm_id"),
				tm_exists: new FieldBool("tm_exists"), tm_activated: new FieldBool("tm_activated"),
				tm_photo: new FieldString("tm_photo"), max_data: new FieldJSON("max_data")
			}});
			Object.assign(editOptions, {
				cmdAutoComplete: true, acMinLengthForQuery: 0,
				acController: self.m_controller, acModel: model,
				acPublicMethod: self.m_controller.getPublicMethod("complete_descr"),
				acPatternFieldId: "descr", acKeyFields: [model.getField("descr")],
				acICase: "1", acMid: "1", acEnabled: false,
				acDescrFunction: function(fields){ return self.completionText(fields); },
				acOnCompleteTextOut: function(textHTML, fields){ return self.completionHTML(textHTML, fields); },
				onSelect: function(fields){ self.onSelectDescr(fields); }
			});
		}
		this.addElement(new EditString(id+":descr", editOptions));
		this.addElement(new EditPhone(id+":phone_cel", {
			labelCaption: "Телефон:", labelClassName: labelClass,
			enabled: !self.m_readOnly,
			onClear: function(){ self.onEdit(); },
			events: {
				input: function(){ self.onEdit(); },
				change: function(){ self.onEdit(); },
				keyup: function(){ self.onEdit(); self.onLeaveContact(); },
				blur: function(){ self.onLeaveContact(); }
			}
		}));
		// Keep messenger controls separate from Edit's ErrorControl. Clearing a
		// messenger must not detach the input's validation error node.
		this.addElement(new ControlContainer(id+":messenger", "DIV", {className: "order-contact-messenger"}));
		this.addElement(new ButtonCtrl(id+":cmdDelete", {
			tagName: "BUTTON", attrs: {type: "button"},
			className: "btn btn-danger btn-sm", caption: "Удалить", glyph: "glyphicon-trash",
			title: "Убрать контакт из заявки (сам контакт не удаляется)",
			onClick: options.onDelete
		}));
		this.addElement(new ButtonCtrl(id+":cmdAdd", {
			tagName: "BUTTON", attrs: {type: "button", style: "margin-left: 6px;"},
			className: "btn btn-default btn-sm", caption: "Добавить", glyph: "glyphicon-plus",
			title: "Добавить еще один контакт", onClick: options.onAdd
		}));
	};
	OrderContactEdit.superclass.constructor.call(this, id, "DIV", options);
	this.setValue(value);
	this.setClientId(this.m_clientId);
	this.setEnabled(options.enabled !== false && !this.m_readOnly);
}
extend(OrderContactEdit, ControlContainer);

OrderContactEdit.parseId = function(value){
	if(value == null || value === "") return null;
	var id = Number(value);
	if((typeof value !== "number" && typeof value !== "string") || !/^[1-9][0-9]*$/.test(String(value))
		|| !Number.isSafeInteger(id) || id > 2147483647) throw new Error("Контакты: неверный идентификатор.");
	return id;
};
OrderContactEdit.normalizePhone = function(value){
	var phone = value == null ? "" : String(value).replace(/\D/g, "");
	if(phone.length === 11 && (phone[0] === "7" || phone[0] === "8")) phone = phone.substring(1);
	return phone;
};
OrderContactEdit.fieldValue = function(fields, name){
	return fields && fields[name] && fields[name].getValue ? fields[name].getValue() : undefined;
};
OrderContactEdit.escapeHTML = function(value){
	var span = document.createElement("span");
	span.textContent = value == null ? "" : String(value);
	return span.innerHTML;
};
OrderContactEdit.photoURL = function(value){
	if(!value) return null;
	try {
		var url = new URL(String(value), window.location.href);
		return url.protocol === "https:" || url.protocol === "http:" ? url.href : null;
	} catch(e) { return null; }
};
OrderContactEdit.pngURL = function(value){
	return value && /^[A-Za-z0-9+/=\s]+$/.test(value) ? "data:image/png;base64,"+value : null;
};
OrderContactEdit.prototype.currentIdentity = function(){
	return JSON.stringify([
		String(this.getElement("descr").getValue() || "").trim(),
		OrderContactEdit.normalizePhone(this.getElement("phone_cel").getValue())
	]);
};
OrderContactEdit.prototype.onEdit = function(){
	if(this.m_settingValue || this.m_removed) return;
	var identity = this.currentIdentity();
	if(identity !== this.m_identity){
		this.m_revision++;
		this.m_contactId = null; // Never send notifications to the previously selected person.
		this.m_identity = identity;
		this.hideMsngInvite();
		if(this.m_onChange) this.m_onChange();
	}
};
OrderContactEdit.prototype.clearContact = function(){
	this.m_settingValue = true;
	this.getElement("descr").setValue("");
	this.getElement("phone_cel").setValue("");
	this.m_settingValue = false;
	this.onEdit();
};
OrderContactEdit.prototype.setValue = function(value){
	value = value || {};
	var contact = value.contact || value;
	this.m_settingValue = true;
	this.m_revision++;
	this.m_linkId = OrderContactEdit.parseId(value.id);
	this.m_contactId = OrderContactEdit.parseId(value.contact_id || contact.contact_id || (value.contact && contact.id));
	this.getElement("descr").setValue(contact.name == null ? (contact.descr || "") : String(contact.name));
	this.getElement("phone_cel").setValue(OrderContactEdit.normalizePhone(contact.tel == null ? contact.phone_cel : contact.tel));
	this.m_identity = this.currentIdentity();
	this.m_settingValue = false;
	this.hideMsngInvite();
	if(!this.isNull()) this.showMessenger(value);
};
OrderContactEdit.prototype.getValue = function(){
	// Also catches programmatic edits and phone paste handlers that do not emit input.
	if(this.currentIdentity() !== this.m_identity) this.onEdit();
	var value = {contact: {
		name: String(this.getElement("descr").getValue() || "").trim(),
		tel: OrderContactEdit.normalizePhone(this.getElement("phone_cel").getValue())
	}};
	if(this.m_linkId) value.id = this.m_linkId;
	if(this.m_contactId) value.contact_id = this.m_contactId;
	return value;
};
OrderContactEdit.prototype.isNull = function(){
	return !String(this.getElement("descr").getValue() || "").trim()
		&& !OrderContactEdit.normalizePhone(this.getElement("phone_cel").getValue());
};
OrderContactEdit.prototype.focus = function(){ this.getElement("descr").focus(); };
OrderContactEdit.prototype.setValid = function(){
	this.getElement("descr").setValid();
	this.getElement("phone_cel").setValid();
};
OrderContactEdit.prototype.validate = function(){
	this.setValid();
	if(this.isNull()) return true;
	var value = this.getValue(), valid = true;
	if(!value.contact.name || value.contact.name.length > 250){
		this.getElement("descr").setNotValid("Укажите имя контакта (не более 250 символов).");
		valid = false;
	}
	if(!/^\d{10}$/.test(value.contact.tel)){
		this.getElement("phone_cel").setNotValid("Укажите телефон: 10 цифр без +7.");
		valid = false;
	}
	return valid;
};
OrderContactEdit.prototype.setClientId = function(clientId){
	this.m_clientId = clientId || null;
	var edit = this.getElement("descr"), ac = edit && edit.getAutoComplete();
	if(!ac) return;
	var pm = ac.getPublicMethod();
	if(pm){
		if(this.m_clientId) pm.setFieldValue("client_id", this.m_clientId);
		else pm.getField("client_id").resetValue();
	}
	ac.setEnabled(!!this.m_clientId && !this.m_readOnly && this.getEnabled());
};
OrderContactEdit.prototype.setEnabled = function(enabled){
	OrderContactEdit.superclass.setEnabled.call(this, !!enabled && !this.m_readOnly);
	if(this.m_elements && this.getElement("descr")) this.setClientId(this.m_clientId);
};
OrderContactEdit.prototype.completionText = function(fields){
	var get = OrderContactEdit.fieldValue;
	var service = get(fields, "max_data") ? "MAX" :
		(get(fields, "tm_exists") && get(fields, "tm_activated") ? "Telegram" : "СМС");
	var phone = get(fields, "phone_cel") || "";
	var mask = window.getApp().getPhoneEditMask();
	return (get(fields, "descr") || "")+" "+(mask ? CommonHelper.maskFormat(phone, mask) : phone)+" ("+service+")";
};
OrderContactEdit.prototype.completionHTML = function(textHTML, fields){
	if(!fields) return textHTML;
	var get = OrderContactEdit.fieldValue, max = get(fields, "max_data");
	var src = max && OrderContactEdit.photoURL(max.avatar_url);
	if(!src) src = OrderContactEdit.pngURL(get(fields, "tm_photo"));
	var prefix = "";
	if(src){
		var img = document.createElement("img");
		img.className = "contactPhoto";
		img.src = src;
		img.alt = "";
		prefix = img.outerHTML;
	}
	// No global DOMHelper.delNodesOnClass: other rows' photos must survive.
	return prefix+OrderContactEdit.escapeHTML(this.completionText(fields));
};
OrderContactEdit.prototype.onSelectDescr = function(fields){
	if(this.m_removed || this.m_readOnly || !this.getEnabled()) return;
	var get = OrderContactEdit.fieldValue;
	this.m_settingValue = true;
	this.getElement("descr").setValue(get(fields, "descr") || "");
	this.getElement("phone_cel").setValue(OrderContactEdit.normalizePhone(get(fields, "phone_cel")));
	this.m_contactId = OrderContactEdit.parseId(get(fields, "contact_id"));
	this.m_identity = this.currentIdentity();
	this.m_revision++;
	this.m_settingValue = false;
	this.showMessenger({
		max_data: get(fields, "max_data"), tm_exists: get(fields, "tm_exists"),
		tm_activated: get(fields, "tm_activated"), tm_photo: get(fields, "tm_photo"), tm_id: get(fields, "tm_id")
	});
	if(this.m_onChange) this.m_onChange();
};
OrderContactEdit.prototype.onLeaveContact = function(){
	this.onEdit();
	if(!this.m_readOnly && !this.m_contactId && !this.isNull()
		&& /^\d{10}$/.test(OrderContactEdit.normalizePhone(this.getElement("phone_cel").getValue()))
		&& String(this.getElement("descr").getValue() || "").trim()) this.showMaxInvite();
};

OrderContactEdit.prototype.hideMsngInvite = function(){
	if(this.m_photoTip){
		if(this.m_photoTip.m_timeout) clearTimeout(this.m_photoTip.m_timeout);
		this.m_photoTip.removeEvent();
		if(this.m_photoTip.m_active) this.m_photoTip.remove();
		this.m_photoTip = null;
	}
	this.m_messengerKey = null;
	var container = this.getElement("messenger");
	if(container) container.clear();
};
OrderContactEdit.prototype.renderMessenger = function(){
	var container = this.getElement("messenger");
	container.setEnabled(this.getEnabled() && !this.m_readOnly);
	if(this.m_rendered) container.toDOM(this.getNode());
};
OrderContactEdit.prototype.addMaxInviteToCont = function(container){
	if(this.m_readOnly) return;
	var self = this;
	container.addElement(new MAXInviteBtn(container.getId()+":maxInvite", {
		onClick: function(){
			self.getContactRef(function(ref){
				var revision = self.m_revision;
				window.getApp().MAXInviteContact(ref, function(){
					if(!self.m_removed && self.m_revision === revision) self.hideMsngInvite();
				});
			});
		}
	}));
	container.addElement(new MAXShowQRBtn(container.getId()+":maxQR", {attrs: {style: "margin-left: 3px;"}}));
};
OrderContactEdit.prototype.showMaxInvite = function(){
	if(this.m_readOnly || this.m_messengerKey === "invite") return;
	this.hideMsngInvite();
	this.m_messengerKey = "invite";
	this.addMaxInviteToCont(this.getElement("messenger"));
	this.renderMessenger();
};
OrderContactEdit.prototype.addPhoto = function(src, largeSrc, tmId){
	if(!src) return;
	var container = this.getElement("messenger"), self = this, revision = this.m_revision;
	var image = new Control(container.getId()+":photo", "IMG", {attrs: {
		class: "contactPhoto", src: src, alt: "", width: "35", height: "35"
	}});
	container.addElement(image);
	this.m_photoTip = new ToolTip({node: image.getNode(), wait: 2, onHover: function(){
		var tip = this;
		function show(url){
			if(!url || self.m_removed || self.m_revision !== revision) return;
			var img = document.createElement("img");
			img.src = url; img.alt = "";
			tip.popup("<div>"+img.outerHTML+"</div>", {title: "Данные по контакту"});
		}
		if(tmId && !largeSrc){
			var pm = (new TmUser_Controller()).getPublicMethod("get_object");
			pm.setFieldValue("id", tmId);
			pm.run({ok: function(resp){
				if(self.m_removed || self.m_revision !== revision) return;
				var model = resp.getModel("TmUserDialog_Model");
				if(model.getNextRow()){
					largeSrc = OrderContactEdit.pngURL(model.getFieldValue("tm_photo"));
					show(largeSrc);
				}
			}});
		} else show(largeSrc || src);
	}});
};
OrderContactEdit.prototype.showMessenger = function(data){
	this.hideMsngInvite();
	var max = data.max_data, container = this.getElement("messenger");
	if(max){
		this.m_messengerKey = "max";
		this.addPhoto(OrderContactEdit.photoURL(max.avatar_url), OrderContactEdit.photoURL(max.avatar_url));
		container.addElement(new Control(container.getId()+":status", "SPAN", {
			value: "Пользователь MAX", className: "help-block text-info"
		}));
	} else if(data.tm_exists){
		this.m_messengerKey = "telegram";
		this.addPhoto(OrderContactEdit.pngURL(data.tm_photo), null, data.tm_id);
		container.addElement(new Control(container.getId()+":status", "SPAN", {
			value: data.tm_activated ? "Пользователь Telegram" : "Сообщение отправлено, Telegram не активирован",
			className: "help-block text-info"
		}));
		this.addMaxInviteToCont(container);
	} else {
		this.showMaxInvite();
		return;
	}
	this.renderMessenger();
};

OrderContactEdit.prototype.getContactRef = function(callback){
	if(this.m_removed || this.m_readOnly || !this.getEnabled() || this.m_pendingRef) return;
	this.onEdit();
	if(!this.validate() || this.isNull()) return;
	var value = this.getValue();
	if(this.m_contactId){
		callback(new RefType({keys: {id: this.m_contactId}, descr: value.contact.name, dataType: "contacts"}));
		return;
	}
	// Explicit notification/invitation may create a Contact immediately, just as
	// before. It never creates an order_contacts association before saving the order.
	var self = this, revision = this.m_revision, identity = this.currentIdentity();
	var pm = (new Contact_Controller()).getPublicMethod("upsert");
	pm.setFieldValue("name", value.contact.name);
	pm.setFieldValue("tel", value.contact.tel);
	this.m_pendingRef = true;
	try {
		pm.run({
			ok: function(resp){
				if(self.m_removed || revision !== self.m_revision || identity !== self.currentIdentity()) return;
				var model = resp.getModel("Ref_Model");
				if(!model || !model.getNextRow()) throw new Error("Не удалось получить созданный контакт.");
				// The supplied PHP method returns contacts_ref; older versions returned ref.
				var fields = model.getFields();
				var ref = fields.contacts_ref ? fields.contacts_ref.getValue() :
					(fields.ref ? fields.ref.getValue() : null);
				if(typeof ref === "string") ref = CommonHelper.unserialize(ref);
				if(ref && !ref.getKey) ref = new RefType(ref);
				if(!ref || ref.isNull()) throw new Error("Не удалось получить ссылку на контакт.");
				self.m_contactId = OrderContactEdit.parseId(ref.getKey("id"));
				if(self.m_onChange) self.m_onChange();
				callback(ref);
			},
			all: function(){ self.m_pendingRef = false; }
		});
	} catch(e){ this.m_pendingRef = false; throw e; }
};
OrderContactEdit.prototype.toDOM = function(parent){
	this.m_removed = false;
	OrderContactEdit.superclass.toDOM.call(this, parent);
	this.m_rendered = true;
};
OrderContactEdit.prototype.delDOM = function(){
	this.m_removed = true;
	this.m_rendered = false;
	this.m_revision++;
	this.hideMsngInvite();
	OrderContactEdit.superclass.delDOM.call(this);
};

