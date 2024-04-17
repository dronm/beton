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

function Enum_reg_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"material",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"material"],
checked:(options.defaultValue&&options.defaultValue=="material")}
,{"value":"material_fact",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"material_fact"],
checked:(options.defaultValue&&options.defaultValue=="material_fact")}
,{"value":"cement",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"cement"],
checked:(options.defaultValue&&options.defaultValue=="cement")}
,{"value":"material_consumption",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"material_consumption"],
checked:(options.defaultValue&&options.defaultValue=="material_consumption")}
];
	
	Enum_reg_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_reg_types,EditSelect);

Enum_reg_types.prototype.multyLangValues = {"ru_material":"Учет материалов"
,"ru_material_fact":"Учет материалов по факту"
,"ru_cement":"Учет цемента"
,"ru_material_consumption":"Расход материалов"
};


