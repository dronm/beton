BEGIN;
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'20033',
	'ShipmentWeightSelfShip_Controller',
	'get_list',
	'ShipmentWeightSelfShipList',
	'Документы',
	'Бетон самовывоз',
	FALSE
	);
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'20034',
	'ShipmentWeightRedirection_Controller',
	'get_list',
	'ShipmentWeightRedirectionList',
	'Документы',
	'Переадресация',
	FALSE
	);
	
COMMIT;
