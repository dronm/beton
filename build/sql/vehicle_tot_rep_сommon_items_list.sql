-- VIEW: vehicle_tot_rep_common_items_list
vehicle_tot_rep_сommon_items
vehicle_tot_rep_common_items
vehicle_tot_rep_common_items
--DROP VIEW vehicle_tot_rep_common_items_list;

CREATE OR REPLACE VIEW vehicle_tot_rep_common_items_list AS
	SELECT
		t.id 
		,t.code
		,t.name
		,t.is_income
	FROM vehicle_tot_rep_common_items AS t
	ORDER BY t.code
	;
	
ALTER VIEW vehicle_tot_rep_common_items_list OWNER TO ;
