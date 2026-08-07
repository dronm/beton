
-- ************* virtual table ****************
-- VIEW: public.fuel_corrections_list
--DROP VIEW firms_1c_list;
CREATE OR REPLACE VIEW public.fuel_corrections_list AS
	SELECT
		t.id,
		t.date_time,
		t.vehicle_id,
		vehicles_ref(v) AS vehicles_ref,
		t.quant,
		t.quant_correction
	FROM public.fuel_corrections AS t
	LEFT JOIN vehicles AS v ON v.id = t.vehicle_id
	ORDER BY date_time DESC
	;