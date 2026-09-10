-- Function: public.special_vehicles_list(in_date timestamp);

--DROP FUNCTION IF EXISTS public.special_vehicles_list(timestamp);

CREATE OR REPLACE FUNCTION public.special_vehicles_list(in_date timestamp)
RETURNS TABLE(
	id int,
	vehicles_ref json,
	tracker_id text,
	make text,
	tracker_no_signal bool,
	no_tracker bool,
	mileage numeric,
	timing interval,
	fuel_flow_start int,
	fuel_flow_in int,
	fuel_flow_out int,
	fuel_flow_end int,
	map_picture text
)
AS $BODY$
WITH shift_bounds AS (
	SELECT
		get_shift_start(in_date) AS shift_from,
		get_shift_start(in_date) + interval '24 hours' AS shift_to
)
SELECT
	v.id,
	vehicles_ref(v) AS vehicles_ref,
	v.tracker_id,
	v.make,

	CASE
		WHEN coalesce(v.tracker_id, '') = '' THEN FALSE
		WHEN tr_last.period IS NULL THEN TRUE
		ELSE now() - (tr_last.period+('5 hours'::interval)) > interval '48 hours'
	END AS tracker_no_signal,

	coalesce(v.tracker_id, '') = '' AS no_tracker,

	CASE
		-- already calculated for requested date/shift
		WHEN mlg_for_date.id IS NOT NULL THEN
			mlg_for_date.mileage::numeric

		-- no tracker: cannot calculate delta
		WHEN coalesce(v.tracker_id, '') = '' THEN
			coalesce(mlg_last.mileage, 0)::numeric

		-- latest saved mileage + missing delta
		ELSE
			coalesce(mlg_last.mileage, 0)::numeric
			+
			round(
				coalesce(
					vehicle_mileage(
						v.tracker_id,
						coalesce(mlg_last.for_date, s.shift_from),
						s.shift_to
					),
					0
				)
			)::numeric
	END AS mileage,

	CASE
		-- already calculated for requested date/shift
		WHEN mlg_for_date.id IS NOT NULL THEN
			mlg_for_date.timing

		-- no tracker: cannot calculate delta
		WHEN coalesce(v.tracker_id, '') = '' THEN
			coalesce(mlg_last.timing, interval '0 seconds')

		-- latest saved timing + missing delta
		ELSE
			coalesce(mlg_last.timing, interval '0 seconds')
			+
			coalesce(
				vehicle_timing(
					v.id,
					coalesce(mlg_last.for_date, s.shift_from),
					s.shift_to
				),
				interval '0 seconds'
			)
	END AS timing,

	coalesce(bal_start.quant, 0)::int AS fuel_flow_start,
	coalesce(fflow.flow_in, 0)::int AS fuel_flow_in,
	coalesce(fflow.flow_out, 0)::int AS fuel_flow_out,
	(
		coalesce(bal_start.quant, 0)
		+ coalesce(fflow.flow_in, 0)
		- coalesce(fflow.flow_out, 0)
	)::int AS fuel_flow_end,

	v.map_picture

FROM vehicles AS v
CROSS JOIN shift_bounds AS s

LEFT JOIN LATERAL (
	SELECT
		sum(CASE WHEN fl.deb THEN fl.quant ELSE 0 END) AS flow_in,
		sum(CASE WHEN NOT fl.deb THEN fl.quant ELSE 0 END) AS flow_out
	FROM ra_fuel_flow AS fl
	WHERE
		fl.vehicle_id = v.id
		AND fl.date_time >= s.shift_from
		AND fl.date_time < s.shift_to
) AS fflow ON true

LEFT JOIN LATERAL (
	SELECT
		tr.period
	FROM car_tracking AS tr
	WHERE
		tr.car_id = v.tracker_id
		AND tr.gps_valid = 1
	ORDER BY tr.period DESC
	LIMIT 1
) AS tr_last ON true

-- exact mileage/timing row for requested date/shift
LEFT JOIN LATERAL (
	SELECT
		mlg.id,
		mlg.for_date,
		mlg.mileage,
		mlg.timing
	FROM vehicle_mileages AS mlg
	WHERE
		mlg.vehicle_id = v.id
		AND mlg.for_date >= s.shift_from
		AND mlg.for_date < s.shift_to
	ORDER BY
		mlg.for_date DESC,
		mlg.id DESC
	LIMIT 1
) AS mlg_for_date ON true

-- latest mileage/timing row before requested date/shift
LEFT JOIN LATERAL (
	SELECT
		mlg.id,
		mlg.for_date,
		mlg.mileage,
		mlg.timing
	FROM vehicle_mileages AS mlg
	WHERE
		mlg.vehicle_id = v.id
		AND mlg.for_date < s.shift_from
	ORDER BY
		mlg.for_date DESC,
		mlg.id DESC
	LIMIT 1
) AS mlg_last ON true

LEFT JOIN LATERAL (
	SELECT
		sum(quant) AS quant
	FROM rg_fuel_flow_balance(
		in_date,
		ARRAY[v.id]
	)
) AS bal_start ON true

WHERE
	v.feature = 'спецтехника';
$BODY$
LANGUAGE sql
VOLATILE
COST 100;
