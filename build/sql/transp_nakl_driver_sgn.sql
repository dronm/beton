-- Function: transp_nakl_driver_sgn(shipment_id int)

-- DROP FUNCTION transp_nakl_driver_sgn(shipment_id int);
CREATE OR REPLACE FUNCTION public.transp_nakl_driver_sgn(p_shipment_id int)
RETURNS int AS
$$
	SELECT
		att.id
	FROM shipments AS sh
	LEFT JOIN vehicle_schedules AS sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers AS dr ON dr.id = vh.driver_id

	JOIN entity_contacts AS ect ON 
		ect.entity_type = 'drivers'
		AND ect.entity_id = dr.id

	JOIN contacts AS ct ON ct.id = ect.contact_id

	JOIN attachments AS att ON 
		(att.ref->'keys'->>'id')::int = ct.id
		AND att.ref->>'dataType' = 'contacts'

	WHERE sh.id = p_shipment_id

	ORDER BY
		ct.id ASC,
		att.id ASC

	LIMIT 1;
$$
LANGUAGE sql
STABLE
COST 100;
