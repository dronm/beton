/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2025

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 *	Gets all events TmOutMessage.sent,TmInMessage.insert
 
 * @param {object} mode - ClientModel object

 */
function ClientSetRef1c(clientId, onClientUpdated){
	// this.m_model = model;
	this.m_clientId = clientId;
	this.m_onClientUpdated = onClientUpdated;
}

ClientSetRef1c.prototype.open = function(){
	const self = this;
	this.m_form = new WindowFormModalBS("ClientSetRef1c",{
		"dialogWidth":"30%",
		"cmdOk":true,		
		"cmdCancel":true,
		"onClickCancel":function(){
			this.close();
		},
		"onClickOk":function(){
			const ref1c = this.getContent().getElement("ref_1c").getValue();
			self.onOk(ref1c);
		},
		"cmdClose":true,
		"content":new View("ClientSetRef1c:view", {
			addElement: function(){

				this.addElement(new Client1cEdit(id+":ref_1c",{
					//"onSelect":function(f){
					//	self.m_ref1c = f.ref.getValue();
					//}
				}));		
			}
		})
	});
	this.m_form.open();
}

//clientId int, ref1c string guid
ClientSetRef1c.prototype.updateClient = function(clientId, ref1c, callback){
	const pm = (new Client_Controller()).getPublicMethod("update");
	pm.setFieldValue("old_id", clientId);
	pm.setFieldValue("ref_1c", ref1c);
	const self = this;
	pm.run({
		ok: function(resp) {
			if(self.m_onClientUpdated){
				self.m_onClientUpdated();
			}
			if(callback){
				callback();
			}
		}
	});
}

ClientSetRef1c.prototype.onOk = function(ref1c){
	if(this.m_form){
		const clientId = this.m_clientId;
		// const clientId = this.m_model.id.getValue();
		console.log("client:",clientId);
		console.log("ref1c:",ref1c)

		const self = this;
		this.updateClient(clientId, ref1c, function(){
			self.close();
		})
	}
}

ClientSetRef1c.prototype.close = function(){
	if(this.m_form){
		this.m_form.close();
	}
}
