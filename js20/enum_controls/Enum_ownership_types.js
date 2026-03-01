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

function Enum_ownership_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"preperty",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"preperty"],
checked:(options.defaultValue&&options.defaultValue=="preperty")}
,{"value":"leasing",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"leasing"],
checked:(options.defaultValue&&options.defaultValue=="leasing")}
,{"value":"rent",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"rent"],
checked:(options.defaultValue&&options.defaultValue=="rent")}
];
	
	Enum_ownership_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_ownership_types,EditSelect);

Enum_ownership_types.prototype.multyLangValues = {"ru_preperty":"Собственность"
,"ru_leasing":"Лизинг"
,"ru_rent":"Аренда"
};


