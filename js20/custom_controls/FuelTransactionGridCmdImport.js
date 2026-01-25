/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2026

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function FuelTransactionGridCmdImport(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;

	this.m_getClientId = options.getClientId;
	
	var self = this;
	this.m_btn = new ButtonCmd(id+"btn",{
		"caption":" Импорт ",
		"glyph":"glyphicon-open-file",
		"title":"Импорт данных из файла ексель",
		"onClick":function(){
			self.importData();
		}
	});
	
	options.controls = [
		this.m_btn
	]
	FuelTransactionGridCmdImport.superclass.constructor.call(this,id,options);
}
extend(FuelTransactionGridCmdImport, GridCmd);

/* Constants */


/* private members */

/* protected*/
FuelTransactionGridCmdImport.prototype.importDataCont = function(fileExcel){
	if(!fileExcel || !fileExcel.length){
		throw new Error("file not found");
	}
	//execute command and refresh list
	const pm = (new FuelTransaction_Controller()).getPublicMethod("import_data");
	pm.setFieldValue("file_excel", fileExcel);

	const self = this;
	window.setGlobalWait(true);
	pm.run({
		"ok": function(){
			self.getGrid().onRefresh(function(){
				window.showTempNote("Обновлен список транзакций",null,5000);
			});
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	});
}

FuelTransactionGridCmdImport.prototype.importData = function(){
	const self = this;
	this.m_form = new WindowFormModalBS("selectFile",{
		"dialogWidth":"30%",
		"cmdOk":true,		
		"onClickOk":function(){
			self.importDataCont(this.getContent().getElement("file_excel").getValue());
			this.close();
		},
		"cmdCancel":true,
		"onClickCancel":function(){
			this.close();
		},
		"cmdClose":true,
		"content":new View("selectFile:view", {
			addElement: function(){
				this.addElement(new EditFile("selectFile:view:file_excel",{
					labelCaption: "Файл транзакций:",
				}));	
			}
		})
	});
	this.m_form.open();
}

