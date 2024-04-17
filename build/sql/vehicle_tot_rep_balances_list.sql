-- VIEW: vehicle_tot_rep_balances_list

--DROP VIEW vehicle_tot_rep_balances_list;

CREATE OR REPLACE VIEW vehicle_tot_rep_balances_list AS
	SELECT
		t.id,
		t.vehicle_owner_id,
		vehicle_owners_ref(wo) AS vehicle_owners_ref,
		t.period,
		t.value
	FROM vehicle_tot_rep_balances AS t
	LEFT JOIN vehicle_owners AS wo ON wo.id = t.vehicle_owner_id
	ORDER BY
		t.vehicle_owner_id,
		t.period
	;
	
ALTER VIEW vehicle_tot_rep_balances_list OWNER TO ;

