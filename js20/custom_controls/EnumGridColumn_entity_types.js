/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Grid column Enumerator class. Created from template build/templates/js/EnumGridColumn_js.xsl. !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_entity_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	
	options.multyLangValues["ru"] = {};

	options.multyLangValues["ru"]["users"] = "Пользователи";

	options.multyLangValues["ru"]["clients"] = "Клиенты";

	options.multyLangValues["ru"]["suppliers"] = "Поставщики";
	options.multyLangValues["ru"]["pump_vehicles"] = "Насосы";

	
	options.ctrlClass = options.ctrlClass || Enum_entity_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_entity_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_entity_types,GridColumnEnum);

