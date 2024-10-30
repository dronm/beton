-- View: public.insurance_issuers_list

-- DROP VIEW public.insurance_issuers_list;
 
CREATE OR REPLACE VIEW public.insurance_issuers_list AS 
	SELECT
		DISTINCT issuers.fields->>'issuer' AS issuer
	FROM (
		SELECT
			jsonb_array_elements(insurance_osago->'rows')->'fields' AS fields
		FROM vehicles
		WHERE insurance_osago IS NOT NULL
		
		UNION ALL
		
		SELECT
			jsonb_array_elements(insurance_kasko->'rows')->'fields' AS fields
		FROM vehicles
		WHERE insurance_osago IS NOT NULL
		
	) AS issuers
	ORDER BY issuers.fields->>'issuer'
	;

ALTER TABLE public.insurance_issuers_list
  OWNER TO ;

