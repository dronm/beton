
--DROP FUNCTION public.vehicle_gen_fuel_consumption();

CREATE OR REPLACE FUNCTION public.vehicle_gen_fuel_consumption()
RETURNS integer AS
$BODY$
DECLARE
	v_inserted_count integer;
BEGIN
	WITH raw_mileages AS (
		SELECT
			vm.id,
			vm.vehicle_id,
			vm.for_date,
			get_shift_start(vm.for_date::timestamp)::timestamp AS shift_start,
			vm.mileage,
			vm.timing
		FROM public.vehicle_mileages AS vm
		WHERE vm.for_date IS NOT NULL
	),

	-- One mileage snapshot per vehicle and shift.
	-- If there are several rows inside the same shift, take the latest one.
	shift_mileages AS (
		SELECT DISTINCT ON (
			rm.vehicle_id,
			rm.shift_start
		)
			rm.id,
			rm.vehicle_id,
			rm.for_date,
			rm.shift_start,
			rm.mileage,
			rm.timing
		FROM raw_mileages AS rm
		ORDER BY
			rm.vehicle_id,
			rm.shift_start,
			rm.for_date DESC,
			rm.id DESC
	),

	-- Add previous cumulative values.
	mileage_pairs AS (
		SELECT
			sm.id,
			sm.vehicle_id,
			sm.for_date,
			sm.shift_start,
			sm.mileage,
			sm.timing,

			lag(sm.mileage) OVER (
				PARTITION BY sm.vehicle_id
				ORDER BY sm.shift_start, sm.for_date, sm.id
			) AS prev_mileage,

			lag(sm.timing) OVER (
				PARTITION BY sm.vehicle_id
				ORDER BY sm.shift_start, sm.for_date, sm.id
			) AS prev_timing,

			lag(sm.shift_start) OVER (
				PARTITION BY sm.vehicle_id
				ORDER BY sm.shift_start, sm.for_date, sm.id
			) AS prev_shift_start
		FROM shift_mileages AS sm
	),

	-- Convert cumulative mileage/timing into shift deltas.
	consumption_base AS (
		SELECT
			mp.vehicle_id,
			mp.shift_start AS date_time,
			extract(month FROM mp.shift_start)::int AS month_no,

			greatest(
				coalesce(mp.mileage, 0) - coalesce(mp.prev_mileage, 0),
				0
			)::int AS mileage,

			CASE
				WHEN coalesce(mp.timing, interval '0 seconds')
					- coalesce(mp.prev_timing, interval '0 seconds') > interval '0 seconds'
				THEN
					coalesce(mp.timing, interval '0 seconds')
					- coalesce(mp.prev_timing, interval '0 seconds')
				ELSE
					interval '0 seconds'
			END AS timing
		FROM mileage_pairs AS mp
		WHERE mp.prev_shift_start IS NOT NULL
	),

	consumption_calc AS (
		SELECT
			cb.date_time,
			cb.vehicle_id,

			round(
				(
					cb.mileage::numeric
					* coalesce(rate.quant_distance, 0)::numeric
					/ 100
				)
				+
				(
					extract(epoch FROM cb.timing)::numeric
					/ 3600
					* coalesce(rate.quant_time, 0)::numeric
				)
			)::int AS quant,

			cb.mileage,
			cb.timing,
			rate.fuel_consumption_schema_id
		FROM consumption_base AS cb
		INNER JOIN public.vehicles AS v
			ON v.id = cb.vehicle_id

		LEFT JOIN LATERAL (
			SELECT
				src.fuel_consumption_schema_id,
				src.quant_distance,
				src.quant_time
			FROM (
				-- Priority 1: vehicle-specific values.
				SELECT
					1 AS priority_no,
					v.fuel_consumption_schema_id,
					vfcsd.quant_distance,
					vfcsd.quant_time
				FROM public.vehicle_fuel_consumption_schema_details AS vfcsd
				WHERE
					vfcsd.vehicle_id = v.id
					AND (
						(
							vfcsd.month_from <= vfcsd.month_to
							AND cb.month_no BETWEEN vfcsd.month_from AND vfcsd.month_to
						)
						OR
						(
							vfcsd.month_from > vfcsd.month_to
							AND (
								cb.month_no >= vfcsd.month_from
								OR cb.month_no <= vfcsd.month_to
							)
						)
					)

				UNION ALL

				-- Priority 2: common schema from vehicles.fuel_consumption_schema_id.
				SELECT
					2 AS priority_no,
					fcsd.fuel_consumption_schema_id,
					fcsd.quant_distance,
					fcsd.quant_time
				FROM public.fuel_consumption_schema_details AS fcsd
				WHERE
					fcsd.fuel_consumption_schema_id = v.fuel_consumption_schema_id
					AND (
						fcsd.month_from IS NULL
						OR fcsd.month_to IS NULL
						OR (
							fcsd.month_from <= fcsd.month_to
							AND cb.month_no BETWEEN fcsd.month_from AND fcsd.month_to
						)
						OR (
							fcsd.month_from > fcsd.month_to
							AND (
								cb.month_no >= fcsd.month_from
								OR cb.month_no <= fcsd.month_to
							)
						)
					)
			) AS src
			WHERE
				src.quant_distance IS NOT NULL
				OR src.quant_time IS NOT NULL
			ORDER BY src.priority_no
			LIMIT 1
		) AS rate ON true

		WHERE
			rate.quant_distance IS NOT NULL
			OR rate.quant_time IS NOT NULL
	),

	inserted AS (
		INSERT INTO public.fuel_consumptions (
			date_time,
			vehicle_id,
			quant,
			mileage,
			timing,
			fuel_consumption_schema_id
		)
		SELECT
			cc.date_time,
			cc.vehicle_id,
			cc.quant,
			cc.mileage,
			cc.timing,
			cc.fuel_consumption_schema_id
		FROM consumption_calc AS cc
		WHERE NOT EXISTS (
			SELECT 1
			FROM public.fuel_consumptions AS fc
			WHERE
				fc.vehicle_id = cc.vehicle_id
				AND fc.date_time = cc.date_time
		)
		RETURNING 1
	)

	SELECT count(*)
	INTO v_inserted_count
	FROM inserted;

	RETURN v_inserted_count;
END;
$BODY$
LANGUAGE plpgsql;
