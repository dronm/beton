-- VIEW: cement_silos_for_order_list

--DROP VIEW cement_silos_for_order_list;

CREATE OR REPLACE VIEW cement_silos_for_order_list AS
	SELECT
		t.id,
		t.name,
		production_sites_ref(pst) AS production_sites_ref,
		t.load_capacity,
		bal.quant AS balance,
		jsonb_build_object(
			'vehicles_ref',cs_state.vehicles_ref,
			'vehicle_state',cs_state.vehicle_state
		) AS vehicle,
		pst.production_base_id,

		e_log.pong
		
	FROM cement_silos AS t	
	LEFT JOIN production_sites AS pst ON pst.id = t.production_site_id
	LEFT JOIN rg_cement_balance(NULL) AS bal ON bal.cement_silos_id = t.id
	LEFT JOIN
		(SELECT
			cs.cement_silo_id,
			cs.date_time,
			vehicles_ref(vh) AS vehicles_ref,
			cs.vehicle_state
		FROM
			(SELECT cement_silo_id,
				max(date_time) AS date_time
			FROM cement_silo_productions
			GROUP BY cement_silo_id
			) AS m_period
		LEFT JOIN cement_silo_productions AS cs ON cs.cement_silo_id=m_period.cement_silo_id AND cs.date_time=m_period.date_time	
		LEFT JOIN vehicles AS vh ON vh.id=cs.vehicle_id
	) AS cs_state ON cs_state.cement_silo_id = t.id
	

	LEFT JOIN (
		SELECT DISTINCT ON (lg.production_site_id) 
			lg.production_site_id,
			NOT (substring(lg.message from 1 for 28) = 'Ошибка соединения с сервером'
			AND EXTRACT(EPOCH FROM NOW() - lg.date_time) * 1000 < const_ping_elkon_interval_err_val()
			) AS pong
		FROM elkon_log AS lg
		ORDER BY lg.production_site_id, lg.date_time DESC
	) AS e_log ON e_log.production_site_id = t.production_site_id

	WHERE coalesce(t.visible, FALSE)
	ORDER BY
		pst.name,
		t.production_descr
	;
	
