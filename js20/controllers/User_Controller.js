/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017 - 2024
 
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

function User_Controller(options){
	options = options || {};
	options.listModelClass = UserList_Model;
	options.objModelClass = UserDialog_Model;
	User_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_set_new_pwd();
	this.add_reset_pwd();
	this.add_login();
	this.add_login_ext();
	this.add_login_refresh();
	this.add_login_k();
	this.add_login_ks();
	this.add_logout();
	this.add_login_tm();
	this.add_tm_check_tel();
	this.add_tm_send_code();
	this.add_tm_get_left_time();
	this.add_tm_check_code();
	this.add_logout_html();
	this.add_login_html();
	this.add_logged();
	this.addComplete();
	this.add_get_profile();
	this.add_password_recover();
	this.add_get_user_operator_list();
	this.add_update_production_site();
	this.add_set_param();
	this.add_get_param();
	this.add_select_login_role();
		
}
extend(User_Controller,ControllerObjServer);

			User_Controller.prototype.addInsert = function(){
	User_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;	
	options.enumValues = 'owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing';
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldPassword("pwd",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("tel_ext",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("phone_cel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата создания";
	var field = new FieldDateTimeTZ("create_dt",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("banned",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("time_zone_locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Не используется, используется справочник user_map_to_production";
	var field = new FieldString("elkon_user_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для облачной АТС";
	var field = new FieldString("domru_user_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("params",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			User_Controller.prototype.addUpdate = function(){
	User_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing';
	options.enumValues+= (options.enumValues=='')? '':',';
	options.enumValues+= 'null';
	
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldPassword("pwd",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("tel_ext",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("phone_cel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата создания";
	var field = new FieldDateTimeTZ("create_dt",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("banned",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("time_zone_locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("production_site_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Не используется, используется справочник user_map_to_production";
	var field = new FieldString("elkon_user_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для облачной АТС";
	var field = new FieldString("domru_user_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldJSONB("params",options);
	
	pm.addField(field);
	
	
}

			User_Controller.prototype.addDelete = function(){
	User_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			User_Controller.prototype.addGetList = function(){
	User_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldEnum("role_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("phone_cel",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tel_ext",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("email",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("banned",f_opts));
	var f_opts = {};
	f_opts.alias = "Контакты";
	pm.addField(new FieldJSON("contact_list",f_opts));
	var f_opts = {};
	f_opts.alias = "Id list for filter";
	pm.addField(new FieldText("contact_ids",f_opts));
}

			User_Controller.prototype.addGetObject = function(){
	User_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			User_Controller.prototype.add_set_new_pwd = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set_new_pwd',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldPassword("pwd",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_reset_pwd = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('reset_pwd',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login',opts);
	
				
	
	var options = {};
	
		options.alias = "Имя пользователя";
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.alias = "Пароль";
	
		options.maxlength = "20";
	
		pm.addField(new FieldPassword("pwd",options));
	
				
	
	var options = {};
	
		options.maxlength = "2";
	
		pm.addField(new FieldString("width_type",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_ext = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_ext',opts);
	
				
	
	var options = {};
	
		options.alias = "Имя пользователя";
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.alias = "Пароль";
	
		options.maxlength = "20";
	
		pm.addField(new FieldPassword("pwd",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_refresh = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_refresh',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("refresh_token",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_k = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_k',opts);
	
				
	
	var options = {};
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("k",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_ks = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_ks',opts);
	
				
	
	var options = {};
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("k",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_logout = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('logout',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_tm = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_tm',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "1000";
	
		pm.addField(new FieldText("auth_data",options));
	
				
	
	var options = {};
	
		options.maxlength = "2";
	
		pm.addField(new FieldString("width_type",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_tm_check_tel = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_check_tel',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("tel",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_tm_send_code = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_send_code',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("tel",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_tm_get_left_time = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_get_left_time',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("tel",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_tm_check_code = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('tm_check_code',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("tel",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "5";
	
		pm.addField(new FieldString("code",options));
	
				
	
	var options = {};
	
		options.maxlength = "2";
	
		pm.addField(new FieldString("width_type",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_logout_html = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('logout_html',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_html = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_html',opts);
	
				
	
	var options = {};
	
		options.alias = "Имя пользователя";
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.alias = "Пароль";
	
		options.maxlength = "20";
	
		pm.addField(new FieldPassword("pwd",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_logged = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('logged',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.addComplete = function(){
	User_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");	
}

			User_Controller.prototype.add_get_profile = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_profile',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_password_recover = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('password_recover',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "100";
	
		pm.addField(new FieldString("email",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("captcha_key",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_get_user_operator_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_user_operator_list',opts);
	
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

	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_update_production_site = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('update_production_site',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("old_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("production_site_id",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_set_param = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set_param',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "200";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("val",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_get_param = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_param',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "200";
	
		pm.addField(new FieldString("param_name",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_select_login_role = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('select_login_role',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "150";
	
		pm.addField(new FieldString("role_id",options));
	
			
	this.addPublicMethod(pm);
}

		