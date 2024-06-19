/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2019
 
 * @class
 * @classdesc Period Edit cotrol
 
 * @extends EditPeriodDate
 
 * @requires core/extend.js
 * @requires controls/EditPeriodDate.js
 
 * @param string id 
 * @param {namespace} options
 */
function EditPeriodDateShift(id,options){
	options = options || {};	

	var constants = {"first_shift_start_time":null,"shift_length_time":null};
	window.getApp().getConstantManager().get(constants);

	//options.valueFrom = options.valueFrom || DateHelper.strtotime("2019-03-19T00:00:00+05:00")//DateHelper.getStartOfShift();
	//options.valueTo = options.valueTo || DateHelper.strtotime("2019-03-20T00:00:00+05:00")//DateHelper.getEndOfShift(options.valueFrom);
	
	options.downTitle = "Предыдущая смена";
	options.upTitle = "Следующая смена";

	options.periodSelectClass = PeriodSelectBeton;
	options.periodSelectOptions = options.periodSelectOptions || {"periodShift":true}; //value:shift || period:shift ????

	this.DEF_FROM_TIME = constants.first_shift_start_time.getValue();
	
	var sh_end = DateHelper.getEndOfShift();
	var h = sh_end.getHours();
	var m = sh_end.getMinutes();
	var s = sh_end.getSeconds();
	this.DEF_TO_TIME = ((h<10)? "0":"")+h.toString()+":"+((m<10)? "0":"")+m.toString()+":"+((s<10)? "0":"")+s.toString();

	EditPeriodDateShift.superclass.constructor.call(this,id,options);
}
extend(EditPeriodDateShift,EditPeriodDateTime);

EditPeriodDateShift.prototype.setPredefinedPeriod = function(per){
	if(per=="shift"){
		this.setCtrlDateTime(this.getControlFrom(),DateHelper.dateStart());
		this.setCtrlDateTime(this.getControlTo(),DateHelper.dateEnd())
		
	}else if(per=="prev_shift"){
		this.setCtrlDateTime(this.getControlFrom(),DateHelper.dateStart(new Date(DateHelper.time().getTime()-24*60*60*1000)));
		this.setCtrlDateTime(this.getControlTo(), new Date(DateHelper.dateStart().getTime()-24*60*60*1000));
		
	}else if (per=="prev_month"){
		var m_start = DateHelper.monthStart(new Date(DateHelper.monthStart() - 24*60*60*1000));
		this.setCtrlDateTime(this.getControlFrom(),m_start);
		this.setCtrlDateTime(this.getControlTo(),DateHelper.monthEnd(m_start));	
	}				
	
	EditPeriodDateShift.superclass.setPredefinedPeriod.call(this,per);
}

EditPeriodDateShift.prototype.goFast = function(sign){
	if (this.getControlPeriodSelect().getValue()=="shift"){
		this.addMonthsToControl(this.getControlFrom(),1*sign);
		this.addMonthsToControl(this.getControlTo(),1*sign);
	}	
	else{
		EditPeriodDateShift.superclass.goFast.call(this,sign);	
	}
}

EditPeriodDateShift.prototype.setCtrlDateTime = function(ctrl,dt){
	dt.setHours(0);
	dt.setMinutes(0);
	dt.setSeconds(0);
	//
	var tm = 0;
	if (ctrl.getAttr("name")=="to"){
		tm = 24*60*60*1000;
	}
	dt.setTime(dt.getTime() + DateHelper.timeToMS(ctrl.getTimeValueStr()) + tm);
	ctrl.setValue(dt);
}

EditPeriodDateShift.prototype.go = function(sign){
	if (this.getControlPeriodSelect().getValue()=="shift"){
		this.addDaysToControl(this.getControlFrom(),1*sign);
		this.addDaysToControl(this.getControlTo(),1*sign);	
	}	
	else if (this.getControlPeriodSelect().getValue()=="prev_shift"){
		this.addDaysToControl(this.getControlFrom(),2*sign);
		this.addDaysToControl(this.getControlTo(),2*sign);	
	}	
	else if (this.getControlPeriodSelect().getValue()=="prev_month"){
		this.addYearsToControl(this.getControlFrom(),2*sign);
		this.getControlTo().setValue(DateHelper.monthEnd(this.getControlFrom().getValue()));
	}	
	
	else{
		EditPeriodDateShift.superclass.go.call(this,sign);	
	}
}
