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

function Enum_production_plant_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"elkon",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"elkon"],
checked:(options.defaultValue&&options.defaultValue=="elkon")}
,{"value":"ammann",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"ammann"],
checked:(options.defaultValue&&options.defaultValue=="ammann")}
];
	
	Enum_production_plant_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_production_plant_types,EditSelect);

Enum_production_plant_types.prototype.multyLangValues = {"ru_elkon":"Elkon"
,"ru_ammann":"Ammann"
};


