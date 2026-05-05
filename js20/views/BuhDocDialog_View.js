/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026
 
 * @extends ViewObjectAjx.js
 * @requires core/extend.js  
 * @requires controls/ViewObjectAjx.js 
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {object} options
 * @param {object} options.models All data models
 * @param {object} options.variantStorage {name,model}
 */	
/*
import {ViewObjectAjx} from '../controls/ViewObjectAjx.js';

import {ClientNameEdit} from '../custom_controls/ClientNameEdit.js';
import {ClientNameFullEdit} from '../custom_controls/ClientNameFullEdit.js';
import {Client_Controller} from '../controllers/Client_Controller.js';
*/
function BuhDocDialog_View(id,options){	

	options = options || {};
	
	options.controller = new BuhDoc_Controller();
	options.model = options.models.BuhDocDialog_Model;
	
	var self = this;
	options.addElement = function(){
		this.addElement(new Control(id+":ref_1c"));	
		this.addElement(new Control(id+":faktura_ref_1c"));	

		this.addElement(new Client1cEdit(id+":client_1c",{
			"required":true,
			"focus":true
		}));	
		this.addElement(new ClientContract1cEdit(id+":contract_1c",{
			"required":true
		}));	
		this.addElement(new BuhDocItemGrid(id+":items",{
			"required":true
	}

	BuhDocDialog_View.superclass.constructor.call(this,id,options);

	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("ref_1c")})
		,new DataBinding({"control":this.getElement("faktura_ref_1c")})
		,new DataBinding({"control":this.getElement("client_1c")})
		,new DataBinding({"control":this.getElement("contract_1c")})
		,new DataBinding({"control":this.getElement("items")})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("client_1c")})
		new CommandBinding({"control":this.getElement("contract_1c")})
		new CommandBinding({"control":this.getElement("items")})
	]);

}
extend(BuhDocDialog_View, ViewObjectAjx);
