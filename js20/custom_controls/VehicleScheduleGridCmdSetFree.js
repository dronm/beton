/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2019

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function VehicleScheduleGridCmdSetFree(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	options.glyph = "glyphicon-time";
	options.title="Перевести в состояние 'свободен'";
	options.caption = "Освободить ";
	
	VehicleScheduleGridCmdSetFree.superclass.constructor.call(this,id,options);
		
}
extend(VehicleScheduleGridCmdSetFree,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */

VehicleScheduleGridCmdSetFree.prototype.onCommandCont = function(vehSchedId, productionBaseId, vehDescr){
	var pm = this.m_grid.getReadPublicMethod().getController().getPublicMethod("set_free");
	pm.setFieldValue("id", vehSchedId);
	pm.setFieldValue("production_base_id", productionBaseId);
	var self = this;
	pm.run({
		"ok":function(resp){
			self.m_grid.onRefresh(function(){
				window.showTempNote(vehDescr+" переведен в статус 'свободен'",null,3000);
			});
		}
	});	
}

/**
 * с 10/08/23 добавлен выбор базы, куда освободить
 */
VehicleScheduleGridCmdSetFree.prototype.onCommand = function(){
	this.m_grid.setModelToCurrentRow();
	var model = this.m_grid.getModel();
	var vehDescr = model.getFieldValue("drivers_ref").getDescr() +", "+model.getFieldValue("vehicles_ref").getDescr();
	
	var self = this;
	(new WindowFormModalBS("VSSetFree",{
		"content":new EditJSON("VSSetFree:cont",{
			"elements":[
				new ProductionBaseEdit("VSSetFree:cont:production_bases_ref",{
					"required":true
				})
			]
		}),
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":vehDescr,
		"onClickCancel":function(){
			this.close();
		},
		"onClickOk":function(){
			var view = this.getContent();
			if(!view.validate()){
				return;
			}
			var res = view.getValueJSON();
			self.onCommandCont(
				model.getFieldValue("id"),
				res.production_bases_ref.getKey("id"),
				vehDescr
			);
			this.close();
		}
	})).open();
	
	//Это по старому
	/*	
	WindowQuestion.show({
		"no":false,
		"text":"Освободить "+vehDescr+"?",
		"callBack":function(res){
			if(res==WindowQuestion.RES_YES){
				self.onCommandCont(model.getFieldValue("id"),vehDescr);
			}
		}
	});
	*/
}
