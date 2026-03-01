/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function EditMonth(id,options){
	options = options || {};
	
	options.addNotSelected = false;
	options.elements = [
		new EditSelectOption(id+":m1",{
			value: "1", descr: "Январь", checked: true
		}),
		new EditSelectOption(id+":m2",{
			value: "2", descr: "Февраль", checked: false
		}),
		new EditSelectOption(id+":m3",{
			value: "3", descr: "Март", checked: false
		}),
		new EditSelectOption(id+":m4",{
			value: "4", descr: "Апрель", checked: false
		}),
		new EditSelectOption(id+":m5",{
			value: "5", descr: "Май", checked: false
		}),
		new EditSelectOption(id+":m6",{
			value: "6", descr: "Июнь", checked: false
		}),
		new EditSelectOption(id+":m7",{
			value: "7", descr: "Июль", checked: false
		}),
		new EditSelectOption(id+":m8",{
			value: "8", descr: "Август", checked: false
		}),
		new EditSelectOption(id+":m9",{
			value: "9", descr: "Сентябрь", checked: false
		}),
		new EditSelectOption(id+":m10",{
			value: "10", descr: "Октябрь", checked: false
		}),
		new EditSelectOption(id+":m11",{
			value: "11", descr: "Ноябрь", checked: false
		}),
		new EditSelectOption(id+":m12",{
			value: "12", descr: "Декабрь", checked: false
		}),
	];
	
	EditMonth.superclass.constructor.call(this,id,options);
	
}
extend(EditMoth,EditSelect);
