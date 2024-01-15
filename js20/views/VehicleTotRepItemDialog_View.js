/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023
 
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
function VehicleTotRepItemDialog_View(id,options){	

	options = options || {};
	
	options.controller = new VehicleTotRepItem_Controller();

	options.model = options.models.VehicleTotRepItem_Model;
	
	options.addElement = function(){
		this.addElement(new EditNum(id+":code",{
			"required": true,
			"focus": true,
			"labelCaption": "Код:",
			"title":"Код статьи для сортировки"
		}));	
	
		this.addElement(new EditString(id+":name",{
			"required": true,
			"maxLength":1000,
			"labelCaption": "Наименование:",
			"placeholder":"Наименование должности",
			"title":"Наименование статьи"
		}));	

		this.addElement(new EditCheckBox(id+":is_income",{
			"labelCaption": "Это статья доходов:",
			"title":"Если установлено - это статья доходов, иначе - это статья расодов"
		}));	
		this.addElement(new EditCheckBox(id+":info",{
			"labelCaption": "Информационная статья:",
			"title":"Установлено для статей, которые не влияют на остаток, вводятся для оборотов"
		}));	
		
		this.addElement(new EditText(id+":query",{
			"rows":5,
			"labelCaption": "Запрос SQL:",
			"title":"Если поле заполнено, оно будет рассчитано автомаически, иначе заплняется вручную"
		}));	

	}
	
	VehicleTotRepItemDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("code")})
		,new DataBinding({"control":this.getElement("is_income")})
		,new DataBinding({"control":this.getElement("info")})
		,new DataBinding({"control":this.getElement("query")})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("code")})
		,new CommandBinding({"control":this.getElement("is_income")})
		,new CommandBinding({"control":this.getElement("info")})
		,new CommandBinding({"control":this.getElement("query")})
	]);
}
extend(VehicleTotRepItemDialog_View, ViewObjectAjx);
