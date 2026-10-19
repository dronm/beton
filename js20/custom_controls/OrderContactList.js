/** Copyright (c) 2026, Andrey Mikhalevich, Katren ltd.
 * Ordered, editable order contacts. No requests are made by Add/Delete.
 *
 * @extends ControlContainer
 * @requires custom_controls/OrderContactEdit.js
 *
 * value: [{id: <order_contacts.id>, contact: {name: "...", tel: "..."}}]
 * contact_id is optional and is added when an existing contact is selected.
 * IMPORTANT: a row's id is NOT contacts.id.
 */
function OrderContactList(id, options){
	options = Object.assign( options || {});
	var value = options.value !== undefined ? options.value : options.valueJSON;
	delete options.value; // Control's constructor would call setValue before m_elements exists.
	delete options.valueJSON;
	this.m_rows = [];
	this.m_nextRowId = 0;
	this.m_readOnly = !!options.readOnly;
	this.m_clientId = options.clientId || null;
	this.m_rowOptions = Object.assign({}, options.rowOptions || {});
	this.m_controllerClass = options.controllerClass || Order_Controller;
	this.m_onChange = options.onChange;
	this.m_formatFunction = options.formatFunction;
	this.m_rendered = false;
	this.m_initialValue = "[]";
	options.className = options.className || "order-contact-list";
	OrderContactList.superclass.constructor.call(this, id, "DIV", options);
	this.setInitValue(value);
}
extend(OrderContactList, ControlContainer);

OrderContactList.prototype.parseValue = function(value){
	if(typeof value === "string"){
		try { value = JSON.parse(value); }
		catch(e) { throw new Error("Контакты: некорректный JSON."); }
	}
	if(value == null) return [];
	if(!Array.isArray(value)) throw new Error("Контакты: ожидается массив.");
	return value.map(function(row){
		if(!row || typeof row !== "object" || Array.isArray(row)){
			throw new Error("Контакты: неверный формат строки.");
		}
		var contact = row.contact || row; // Also accepts plain {name, tel} for reuse.
		if(typeof contact !== "object" || Array.isArray(contact)){
			throw new Error("Контакты: неверный формат контактных данных.");
		}
		return {
			id: row.contact ? OrderContactEdit.parseId(row.id) : null,
			contact_id: OrderContactEdit.parseId(row.contact_id || contact.contact_id || (row.contact && contact.id)),
			contact: {
				name: String(contact.name == null ? (contact.descr || "") : contact.name),
				tel: OrderContactEdit.normalizePhone(contact.tel == null ? contact.phone_cel : contact.tel)
			},
			max_data: row.max_data || contact.max_data,
			tm_exists: row.tm_exists || contact.tm_exists,
			tm_activated: row.tm_activated || contact.tm_activated,
			tm_photo: row.tm_photo || contact.tm_photo,
			tm_id: row.tm_id || contact.tm_id
		};
	});
};

OrderContactList.prototype.createRow = function(value){
	var self = this;
	// Never reuse an index after deletion: delayed callbacks must not target another row.
	var row = new OrderContactEdit(this.getId()+":row"+(++this.m_nextRowId), Object.assign({}, this.m_rowOptions, {
		value: value,
		readOnly: this.m_readOnly,
		enabled: this.getEnabled() && !this.m_readOnly,
		clientId: this.m_clientId,
		controllerClass: this.m_controllerClass,
		onDelete: function(){ self.removeContact(row); },
		onAdd: function(){ self.addContact(); },
		onChange: function(){ self.changed(); }
	}));
	this.m_rows.push(row);
	this.addElement(row);
	return row;
};

OrderContactList.prototype.setValue = function(value){
	var rows = this.parseValue(value); // Parse first; a bad value must not erase existing edits.
	this.clear();
	this.m_rows = [];
	for(var i=0; i<rows.length; i++) this.createRow(rows[i]);
	// One empty editor makes the empty list usable; it is not serialized as a contact.
	if(!this.m_rows.length) this.createRow(null);
	this.updateButtons();
	if(this.m_rendered) this.elementsToDOM();
};

