/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_js20.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * @class
 * @classdesc controller
 
 * @extends ControllerObjServer
  
 * @requires core/extend.js
 * @requires core/ControllerObjServer.js
  
 * @param {Object} options
 * @param {Model} options.listModelClass
 * @param {Model} options.objModelClass
 */ 

function QualityPassport_Controller(options){
	options = options || {};
	options.listModelClass = QualityPassportList_Model;
	options.objModelClass = QualityPassport_Model;
	QualityPassport_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_get_object_or_last();
	this.add_complete_vid_smesi_gost();
	this.add_complete_uklad();
	this.add_complete_sohran_udobouklad();
	this.add_complete_kf_prochnosti();
	this.add_complete_prochnost();
	this.add_complete_naim_dobavki();
	this.add_complete_aeff();
	this.add_complete_krupnost();
	this.add_complete_reg_nomer_dekl();
		
}
extend(QualityPassport_Controller,ControllerObjServer);

			QualityPassport_Controller.prototype.addInsert = function(){
	QualityPassport_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "F";
	var field = new FieldInt("f_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "W";
	var field = new FieldInt("w_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Гост вида смеси";
	var field = new FieldText("vid_smesi_gost",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место укладки";
	var field = new FieldText("uklad",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("sohran_udobouklad",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("kf_prochnosti",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("prochnost",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("naim_dobavki",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("aeff",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("krupnost",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("vidan",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("shipment_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("smes_num",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("order_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("reg_nomer_dekl",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			QualityPassport_Controller.prototype.addUpdate = function(){
	QualityPassport_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "F";
	var field = new FieldInt("f_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "W";
	var field = new FieldInt("w_val",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Гост вида смеси";
	var field = new FieldText("vid_smesi_gost",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место укладки";
	var field = new FieldText("uklad",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("sohran_udobouklad",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("kf_prochnosti",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("prochnost",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("naim_dobavki",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("aeff",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("krupnost",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("vidan",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("shipment_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("smes_num",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("order_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("reg_nomer_dekl",options);
	
	pm.addField(field);
	
	
}

			QualityPassport_Controller.prototype.addDelete = function(){
	QualityPassport_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			QualityPassport_Controller.prototype.addGetList = function(){
	QualityPassport_Controller.superclass.addGetList.call(this);
	
	
	
	var pm = this.getGetList();
	
	pm.addField(new FieldInt(this.PARAM_COUNT));
	pm.addField(new FieldInt(this.PARAM_FROM));
	pm.addField(new FieldString(this.PARAM_COND_FIELDS));
	pm.addField(new FieldString(this.PARAM_COND_SGNS));
	pm.addField(new FieldString(this.PARAM_COND_VALS));
	pm.addField(new FieldString(this.PARAM_COND_ICASE));
	pm.addField(new FieldString(this.PARAM_ORD_FIELDS));
	pm.addField(new FieldString(this.PARAM_ORD_DIRECTS));
	pm.addField(new FieldString(this.PARAM_FIELD_SEP));
	pm.addField(new FieldString(this.PARAM_FIELD_LSN));

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	f_opts.alias = "F";
	pm.addField(new FieldInt("f_val",f_opts));
	var f_opts = {};
	f_opts.alias = "W";
	pm.addField(new FieldInt("w_val",f_opts));
	var f_opts = {};
	f_opts.alias = "Гост вида смеси";
	pm.addField(new FieldText("vid_smesi_gost",f_opts));
	var f_opts = {};
	f_opts.alias = "Место укладки";
	pm.addField(new FieldText("uklad",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("sohran_udobouklad",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("kf_prochnosti",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("prochnost",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("naim_dobavki",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("aeff",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("krupnost",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDate("vidan",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("smes_num",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("orders_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("concrete_types_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("shipments_list",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("vidan");
	
}

			QualityPassport_Controller.prototype.addGetObject = function(){
	QualityPassport_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			QualityPassport_Controller.prototype.add_get_object_or_last = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_object_or_last',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("shipment_id",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_vid_smesi_gost = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_vid_smesi_gost',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("vid_smesi_gost",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_uklad = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_uklad',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("uklad",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_sohran_udobouklad = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_sohran_udobouklad',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("sohran_udobouklad",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_kf_prochnosti = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_kf_prochnosti',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("kf_prochnosti",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_prochnost = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_prochnost',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("prochnost",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_naim_dobavki = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_naim_dobavki',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("naim_dobavki",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_aeff = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_aeff',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldText("aeff",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_krupnost = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_krupnost',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("krupnost",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

			QualityPassport_Controller.prototype.add_complete_reg_nomer_dekl = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('complete_reg_nomer_dekl',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("reg_nomer_dekl",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("mid",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
			
	this.addPublicMethod(pm);
}

		