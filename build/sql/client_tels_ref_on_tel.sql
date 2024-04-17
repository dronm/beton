-- Function: client_tels_ref_on_tel(in_tel text)

-- DROP FUNCTION client_tels_ref_on_tel(in_tel text);

CREATE OR REPLACE FUNCTION client_tels_ref_on_tel(in_tel text)
  RETURNS json AS
$$
	SELECT
		s.ref
	FROM (
	SELECT
			client_tels_ref(tl) AS ref,
			1 AS w
		FROM client_tels AS tl
		WHERE tl.tel = format_cel_standart(in_tel)
	UNION ALL			
	SELECT
			client_tels_ref(tl) AS ref,
			0 AS w
		FROM client_tels AS tl
		WHERE tl.tel = in_tel
	) AS s
	ORDER BY s.w DESC
	LIMIT 1
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_tels_ref_on_tel(in_tel text) OWNER TO ;
