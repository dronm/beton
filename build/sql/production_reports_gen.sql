-- Function: production_reports_gen(date_from timestampTZ, date_to timestampTZ)

--DROP FUNCTION production_reports_gen(date_from timestampTZ, date_to timestampTZ);

CREATE OR REPLACE FUNCTION production_reports_gen(
    date_from timestamptz,
    date_to   timestamptz
)
RETURNS void
LANGUAGE sql
VOLATILE
COST 100
AS $$
	INSERT INTO production_reports (shift_from, shift_to)
	SELECT
		shift_start,
		shift_start + interval '23 hours 59 minutes 59 seconds' AS shift_end
	FROM generate_series(
			date_from,
			date_to,
			interval '1 day'
		 ) AS shift_start
	WHERE
		-- 1) production data exists for the shift
		EXISTS (
			SELECT 1
			FROM productions p
			WHERE p.production_dt_end
				  BETWEEN shift_start
					  AND shift_start + interval '23 hours 59 minutes 59 seconds'
		)
		-- 2) avoid duplicates
		AND NOT EXISTS (
			SELECT 1
			FROM production_reports pr
			WHERE pr.shift_from = shift_start
			  AND pr.shift_to   = shift_start + interval '23 hours 59 minutes 59 seconds'
		);
$$;
