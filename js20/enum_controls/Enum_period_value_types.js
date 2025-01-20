/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Enumerator class. Created from template build/templates/js/Enum_js.xsl. !!!DO NOT MODIFY!!!
 
 * @extends EditSelect
 
 * @requires core/extend.js
 * @requires controls/EditSelect.js
 
 * @param string id 
 * @param {object} options
 */

function Enum_period_value_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"destination_price",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"destination_price"],
checked:(options.defaultValue&&options.defaultValue=="destination_price")}
,{"value":"destination_price_for_driver",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"destination_price_for_driver"],
checked:(options.defaultValue&&options.defaultValue=="destination_price_for_driver")}
,{"value":"demurrage_cost_per_hour",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"demurrage_cost_per_hour"],
checked:(options.defaultValue&&options.defaultValue=="demurrage_cost_per_hour")}
,{"value":"water_ship_cost",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"water_ship_cost"],
checked:(options.defaultValue&&options.defaultValue=="water_ship_cost")}
,{"value":"min_quant_for_ship_cost",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"min_quant_for_ship_cost"],
checked:(options.defaultValue&&options.defaultValue=="min_quant_for_ship_cost")}
];
	
	Enum_period_value_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_period_value_types,EditSelect);

Enum_period_value_types.prototype.multyLangValues = {"ru_destination_price":"Цена доставки"
,"ru_destination_price_for_driver":"Цена для водителей"
,"ru_demurrage_cost_per_hour":"Стоимость простоя"
,"ru_water_ship_cost":"Стоимость доставки воды"
,"ru_min_quant_for_ship_cost":"Минимальное количество куб для доставки"
};


