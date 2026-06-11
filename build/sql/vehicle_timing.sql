-- Function: public.vehicle_timing(in_vehicle_id int, in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.vehicle_timing(in_vehicle_id int, in_date_from timestampTZ, in_date_to timestampTZ);

CREATE OR REPLACE FUNCTION public.vehicle_timing(
	in_vehicle_id int,
	in_date_from timestamptz,
	in_date_to timestamptz
)
RETURNS time AS
$BODY$
	WITH params AS (
		SELECT
			in_date_from::timestamp AS date_from,
			in_date_to::timestamp AS date_to
	),
	tracker AS (
		SELECT
			v.tracker_id::varchar(15) AS tracker_id
		FROM public.vehicles AS v
		WHERE v.id = in_vehicle_id
	),
	before_window AS (
		SELECT
			ct.period,
			ct.engine_on
		FROM public.car_tracking AS ct
		INNER JOIN tracker AS t
			ON t.tracker_id = ct.car_id
		CROSS JOIN params AS p
		WHERE ct.period < p.date_from
		ORDER BY ct.period DESC
		LIMIT 1
	),
	in_window AS (
		SELECT
			ct.period,
			ct.engine_on
		FROM public.car_tracking AS ct
		INNER JOIN tracker AS t
			ON t.tracker_id = ct.car_id
		CROSS JOIN params AS p
		WHERE ct.period >= p.date_from
			AND ct.period < p.date_to
	),
	points AS (
		SELECT
			period,
			engine_on
		FROM before_window

		UNION ALL

		SELECT
			period,
			engine_on
		FROM in_window
	),
	segments AS (
		SELECT
			greatest(pt.period, p.date_from) AS segment_from,
			least(
				coalesce(
					lead(pt.period) OVER (ORDER BY pt.period),
					p.date_to
				),
				p.date_to
			) AS segment_to,
			pt.engine_on
		FROM points AS pt
		CROSS JOIN params AS p
	)
	SELECT
		(
			'00:00:00'::time
			+
			coalesce(
				sum(segment_to - segment_from) FILTER (
					WHERE engine_on = '1'
						AND segment_to > segment_from
				),
				interval '0'
			)
		)::time
	FROM segments;
$BODY$
LANGUAGE sql
STABLE
COST 100;
