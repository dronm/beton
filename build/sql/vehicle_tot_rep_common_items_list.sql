-- VIEW: vehicle_tot_rep_common_items_list
--DROP VIEW vehicle_tot_rep_common_items_list;

CREATE OR REPLACE VIEW vehicle_tot_rep_common_items_list AS
	SELECT
		t.id 
		,t.code
		,t.name
		,t.is_income
	FROM vehicle_tot_rep_common_items AS t
	ORDER BY t.is_income, t.code
	;
	
ALTER VIEW vehicle_tot_rep_common_items_list OWNER TO ;
