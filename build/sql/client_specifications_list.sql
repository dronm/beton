-- VIEW: client_specifications_list

--DROP VIEW client_specifications_list;

CREATE OR REPLACE VIEW client_specifications_list AS
	SELECT
		t.id
		,t.client_id
		,t.specification_date
		,t.contract
		,t.specification
		,t.concrete_type_id
		,t.destination_id
		,clients_ref(cl) AS clients_ref
		,concrete_types_ref(ct) AS concrete_types_ref
		,destinations_ref(dest) AS destinations_ref
		,coalesce(t.quant,0) AS quant
		,coalesce(t.quant,0) - coalesce((SELECT
			sum(fl.quant)
		FROM client_specification_flows AS fl
		WHERE fl.client_specification_id = t.id
		),0) AS quant_balance
		,t.price
		,t.total
	FROM client_specifications AS t
	LEFT JOIN concrete_types AS ct ON ct.id = t.concrete_type_id
	LEFT JOIN destinations AS dest ON dest.id = t.destination_id
	LEFT JOIN clients AS cl ON cl.id = t.client_id
	;
	
ALTER VIEW client_specifications_list OWNER TO ;
