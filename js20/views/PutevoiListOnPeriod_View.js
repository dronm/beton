/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function PutevoiListOnPeriod_View(id,options){

	options = options || {};
	options.HEAD_TITLE = "Путевые листы за период";
	
	const self = this;

	options.addElement = function(){
		this.addElement(new VehicleEdit(id+":vehicle",{
		}));	

		const period_ctrl = new EditPeriodDate(id+":period",{
			"field":new FieldDate("period_date")
		});
		this.addElement(period_ctrl);

		this.addElement(new ButtonCmd(id+":cmdRun",{
			"caption": "Сформировать",
			"onClick": function(){
				self.onRun();
			}
		}));	
	};

	PutevoiListOnPeriod_View.superclass.constructor.call(this, id, options);
	
}
extend(PutevoiListOnPeriod_View, View);

PutevoiListOnPeriod_View.prototype.onRun = function(){
	const vehRef = this.getElement("vehicle").getValue();
	console.log("vehRef:",vehRef)

	if(!vehRef || !("m_keys" in vehRef) || !("id" in vehRef.m_keys)){
		this.getElement("vehicle").setNotValid("Не выбран");
		throw new Error("Не выбран автомобиль");
	}
	this.getElement("vehicle").setValid();
	
	const perCtrl = this.getElement("period");
	const from = perCtrl.getControlFrom().getValue();
	const to = perCtrl.getControlTo().getValue();
	console.log("from:",from)
	console.log("to:",to)

	const pm = (new Shipment_Controller()).getPublicMethod("shipment_putevoi_list_on_period");
	pm.setFieldValue("vehicle_id", vehRef.m_keys.id);
	pm.setFieldValue("period_from", from);
	pm.setFieldValue("period_to", to);
	pm.download();
}


