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

function Enum_entity_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [
		{"value":"users",
		"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"users"],
		checked:(options.defaultValue&&options.defaultValue=="users")}
		
		,{"value":"clients",
		"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"clients"],
		checked:(options.defaultValue&&options.defaultValue=="clients")}
		
		,{"value":"suppliers",
		"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"suppliers"],
		checked:(options.defaultValue&&options.defaultValue=="suppliers")}

		,{"value":"pump_vehicles",
		"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"pump_vehicles"],
		checked:(options.defaultValue&&options.defaultValue=="pump_vehicles")}
		
	];
	
	Enum_entity_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_entity_types,EditSelect);

Enum_entity_types.prototype.multyLangValues = {"ru_users":"Пользователи" ,"ru_clients":"Клиенты","ru_suppliers":"Поставщики"
	,"ru_pump_vehicles":"Насосы"};


