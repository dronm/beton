/** Copyright (c) 2025
 *	Andrey Mikhalevich, Katren ltd.
 */
function ShipmentForTranspNaklList_View(id,options){	

	options.templateOptions = options.templateOptions || {};

	ShipmentForTranspNaklList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.ShipmentForTranspNaklList_Model)? 
		options.models.ShipmentForTranspNaklList_Model: new ShipmentForTranspNaklList_Model();
	var contr = new Order_Controller();

	this.addElement(new GridAjx(id+":grid",{
		//"className":"table-bordered table-responsive",//table-make_order order_make_grid
		"model":model,
		"controller":contr,
		"keyIds":["id"],
		"readPublicMethod":contr.getPublicMethod("get_transp_nakl_shipment_list"),
		"editInline":false,
		"editWinClass":null,
		"commands": null,
		"popUpMenu":null,
		"filters":(options.detailFilters&&options.detailFilters.ShipmentForTranspNaklList_Model)? 
			options.detailFilters.ShipmentForTranspNaklList_Model : null,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHeadMark(id+":grid:head:mark")
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnDate({
									"field":model.getField("date_time"),
									"dateFormat":"d/m/y H:i",
									"ctrlClass":EditDateTime
								})
							],
							"sortable":true,
							"sort": "asc"
						})
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Количество",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("quant")
								})
							]
						})						
						,new GridCellHead(id+":grid:head:id",{
							"value":"Отгрузка",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumn({
									"field":model.getField("id")
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicles_ref",{
							"value":"ТС",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnRef({
									"field":model.getField("vehicles_ref"),
									"ctrlClass":VehicleEdit,
									"form":VehicleDialog_Form
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:drivers_ref",{
							"value":"Водитель",
							"columns":[
								new GridColumnRef({
									"field":model.getField("drivers_ref"),
									"ctrlClass":DriverEditRef,
									"form": DriverDialog_Form
								})
							]
						})
						,new GridCellHead(id+":grid:head:driver_sig_exists",{
							"value":"Подпись",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("driver_sig_exists")
								})
							]
						})
						,new GridCellHead(id+":grid:head:production_sites_ref",{
							"value":"Завод",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_sites_ref"),
									"ctrlClass":ProductionSiteEdit
								})
							]
						})
						,new GridCellHead(id+":grid:head:operators_ref",{
							"value":"Оператор",
							"columns":[
								new GridColumnRef({
									"field":model.getField("operators_ref"),
									"ctrlClass":UserEditRef,
									"form": User_Form
								})
							]
						})
						,new GridCellHead(id+":grid:head:operator_sig_exists",{
							"value":"Подпись",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("operator_sig_exists")
								})
							]
						})
						,new GridCellHead(id+":grid:head:carriers_ref",{
							"value":"Перевозчик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("carriers_ref"),
									"ctrlClass":ClientEdit,
									"form": ClientDialog_Form
								})
							]
						})
						,new GridCellHead(id+":grid:head:carrier_ref_1c_exists",{
							"value":"1c",
							"colAttrs":{"align":"center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("carrier_ref_1c_exists")
								})
							]
						})
					]
				})
			]
		}),
		"pagination": null,
		"autoRefresh":options.detailFilters? true:false,
		"selectedRowClass":"order_current_row",
		"refreshInterval": null,
		"rowSelect":false,
		"navigate": false,
		"navigateClick": false,
		"navigateMouse": false,
		"focus":true
	}));
}
extend(ShipmentForTranspNaklList_View, ViewAjxList);

