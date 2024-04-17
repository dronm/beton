/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2021
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function RepShipProdQuantDif_View(id,options){

	options = options || {};
	
	var contr = new Production_Controller();	
	options.publicMethod = contr.getPublicMethod("get_ship_prod_quant_dif");
	options.reportViewId = "ViewHTMLXSLT";
	options.templateId = "RepShipProdQuantDif";
	
	options.cmdMake = true;
	options.cmdPrint = false;
	options.cmdFilter = true;
	options.cmdExcel = true;
	options.cmdPdf = false;
	
	this.m_periodCtrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"valueFrom":(options.templateParams)? options.templateParams.date_from:DateHelper.getStartOfShift(DateHelper.time()),
		"valueTo":(options.templateParams)? options.templateParams.date_to:DateHelper.getEndOfShift(DateHelper.time()),
		"field":new FieldDateTime("date_time")
	});
	
	options.addElement = function(){
		this.addElement(
			new Control(id+":period","SPAN")
		);
	};
	
	options.filters = {
		"period":{
			"binding":new CommandBinding({
				"control":this.m_periodCtrl,
				"field":this.m_periodCtrl.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":this.m_periodCtrl.getControlFrom(),
					"field":this.m_periodCtrl.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":this.m_periodCtrl.getControlTo(),
					"field":this.m_periodCtrl.getField()
					}),
				"sign":"le"
				}
			]
		}
	};

	RepShipProdQuantDif_View.superclass.constructor.call(this, id, options);
	
}
extend(RepShipProdQuantDif_View,ViewReport);

RepShipProdQuantDif_View.prototype.fillParams = function(){	
	RepShipProdQuantDif_View.superclass.fillParams.call(this);
	
	
	this.getElement("period").setText(DateHelper.format(this.m_periodCtrl.getControlFrom().getValue(),"d/m/y H:i")+" - "+DateHelper.format(this.m_periodCtrl.getControlTo().getValue(),"d/m/y H:i"));
	
}

