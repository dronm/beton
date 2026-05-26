/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024

 * @extends GridAjx
 * @requires core/extend.js
 * @requires GridAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function InsuranceListGrid(id,options){
	var model = new InsuranceList_Model({
		"sequences":{"id":0}
	});

	this.m_dataType = options.dataType;
	this.m_allowedFileExtList = ["jpg", "png", "pdf", "docx"];

	const self = this;
	const cells = [
		new GridCellHead(id+":head:issuer",{
			"value":"Страховщик",
			"columns":[
				new GridColumn({
					"field":model.getField("issuer"),
					"ctrlClass":InsuranceIssuerEdit,
					"ctrlOptions":{
						"labelCaption":""
					}
				})
			]
		})
		,new GridCellHead(id+":head:total",{
			"value":"Сумма",
			"columns":[
				new GridColumnFloat({
					"field":model.getField("total"),
					"precision":"2",
					"length":"15"
				})
			]
		})
		,new GridCellHead(id+":head:dt_from",{
			"value":"Дата с",
			"columns":[
				new GridColumnDate({
					"field":model.getField("dt_from")
				})
			]
		})
		,new GridCellHead(id+":head:dt_to",{
			"value":"Дата по",
			"columns":[
				new GridColumnDate({
					"field":model.getField("dt_to")
				})
			]
		})
		,new GridCellHead(id+":head:attachments_list",{
			"value":"Документы",
			"columns":[
				new GridColumn({
					"cellOptions":function(column,row){
						return self.getAttachmentCellOpts(column, row);
					}
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["id"],
		"controller":new InsuranceList_Controller({"clientModel":model}),
		"editInline":true,
		"editWinClass":null,
		"popUpMenu":new PopUpMenu(),
		"commands":new GridCmdContainerAjx(id+":cmd",{
			"cmdSearch":false,
			"cmdExport":false,
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"cmdAllCommands":false
		}),
		"readOnly":true,
		"head":new GridHead(id+":head",{
			"elements":[
				new GridRow(id+":head:row0",{
					"elements":cells
				})
			]
		}),
		"pagination":null,				
		"autoRefresh":false,
		"refreshInterval":0,
		"rowSelect":true
	};	
	InsuranceListGrid.superclass.constructor.call(this,id,options);

}
extend(InsuranceListGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */
InsuranceListGrid.prototype.getAttachmentCellOpts = function(column, row){
	const res = {};
	const insId = this.m_model.getFieldValue("id");
	const self = this;

	const ctrl = new ButtonCmd(null,{
		"glyph":"glyphicon-plus",
		"attrs":{
			"style": "margin-right: 10px;"
		},
		"caption":" Документ ",
		"title": "Добавить документ ",
		"onClick":(function(keyId){												
			return function(){
				self.addAttachment(this,keyId);
			}
		})(insId)
	});										
	ctrl.m_row = row;
	
	res.elements = [ctrl];
	const att = this.m_model.getFieldValue("attachments");
	if(att && CommonHelper.isArray(att) && att.length>0){
		res.elements.push(self.genAttContainer(insId, att[0]));
	}
	
	return res;
}

InsuranceListGrid.prototype.getRefAsStr = function(id){
	return CommonHelper.serialize(new RefType({"dataType":this.m_dataType, "keys": {"id": id}}));
}

InsuranceListGrid.prototype.addAttachmentCont = function(btnCont, keyId, fl){
	//check type
	if(this.m_allowedFileExtList){
		//extension list
		var ext_ar = fl.name.split(".");
		if(!ext_ar.length || ext_ar.length<2){
			throw new Error(EditFile.prototype.ER_EXT_NOT_DEFINED);
		}
		if(CommonHelper.inArray(ext_ar[ext_ar.length-1].toLowerCase(),this.m_allowedFileExtList)==-1){
			throw new Error(CommonHelper.format(EditFile.prototype.ER_EXT_NOT_ALLOWED,ext_ar[ext_ar.length-1]));
		}
	}

	const pm = (new Attachment_Controller).getPublicMethod("add_file");
	pm.setFieldValue("ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_data", [fl]);
	pm.setFieldValue("content_info", CommonHelper.serialize({"id": CommonHelper.uniqid(), "name": fl.name, "size": 0}));

	window.setGlobalWait(true);
	btnCont.setEnabled(false);
	const self = this;
	pm.run({
		"ok":function(){
			const attachment = {name: fl.name, size: fl.size, id: keyId };
			const cont = self.genAttContainer(keyId, attachment);
			cont.toDOM(btnCont.m_node.parentNode);
			window.showTempNote("Документ загружен", null, 3000);
		},
		"all":function(){
			window.setGlobalWait(false);
			btnCont.setEnabled(true);
		}
	});
}

InsuranceListGrid.prototype.addAttachment = function(btnCont, keyId){	
	const self = this;
	const fl = $('<input type="file"/>');
	fl.change(function(e) { 
		self.addAttachmentCont(btnCont, keyId, e.target.files[0])
	});
	fl.click();
}	

InsuranceListGrid.prototype.getAttachment = function(keyId, fileId){
	const pm = (new Attachment_Controller()).getPublicMethod("get_file");
	pm.setFieldValue("ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_id", fileId);
	pm.setFieldValue("inline",1);	

	const offset = 0;
	const h = $( window ).width()/3*2;
	const left = $( window ).width()/2;
	const w = left - 20;	
	pm.openHref("ViewXML", "location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);
	//pm.download();
}

InsuranceListGrid.prototype.delAttachment = function(keyId, fileId){
	const self = this;
	WindowQuestion.show({
		"no":false,
		"text":"Удалить документ?",
		"callBack": function(){
			self.delAttachmentCont(keyId, fileId);
		}
	});
}

InsuranceListGrid.prototype.delAttachmentCont = function(keyId, fileId){
	const pm = (new Attachment_Controller()).getPublicMethod("delete_file");
	pm.setFieldValue("ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_id", fileId);
	const self = this;
	pm.run({
		"ok":function(){
			const ctrlNode = document.getElementById(`att_doc_id_${self.m_dataType}_${keyId}_cont`);
			if(ctrlNode){
				DOMHelper.delNode(ctrlNode);
			}
			window.showTempNote("Документ удален", null, 3000);
		}
	});
}

InsuranceListGrid.prototype.delRow = function(rowNode){
	this.setModelToCurrentRow();
	const att = this.m_model.getFieldValue("attachments");
	if(att && att.length){
		const id = this.m_model.getFieldValue("id");
		for(let i = 0; i< att.length; i--){
			if(att[i] && att[i].id){
				this.delAttachmentCont(id, att[i].id );
			}
		}
	}
	InsuranceListGrid.superclass.delRow.call(this, rowNode);
}

InsuranceListGrid.prototype.genAttContainer = function(insId, attachment){
	const self = this;
	return new ControlContainer(`att_doc_id_${self.m_dataType}_${insId}_cont`,"DIV",{
		"elements": [
			new Control(`att_doc_id_${self.m_dataType}_${insId}`,"IMG",{
				"attrs":{
					"src": "data:image/png;base64, "+attachment.dataBase64,
					"width": "50px",
					"height": "50px",
					"title": attachment["name"]+" ("+CommonHelper.byteFormat(attachment["size"],2)+")",
					"style":"cursor:pointer;"
				},
				"events":{
					"click":(function(keyId, fileId){
						return function(e){
							self.getAttachment(keyId, fileId);
						}
					})(insId, attachment.id)
				}
			}),
			//delete
			new Control(null,"I",{
				"attrs":{
					"class":"glyphicon glyphicon-trash",
					//"glyphicon glyphicon-remove-circle",
					"title": "Удалить документ",
					"style":"cursor:pointer;"
				},
				"events":{
					"click":(function(keyId, fileId){
						return function(e){
							self.delAttachment(keyId, fileId);
						}
					})(insId, attachment.id)
				}
			})
		]
	});
}
