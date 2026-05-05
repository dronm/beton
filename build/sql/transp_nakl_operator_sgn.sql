-- Function: transp_nakl_operator_sgn(shipment_id int)

-- DROP FUNCTION transp_nakl_operator_sgn(shipment_id int);
CREATE OR REPLACE FUNCTION public.transp_nakl_operator_sgn(in_shipment_id int)
RETURNS int AS
$$
	SELECT
		att.id
	FROM shipments AS sh

	JOIN operators_for_transp_nakls_list AS op ON 
		(op.production_sites_ref->'keys'->>'id')::int = sh.production_site_id

	JOIN entity_contacts AS ect ON 
		ect.entity_type = 'users'
		AND ect.entity_id = (op.users_ref->'keys'->>'id')::int

	JOIN contacts AS ct ON ct.id = ect.contact_id

	JOIN attachments AS att ON 
		(att.ref->'keys'->>'id')::int = ct.id
		AND att.ref->>'dataType' = 'contacts'

	WHERE sh.id = in_shipment_id

	ORDER BY
		(op.users_ref->'keys'->>'id')::int ASC,
		ct.id ASC,
		att.id ASC

	LIMIT 1;
$$
LANGUAGE sql
STABLE
COST 100;