OrderContactList.prototype.setInitValue = function(value){
	this.setValue(value);
	this.m_initialValue = JSON.stringify(this.getValue());
};
OrderContactList.prototype.getInitValue = function(){ return JSON.parse(this.m_initialValue); };
OrderContactList.prototype.getValue = function(){
	return this.m_rows.filter(function(row){ return !row.isNull(); }).map(function(row){ return row.getValue(); });
};
OrderContactList.prototype.getValueJSON = OrderContactList.prototype.getValue;
OrderContactList.prototype.getModified = function(){ return JSON.stringify(this.getValue()) !== this.m_initialValue; };
OrderContactList.prototype.getIsRef = function(){ return false; };
OrderContactList.prototype.isNull = function(){ return this.getValue().length === 0; };
OrderContactList.prototype.reset = function(){ this.setValue([]); this.changed(); };
OrderContactList.prototype.getRows = function(){ return this.m_rows.slice(); };
OrderContactList.prototype.focus = function(){ if(this.m_rows[0]) this.m_rows[0].focus(); };
OrderContactList.prototype.changed = function(){ if(this.m_onChange) this.m_onChange(this.getValue()); };

OrderContactList.prototype.addContact = function(value){
	if(this.m_readOnly || !this.getEnabled()) return null;
	var row = this.createRow(value);
	this.updateButtons();
	if(this.m_rendered){ row.toDOM(this.getNode()); row.focus(); }
	this.changed();
	return row;
};
OrderContactList.prototype.removeContact = function(row){
	if(this.m_readOnly || !this.getEnabled()) return false;
	var index = this.m_rows.indexOf(row);
	if(index < 0) return false;
	this.m_rows.splice(index, 1);
	this.delElement(row.getName()); // This removes controls, NOT a contact in the database.
	if(!this.m_rows.length){
		var empty = this.createRow(null);
		if(this.m_rendered) empty.toDOM(this.getNode());
	}
	this.updateButtons();
	this.changed();
	return true;
};
OrderContactList.prototype.updateButtons = function(){
	var canEdit = this.getEnabled() && !this.m_readOnly;
	this.m_rows.forEach(function(row, index, rows){
		row.getElement("cmdDelete").setVisible(!this.m_readOnly);
		row.getElement("cmdDelete").setEnabled(canEdit);
		row.getElement("cmdAdd").setVisible(!this.m_readOnly && index === rows.length-1);
		row.getElement("cmdAdd").setEnabled(canEdit);
	}, this);
};
OrderContactList.prototype.setEnabled = function(enabled){
	OrderContactList.superclass.setEnabled.call(this, !!enabled && !this.m_readOnly);
	if(this.m_rows) this.updateButtons();
};
OrderContactList.prototype.setClientId = function(clientId){
	this.m_clientId = clientId || null;
	this.m_rows.forEach(function(row){ row.setClientId(this.m_clientId); }, this);
};
OrderContactList.prototype.setSuggestedContact = function(name, tel){
	// Selecting a different client must not silently replace edited contacts.
	if(this.isNull() && (name || tel)) this.setValue([{contact: {name: name || "", tel: tel || ""}}]);
};
OrderContactList.prototype.prepareCopy = function(){
	var values = this.getValue();
	values.forEach(function(row){ delete row.id; }); // Association IDs belong to the source order.
	this.setValue(values);
	this.m_initialValue = "[]"; // Copy must submit even unchanged contacts.
};
OrderContactList.prototype.setValid = function(){
	this.m_rows.forEach(function(row){ row.setValid(); });
};
OrderContactList.prototype.setNotValid = function(message){
	if(this.m_rows[0]) this.m_rows[0].getElement("descr").setNotValid(message);
};
OrderContactList.prototype.validate = function(){
	this.setValid();
	var valid = true, ids = {}, phones = {};
	this.m_rows.forEach(function(row){
		if(row.isNull()) return;
		if(!row.validate()) { valid = false; return; }
		var value = row.getValue(), phone = value.contact.tel;
		if((value.contact_id && ids[value.contact_id]) || phones[phone]){
			row.getElement("phone_cel").setNotValid("Этот контакт уже добавлен в заявку.");
			valid = false;
		}
		if(value.contact_id) ids[value.contact_id] = true;
		phones[phone] = true;
	});
	return valid;
};
OrderContactList.prototype.toDOM = function(parent){
	OrderContactList.superclass.toDOM.call(this, parent);
	this.m_rendered = true;
};
OrderContactList.prototype.delDOM = function(){
	this.m_rendered = false;
	OrderContactList.superclass.delDOM.call(this);
};

OrderContactList.prototype.getFormatFunction = function(){ return this.m_formatFunction; };

/** FieldJSON.isSet() in this framework treats [] as unset. Scope the correction
 * to this one command field; otherwise deleting the last contact is never sent. */
OrderContactList.configurePublicMethod = function(pm){
	var field = pm.getField("contact_list");
	field.isSet = function(){ return this.getValue() !== undefined; };
	field.isNull = function(){ return this.getValue() == null; };
};

