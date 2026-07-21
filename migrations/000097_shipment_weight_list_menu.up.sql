BEGIN;
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'30047',
	'ShipmentWeight_Controller',
	'get_list',
	'ShipmentWeightList',
	'Формы',
	'Взвешивание отгрузок',
	FALSE
	);
	

COMMIT;
