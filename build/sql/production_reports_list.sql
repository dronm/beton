-- VIEW: public.production_reports_list;

--DROP VIEW public.production_reports_list;

CREATE OR REPLACE VIEW public.production_reports_list AS
	SELECT
		id,
		shift_from,
		shift_to,
		ref_1c
	FROM production_reports AS t
	ORDER BY shift_to DESC
	;
