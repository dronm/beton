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

function Enum_ship_weighing_causes(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"self_ship",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"self_ship"],
checked:(options.defaultValue&&options.defaultValue=="self_ship")}
,{"value":"redirection",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"redirection"],
checked:(options.defaultValue&&options.defaultValue=="redirection")}
];
	
	Enum_ship_weighing_causes.superclass.constructor.call(this,id,options);
	
}
extend(Enum_ship_weighing_causes,EditSelect);

Enum_ship_weighing_causes.prototype.multyLangValues = {"ru_self_ship":"Самовывоз"
,"ru_redirection":"Переадресация"
};


