/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditDate
 * @requires core/extend.js
 * @requires controls/EditDate.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function EditDateInlineValidation(id,options){
	options = options || {};	
	
	options.required = (options.required==undefined)? options.required : true;
	options.labelCaption = (options.labelCaption!=undefined)? options.labelCaption : "Дата:";
	options.placeholder = options.placeholder || "ДД.ММ.ГГГГ";
	options.title = options.title || "Дата в формате ДД.ММ.ГГГГ";
	
	options.formatterOptions = {
		date: true,
		delimiter: this.DATE_PART_SEP,
		datePattern: ['d', 'm', 'Y']											
	};
	
	options.cmdSelect = (options.cmdSelect!=undefined)? options.cmdSelect : true;
	if(options.cmdSelect){
		options.buttonSelect = options.buttonSelect ||
			new ButtonCalendar(id+':btn_calend',{
				"dateFormat": options.dateFormat || window.getApp().getDateFormat(),
				"editControl": this,
				"timeValueStr": options.timeValueStr,
				"enabled":options.enabled
			});
	}	
	options.events = options.events || {};
	options.events.focus = function(){
		this.setValid();
	};
	options.events.blur = function(){
		var v = this.getNode().value;
		if(v && v.length){
			v = this.getValue();
			if(isNaN(v)){
				this.setNotValid(this.INVALID_DATE_MSG);
			}else{
				this.setValid();
			}
			
		}else{
			this.setValid();
		}
	};
	
	EditDateInlineValidation.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(EditDateInlineValidation, EditString);

/* Constants */
EditDateInlineValidation.prototype.DATE_PART_SEP = "."
EditDateInlineValidation.prototype.INVALID_DATE_MSG = "Неверный формат"

/* private members */

/* protected*/


/* public methods */
EditDateInlineValidation.prototype.getValue = function(){
	var v = EditDateInlineValidation.superclass.getValue.call(this);
	if(v){
		var d_parts = v.split(this.DATE_PART_SEP);
		if(d_parts.length!=3){
			return null;
		}
		return DateHelper.strtotime(d_parts[2]+"-"+d_parts[1]+"-"+d_parts[0]);	
	}
	return null;
}

EditDateInlineValidation.prototype.setInitValue = function(v){
	this.setValue(v);
	this.setAttr(this.VAL_INIT_ATTR, this.getValue());
}

EditDateInlineValidation.prototype.setValue = function(v){
	if(typeof v == "object" && !isNaN(v)){		
		v = DateHelper.format(v, "d/m/Y");
	}
	EditDateInlineValidation.superclass.setValue.call(this, v);
}

