-- Function: transp_nakl_operator_sgn(shipment_id int)

-- DROP FUNCTION transp_nakl_operator_sgn(shipment_id int);

CREATE OR REPLACE FUNCTION transp_nakl_operator_sgn(int)
  RETURNS int AS
$$
	SELECT
		att.id
	FROM shipments AS sh
	LEFT JOIN operators_for_transp_nakls_list op ON (op.production_sites_ref->'keys'->>'id')::int = sh.production_site_id
	LEFT JOIN entity_contacts ect ON ect.entity_type = 'users' AND ect.entity_id = (users_ref->'keys'->>'id')::int
	LEFT JOIN contacts ct ON ct.id = ect.contact_id
	LEFT JOIN attachments att ON (att.ref->'keys'->>'id')::int = ct.id AND att.ref->>'dataType' = 'contacts'
	WHERE sh.id = $1;
$$
  LANGUAGE sql COST 100;


