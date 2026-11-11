//"use strict";
// @ts-nocheck -- Legacy view framework is untyped. This is the source for ContactDialog_View.js.
/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017,2025
 
 * @extends ViewObjectAjx.js
 * @requires core/extend.js
 * @requires controls/ViewObjectAjx.js
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {object} options
 * @param {object} options.models All data models
 * @param {object} options.variantStorage {name,model}
 */
function ContactDialog_View(id, options) {
	options = options || {};
	options.controller = new Contact_Controller();
	if (options.models && options.models.ContactDialog_Model) {
		options.model = options.models.ContactDialog_Model;
	}
	var max_inv_vis = true;
	// var tm_inv_vis = true;
	if (options.model && options.model.getNextRow()) {
		if (options.model.getFieldValue("tm_activated")) {
			options.templateOptions = options.templateOptions || {};
			options.templateOptions.TM_ACTIVATED = true;
			options.templateOptions.TM_PHOTO = options.model.getFieldValue("tm_photo");
			// tm_inv_vis = false;
		}
		const max_data = options.model.getFieldValue("max_data");
		if (max_data) {
			options.templateOptions = options.templateOptions || {};
			options.templateOptions.MAX_ACTIVATED = true;
			options.templateOptions.MAX_PHOTO = max_data.avatar_url;
			max_inv_vis = false;
		}
	}
	var self = this;
	options.addElement = function () {
		this.addElement(new EditString(id + ":name", {
			"required": true,
			"focus": true,
			"maxLength": 250,
			"labelCaption": "Фамилия имя отчество",
			"placeholder": "ФИО",
			"title": "Фамилия имя отчество физического лица"
		}));
		this.addElement(new PostEdit(id + ":posts_ref", {
			"placeholder": "Должность",
			"title": "Должность физического лица"
		}));
		this.addElement(new EditEmail(id + ":email", {
			"labelCaption": "Эл.почта:",
			"title": "Адрес электронной почты",
			"placeholder": "Адрес электронной почты"
		}));
		this.addElement(new EditPhone(id + ":tel", {
			"labelCaption": "Телефон:",
			"title": "Телефон физического лица"
		}));
		this.addElement(new EditString(id + ":tel_ext", {
			"labelCaption": "Добавочный номер:",
			"placeholder": "Добавочный номер телефона",
			"title": "Добавочный номер телефона физического лиц"
		}));
		this.addElement(new EditText(id + ":comment_text", {
			"labelCaption": "Коммантарий:",
			"title": "Коммантарий менеджера о физическом лице"
		}));
		/*
		this.addElement(new ButtonCtrl(id+":btnTmInvite",{
			"caption":"Пригласить в Telegram:",
			"title":"Отправить контакту приглашение в Telegram",
			"glyph":"glyphicon-send",
			"visible": tm_inv_vis,
			"onClick": function(){
				var b = this;
				b.setEnabled(false);
				window.getApp().TMInviteContact(
					new RefType({"keys" :{"id": self.getElement("id").getValue()},
						"descr": self.getElement("name").getValue(),
						"dataType": "contacts"
						}),
					function(){
						b.setEnabled(true);
					}
				);
			}
		}));
		*/
		/*
	this.addElement(new ButtonCtrl(id+":btnMaxInvite",{
		"caption":" СМС для регистрации в MAX",
		"title":"Отправить контакту СМС с приглашением в MAX",
		"visible": max_inv_vis,
		"onClick": function(){
			var b = this;
			b.setEnabled(false);
			window.getApp().MAXInviteContact(
				new RefType({"keys" :{"id": self.getElement("id").getValue()},
					"descr": self.getElement("name").getValue(),
					"dataType": "contacts"
					}),
				function(){
					b.setEnabled(true);
				}
			);
		}
	}));	*/
		this.addElement(new MAXInviteBtn(id + ":btnMaxInvite", {
			"self": this,
			"getRef": (function (self) {
				return function () {
					return new RefType({
						"keys": { "id": self.getElement("id").getValue() },
						"descr": self.getElement("name").getValue(),
						"dataType": "contacts"
					});
				};
			})(this),
			"visible": max_inv_vis
		}));
		this.addElement(new MAXShowQRBtn(id + ":btnMaxQR", { "visible": max_inv_vis }));
		this.addElement(new ButtonCtrl(id + ":editFacsimile", {
			"caption": "Редактировать факсимиле",
			"glyph": "glyphicon-edit",
			"onClick": () => self.openFacsimile(),
		}));
		this.addElement(new EditFile(id + ":attachments_list", {
			"maxWidth": "100",
			"maxHeight": "100",
			"multipleFiles": false,
			"showHref": true,
			"showPic": false,
			"onDeleteFile": function (fileId, callBack) {
				self.m_attachManager.deleteAttachment(fileId, callBack);
			},
			"onFileAdded": function (fileId) {
				//self.addAttachment(fileId);
				self.m_attachManager.addAttachment(fileId, () => {
					self.openFacsimile(fileId);
				});
			},
			"onDownload": function (fileId) {
				self.m_attachManager.downloadAttachment(fileId);
			},
			"allowedFileExtList": ["jpeg", "png", "jpg"],
			"allowedFileTypeList": ["image/jpeg", "image/png"]
		}));
	};
	ContactDialog_View.superclass.constructor.call(this, id, options);
	this.m_attachManager = new AttachmentManager({
		"view": this,
		"dataType": "contacts",
		"attachmentViewName": "attachments_list"
	});
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({ "control": this.getElement("name") }),
		new DataBinding({ "control": this.getElement("posts_ref"), "fieldId": "posts_ref" }),
		new DataBinding({ "control": this.getElement("email") }),
		new DataBinding({ "control": this.getElement("tel") }),
		new DataBinding({ "control": this.getElement("tel_ext") }),
		new DataBinding({ "control": this.getElement("comment_text") }),
		new DataBinding({ "control": this.getElement("attachments_list") })
	]);
	//write
	this.setWriteBindings([
		new CommandBinding({ "control": this.getElement("name") }),
		new CommandBinding({ "control": this.getElement("posts_ref"), "fieldId": "post_id" }),
		new CommandBinding({ "control": this.getElement("email") }),
		new CommandBinding({ "control": this.getElement("tel") }),
		new CommandBinding({ "control": this.getElement("tel_ext") }),
		new CommandBinding({ "control": this.getElement("comment_text") })
	]);
}
extend(ContactDialog_View, ViewObjectAjx);
ContactDialog_View.prototype.openFacsimile = function (fileId) {
	if (this.m_facsimileEditor) {
		return;
	}
	const attachmentControl = this.getElement("attachments_list");
	const files = attachmentControl.getFiles() || [];
	let file = files.find((item) => !fileId || String(item.id || item.file_id) === String(fileId));
	// The legacy EditFile.setValue renders stored files without populating getFiles().
	if (!file) {
		const renderedFile = attachmentControl.getFileControls().find((control) => !fileId || String(control.getId()) === String(fileId));
		if (renderedFile) {
			const href = document.getElementById(renderedFile.getId() + "-href");
			file = {
				id: renderedFile.getId(),
				uploaded: (href === null || href === void 0 ? void 0 : href.getAttribute("file_uploaded")) === "true",
			};
		}
	}
	const contactId = Number(this.getElement("id").getValue());
	if (!contactId || !file || !file.uploaded) {
		window.showError("Сначала загрузите изображение факсимиле и дождитесь окончания загрузки.");
		return;
	}
	const contentId = String(file.id || file.file_id);
	this.m_facsimileEditor = new ContactFacsimileEditor({
		contactId,
		contentId,
		onSaved: (row) => {
			this.getElement("attachments_list").setValue([{
					id: contentId,
					name: row.name,
					size: row.size,
					dataBase64: row.data_base64,
					uploaded: true,
				}]);
		},
		onClosed: () => {
			this.m_facsimileEditor = null;
		},
	});
	this.m_facsimileEditor.open();
};
