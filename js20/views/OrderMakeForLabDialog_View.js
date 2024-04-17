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

	var self = this;
	options.addElement = function(){
		this.addElement(new EditString(id+":comment_text", {
			"labelCaption":"Комментарий:",
			"title":"Комментарий к заявке",
			"focus":true
		}));
	}
	OrderMakeForLabDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("comment_text")})
	];
	this.setDataBindings(r_bd);
	
	//write
	var wr_b = [
		new CommandBinding({"control":this.getElement("comment_text")})
	];
	this.setWriteBindings(wr_b);	
}
extend(OrderMakeForLabDialog_View, ViewObjectAjx);

