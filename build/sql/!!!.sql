select water_ship_cost_on_date(now()::date);


--update telerance violation
UPDATE productions
set material_tolerance_violated  = productions_get_mat_tolerance_violated(productions.production_site_id,productions.production_id)
WHERE 
	productions.production_id = 147507 and productions.production_site_id = 1;

