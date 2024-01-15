/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2021
 
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
function ExcelTemplateDialog_View(id,options){	

	options = options || {};

	options.controller = new ExcelTemplate_Controller();
	options.model = options.models.ExcelTemplateDialog_Model;
	
	options.addElement = function(){
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:",
			"required":true,
			"maxLength":500
		}));	
			
		this.addElement(new EditText(id+":sql_query",{
			"labelCaption":"Запрос к базе данных:"
		}));	
		
		var self = this;
		this.addElement(new EditFile(id+":excel_file",{
			"labelCaption":"Файл шаблона:",
			"showHref":true,
			"showPic":false,
			"fileInfTemplate":window.getApp().getTemplate("EmployeePhoto"),
			"onDeleteFile":function(fileId){
				self.deleteExcelFile(fileId);
			}
			,"onFileAdded":function(fileId){
				self.excelFileAdded(fileId);
			}
			,"onDownload":function(fileId){
				self.downloadFile(fileId);
			}
			,"allowedFileExtList":["xlsx","xls"]
		}));		

		//********* cell_matching grid ***********************
		this.addElement(new ExcelTemplateFieldMatchGrid(id+":cell_matching",{
		}));		

	}
	
	ExcelTemplateDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("sql_query")})
		,new DataBinding({"control":this.getElement("cell_matching")})
		,new DataBinding({"control":this.getElement("excel_file"),"field":this.m_model.getField("file_info")})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("sql_query")})
		,new CommandBinding({"control":this.getElement("excel_file"),"fieldId":"excel_file"})
		,new CommandBinding({"control":this.getElement("cell_matching"),"fieldId":"cell_matching"})
	]);
			
}
extend(ExcelTemplateDialog_View,ViewObjectAjx);

ExcelTemplateDialog_View.prototype.deleteExcelFile = function(fileId){
	var id = this.getElement("id").getValue();
	if(!id){
		throw new Error("Не записан.");
	}
	var pm =this.getController().getPublicMethod("delete_excel_file");
	pm.setFieldValue("excel_template_id",id);
	pm.run({
		"ok":function(){
			DOMHelper.delNode(document.getElementById(fileId));
			window.showTempNote("Данные удалены.",null,5000);
		}
	});
}
ExcelTemplateDialog_View.prototype.excelFileAdded = function(fileId){
	
	DOMHelper.previewImage(this.getElement("excel_file").getElement("file").getNode(),document.getElementById(fileId+"_pic"));
}

ExcelTemplateDialog_View.prototype.downloadFile = function(fileId){
	var pm = this.getController().getPublicMethod("download_excel_file");
	pm.setFieldValue("excel_template_id",this.getElement("id").getValue());
	pm.download();

}

