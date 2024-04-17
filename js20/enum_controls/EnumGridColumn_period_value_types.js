/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Grid column Enumerator class. Created from template build/templates/js/EnumGridColumn_js.xsl. !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_period_value_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	
	options.multyLangValues["ru"] = {};

	options.multyLangValues["ru"]["destination_price"] = "Цена доставки";

	options.multyLangValues["ru"]["destination_price_for_driver"] = "Цена для водителей";

	options.multyLangValues["ru"]["demurrage_cost_per_hour"] = "Стоимость простоя";

	options.multyLangValues["ru"]["water_ship_cost"] = "Стоимость доставки воды";

	
	options.ctrlClass = options.ctrlClass || Enum_period_value_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_period_value_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_period_value_types,GridColumnEnum);

