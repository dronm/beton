-- VIEW: quality_passports_list

DROP VIEW quality_passports_list;

CREATE OR REPLACE VIEW quality_passports_list AS
	SELECT
		t.id
		
		,(SELECT 
		CASE WHEN EXTRACT(DAY FROM o.date_time)<10 THEN
			'0' || EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
		ELSE
			EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
		END) AS num
		 
		,t.f_val
		,t.w_val
		,t.vid_smesi_gost
		,t.uklad
		,t.sohran_udobouklad
		,t.kf_prochnosti
		,t.prochnost
		,t.naim_dobavki
		,t.aeff
		,t.krupnost
		,t.vidan
		,t.smes_num
		,orders_ref(o) AS orders_ref
		,concrete_types_ref(ctp) AS concrete_types_ref
		,clients_ref(cl) AS clients_ref
		,(
			SELECT
				json_agg(shipments_ref(sh))
			FROM shipments AS sh
			WHERE sh.order_id = t.order_id
		) AS shipments_list
		
	FROM quality_passports AS t
	LEFT JOIN orders AS o ON o.id = t.order_id
	LEFT JOIN concrete_types AS ctp ON ctp.id = o.concrete_type_id
	LEFT JOIN clients AS cl ON cl.id = o.client_id
	ORDER BY t.vidan DESC
	;
	
ALTER VIEW quality_passports_list OWNER TO ;
