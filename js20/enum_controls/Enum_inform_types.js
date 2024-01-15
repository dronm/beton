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

function Enum_inform_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"email",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"email"],
checked:(options.defaultValue&&options.defaultValue=="email")}
,{"value":"telegram",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"telegram"],
checked:(options.defaultValue&&options.defaultValue=="telegram")}
,{"value":"whatsup",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"whatsup"],
checked:(options.defaultValue&&options.defaultValue=="whatsup")}
,{"value":"sms",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"sms"],
checked:(options.defaultValue&&options.defaultValue=="sms")}
];
	
	Enum_inform_types.superclass.constructor.call(this,id,options);
	
}
extend(Enum_inform_types,EditSelect);

Enum_inform_types.prototype.multyLangValues = {"ru_email":"Электронная почта"
,"ru_telegram":"Telegram"
,"ru_whatsup":"What's up"
,"ru_sms":"СМС"
};


