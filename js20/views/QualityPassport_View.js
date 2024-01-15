/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023
 
 * @extends ViewObjectAjx.js
 * @requires core/extend.js  
 * @requires controls/ViewObjectAjx.js 
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {object} options
 * @param {bool} options.noPrintBtn
 */	
function QualityPassport_View(id,options){	

	options = options || {};
	
	options.template = window.getApp().getTemplate("QualityPassport");
	options.controller = new QualityPassport_Controller();
	options.model = (options.models&&options.models.QualityPassport_Model)? options.models.QualityPassport_Model : new QualityPassport_Model();

	var self = this;
	options.addElement = function(){
		if(options.noPrintBtn !== true){
			this.addElement(new PrintPassBtn(id+":printPass",{
				"dialogView":this
			}));	
		}
		this.addElement(new EditDate(id+":vidan",{
			"labelCaption": "Выдан:",
			"title":"Дата выдачи"
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
		
		var ac_model = new QualityPassport_Model();
		
		this.addElement(new EditString(id+":vid_smesi_gost",{
			"labelCaption": "Вид смеси, ГОСТ:",
			"title": "Вид смеси, ГОСТ, например, ГОСТ 7473-2010",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_vid_smesi_gost"),
			"acDescrFields":[ac_model.getField("vid_smesi_gost")],
			"acKeyFields":[ac_model.getField("vid_smesi_gost")],
			"acPatternFieldId":"vid_smesi_gost",
			"acModel": ac_model
		}));	
		this.addElement(new EditString(id+":uklad",{
			"labelCaption": "Место укладки:",
			"title": "Место укладки",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_uklad"),
			"acDescrFields":[ac_model.getField("uklad")],
			"acKeyFields":[ac_model.getField("uklad")],
			"acPatternFieldId":"uklad",
			"acModel": ac_model
		}));	
		this.addElement(new EditString(id+":sohran_udobouklad",{
			"labelCaption": "Сохран. удобоук-ти,ч-мин:",
			"title":"Сохраняемость удобоукладываемости и других нормируемых показателей, ч-мин",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_sohran_udobouklad"),
			"acDescrFields":[ac_model.getField("sohran_udobouklad")],
			"acKeyFields":[ac_model.getField("sohran_udobouklad")],
			"acPatternFieldId":"sohran_udobouklad",
			"acModel": ac_model
		}));	
		this.addElement(new EditString(id+":kf_prochnosti",{
			"labelCaption": "Коэффициент прочности:",
			"title":"Коэффициент вариации прочности бетона, %",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_kf_prochnosti"),
			"acDescrFields":[ac_model.getField("kf_prochnosti")],
			"acKeyFields":[ac_model.getField("kf_prochnosti")],
			"acPatternFieldId":"kf_prochnosti",
			"acModel": ac_model			
		}));	
		this.addElement(new EditNum(id+":prochnost",{
			"labelCaption": "Прочность, Мпа (кгс/см2):",
			"title":"Требуемая прочность бетона в проектном возрасте 28 сут., Мпа (кгс/см2) ",
			//Параметр берется из марки
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_prochnost"),
			"acDescrFields":[ac_model.getField("prochnost")],
			"acKeyFields":[ac_model.getField("prochnost")],
			"acPatternFieldId":"prochnost",
			"acModel": ac_model			
		}));	
		this.addElement(new EditString(id+":naim_dobavki",{
			"labelCaption": "Добавка:",
			"title":"Наименование, масса (объём) добавки, кг (л)",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_naim_dobavki"),
			"acDescrFields":[ac_model.getField("naim_dobavki")],
			"acKeyFields":[ac_model.getField("naim_dobavki")],
			"acPatternFieldId":"naim_dobavki",
			"acModel": ac_model			
		}));	
		this.addElement(new EditString(id+":aeff",{
			"labelCaption": "Аэфф:",
			"title":"Класс материалов по удельной эффективной активности естественных радионуклидов и цифровое значение Аэфф",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_aeff"),
			"acDescrFields":[ac_model.getField("aeff")],
			"acKeyFields":[ac_model.getField("aeff")],
			"acPatternFieldId":"aeff",
			"acModel": ac_model			
		}));	
		this.addElement(new EditString(id+":krupnost",{
			"labelCaption": "Крупность, мм:",
			"title":"Наибольшая крупность заполнителей, мм",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_krupnost"),
			"acDescrFields":[ac_model.getField("krupnost")],
			"acKeyFields":[ac_model.getField("krupnost")],
			"acPatternFieldId":"krupnost",
			"acModel": ac_model			
		}));
		this.addElement(new EditString(id+":reg_nomer_dekl",{
			"labelCaption": "Регистр. номер декларации:",
			"title":"Регистрационный номер декларации о соотвествии",
			"cmdAutoComplete":true,
			"acMinLengthForQuery":0,
			"acIc":true,
			"acPublicMethod":options.controller.getPublicMethod("complete_reg_nomer_dekl"),
			"acDescrFields":[ac_model.getField("reg_nomer_dekl")],
			"acKeyFields":[ac_model.getField("reg_nomer_dekl")],
			"acPatternFieldId":"reg_nomer_dekl",
			"acModel": ac_model			
		}));	
					
	}
	
	QualityPassport_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("f_val")})
		,new DataBinding({"control":this.getElement("w_val")})
		,new DataBinding({"control":this.getElement("vid_smesi_gost")})
		,new DataBinding({"control":this.getElement("uklad")})
		,new DataBinding({"control":this.getElement("sohran_udobouklad")})
		,new DataBinding({"control":this.getElement("kf_prochnosti")})
		,new DataBinding({"control":this.getElement("prochnost")})
		,new DataBinding({"control":this.getElement("naim_dobavki")})
		,new DataBinding({"control":this.getElement("aeff")})
		,new DataBinding({"control":this.getElement("krupnost")})
		,new DataBinding({"control":this.getElement("vidan")})
		,new DataBinding({"control":this.getElement("reg_nomer_dekl")})		
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("f_val")})
		,new CommandBinding({"control":this.getElement("w_val")})
		,new CommandBinding({"control":this.getElement("vid_smesi_gost")})
		,new CommandBinding({"control":this.getElement("uklad")})
		,new CommandBinding({"control":this.getElement("sohran_udobouklad")})
		,new CommandBinding({"control":this.getElement("kf_prochnosti")})
		,new CommandBinding({"control":this.getElement("prochnost")})
		,new CommandBinding({"control":this.getElement("naim_dobavki")})
		,new CommandBinding({"control":this.getElement("aeff")})
		,new CommandBinding({"control":this.getElement("krupnost")})
		,new CommandBinding({"control":this.getElement("vidan")})
		,new CommandBinding({"control":this.getElement("reg_nomer_dekl")})
		,new CommandBinding({"func": function(pm){
			pm.setFieldValue("shipment_id", self.m_model.getFieldValue("shipment_id"));
		}})
	]);
	
}
extend(QualityPassport_View, ViewObjectAjx); //
