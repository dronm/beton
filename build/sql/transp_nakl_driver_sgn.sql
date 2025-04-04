-- Function: transp_nakl_driver_sgn(shipment_id int)

-- DROP FUNCTION transp_nakl_driver_sgn(shipment_id int);

CREATE OR REPLACE FUNCTION transp_nakl_driver_sgn(int)
  RETURNS int AS
$$
	SELECT
		att.id
	FROM shipments AS sh
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers dr ON dr.id = vh.driver_id
	LEFT JOIN entity_contacts ect ON ect.entity_type = 'drivers' AND ect.entity_id = dr.id
	LEFT JOIN contacts ct ON ct.id = ect.contact_id
	LEFT JOIN attachments att ON (att.ref->'keys'->>'id')::int = ct.id AND att.ref->>'dataType' = 'contacts'
	WHERE sh.id = $1;
$$
  LANGUAGE sql COST 100;

