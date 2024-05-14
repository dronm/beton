/* Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderMakeForLabDialog_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Заявка";
	options.cmdSave = true;
	options.controller = new Order_Controller();
	options.readPublicMethod = options.controller.getPublicMethod("get_object_for_lab");
	options.model = (options.models&&options.models.OrderMakeForLabDialog_Model)? options.models.OrderMakeForLabDialog_Model : new OrderMakeForLabDialog_Model();

	options.addElement = function(){
		// var obj_bs_cl = ("control-label "+window.getBsCol(2));

		this.addElement(new EditString(id+":comment_text", {
			// "labelClassName":obj_bs_cl,			
			"labelCaption":"Комментарий:",
			"title":"Комментарий к заявке",
			"focus":true
		}));

		this.addElement(new ConcreteTypeEdit(id+":concrete_type",{			
			// "labelClassName":obj_bs_cl,
			"editContClassName":("input-group "+window.getBsCol(2)),
			"required":true,
			"asyncRefresh":false
		}));	
	}

	OrderMakeForLabDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("comment_text")})
		,new DataBinding({"control":this.getElement("concrete_type"),"field":this.m_model.getField("concrete_types_ref")})
	];
	this.setDataBindings(r_bd);
	
	//write
	var wr_b = [
		new CommandBinding({"control":this.getElement("comment_text")})
		,new CommandBinding({"control":this.getElement("concrete_type"),"fieldId":"concrete_type_id"})
	];
	this.setWriteBindings(wr_b);	
}
extend(OrderMakeForLabDialog_View, ViewObjectAjx);

