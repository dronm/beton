
-- DROP FUNCTION public.vehicle_fuel_consumption_insert;

CREATE OR REPLACE FUNCTION public.vehicle_fuel_consumption_insert(
	p_vehicle_id integer,
	p_for_date timestamp with time zone,
	p_cumulative_mileage integer,
	p_timing interval
)
RETURNS integer
LANGUAGE plpgsql
VOLATILE
AS $function$
DECLARE
	v_date_time timestamp without time zone;
	v_month integer;

	v_previous_mileage integer;
	v_period_mileage integer;

	v_common_schema_id integer;
	v_applied_schema_id integer;

	v_quant_distance numeric(15, 2);
	v_quant_time numeric(15, 2);
	v_matching_details_count bigint;

	v_timing interval;
	v_engine_hours numeric;
	v_quant integer;

	v_fuel_consumption_id integer;
BEGIN
	IF p_vehicle_id IS NULL THEN
		RAISE EXCEPTION 'Vehicle ID cannot be NULL';
	END IF;

	IF p_for_date IS NULL THEN
		RAISE EXCEPTION
			'Fuel consumption date cannot be NULL for vehicle %',
			p_vehicle_id;
	END IF;

	IF p_cumulative_mileage IS NULL THEN
		RETURN NULL;
	END IF;

	/*
	 * fuel_consumptions.date_time is timestamp without time zone.
	 *
	 * This conversion uses the current PostgreSQL session TimeZone.
	 */
	v_date_time := p_for_date::timestamp without time zone;
	v_month := EXTRACT(MONTH FROM v_date_time)::integer;
	v_timing := COALESCE(p_timing, interval '0');

	IF v_timing < interval '0' THEN
		RAISE EXCEPTION
			'Negative timing % for vehicle % at %',
			v_timing,
			p_vehicle_id,
			p_for_date;
	END IF;

	/*
	 * Check that the vehicle exists and get its common schema.
	 */
	SELECT
		v.fuel_consumption_schema_id
	INTO
		v_common_schema_id
	FROM public.vehicles AS v
	WHERE v.id = p_vehicle_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Vehicle % does not exist', p_vehicle_id;
	END IF;

	/*
	 * First try the vehicle-specific schema.
	 *
	 * A range where month_from > month_to wraps over the year boundary.
	 * For example, 11..3 means November through March.
	 *
	 * Both NULL values are treated as an all-year rule.
	 */
	SELECT
		d.quant_distance,
		d.quant_time,
		COUNT(*) OVER ()
	INTO
		v_quant_distance,
		v_quant_time,
		v_matching_details_count
	FROM public.vehicle_fuel_consumption_schema_details AS d
	WHERE d.vehicle_id = p_vehicle_id
		AND (
			(
				d.month_from IS NULL
				AND d.month_to IS NULL
			)
			OR (
				d.month_from IS NOT NULL
				AND d.month_to IS NOT NULL
				AND (
					(
						d.month_from <= d.month_to
						AND v_month BETWEEN d.month_from AND d.month_to
					)
					OR (
						d.month_from > d.month_to
						AND (
							v_month >= d.month_from
							OR v_month <= d.month_to
						)
					)
				)
			)
		)
	ORDER BY d.id
	LIMIT 1;

	IF FOUND THEN
		IF v_matching_details_count > 1 THEN
			RAISE EXCEPTION
				'Vehicle % has % overlapping vehicle-specific fuel consumption rules for month %',
				p_vehicle_id,
				v_matching_details_count,
				v_month;
		END IF;

		/*
		 * There is no schema ID for vehicle-specific details.
		 */
		v_applied_schema_id := NULL;
	ELSE
		/*
		 * No vehicle-specific rule matched. Use the common schema.
		 */
		IF v_common_schema_id IS NULL THEN
			RAISE WARNING
				'Vehicle % has no applicable fuel consumption schema for month %',
				p_vehicle_id,
				v_month;

			RETURN NULL;
		END IF;

		SELECT
			d.quant_distance,
			d.quant_time,
			COUNT(*) OVER ()
		INTO
			v_quant_distance,
			v_quant_time,
			v_matching_details_count
		FROM public.fuel_consumption_schema_details AS d
		WHERE d.fuel_consumption_schema_id = v_common_schema_id
			AND (
				(
					d.month_from IS NULL
					AND d.month_to IS NULL
				)
				OR (
					d.month_from IS NOT NULL
					AND d.month_to IS NOT NULL
					AND (
						(
							d.month_from <= d.month_to
							AND v_month BETWEEN d.month_from AND d.month_to
						)
						OR (
							d.month_from > d.month_to
							AND (
								v_month >= d.month_from
								OR v_month <= d.month_to
							)
						)
					)
				)
			)
		ORDER BY d.id
		LIMIT 1;

		IF NOT FOUND THEN
			RAISE WARNING
				'Fuel consumption schema % has no details for month %; vehicle % was not processed',
				v_common_schema_id,
				v_month,
				p_vehicle_id;

			RETURN NULL;
		END IF;

		IF v_matching_details_count > 1 THEN
			RAISE EXCEPTION
				'Fuel consumption schema % has % overlapping rules for month %',
				v_common_schema_id,
				v_matching_details_count,
				v_month;
		END IF;

		v_applied_schema_id := v_common_schema_id;
	END IF;

	/*
	 * Mileage in vehicle_mileages is cumulative.
	 *
	 * Find the preceding cumulative value and calculate mileage for the
	 * current period.
	 */
	SELECT
		vm.mileage
	INTO
		v_previous_mileage
	FROM public.vehicle_mileages AS vm
	WHERE vm.vehicle_id = p_vehicle_id
		AND vm.for_date < p_for_date
		AND vm.mileage IS NOT NULL
	ORDER BY vm.for_date DESC
	LIMIT 1;

	/*
	 * The first mileage row establishes the starting odometer value.
	 * Fuel consumption cannot be calculated from it.
	 */
	IF NOT FOUND THEN
		RETURN NULL;
	END IF;

	v_period_mileage := p_cumulative_mileage - v_previous_mileage;

	/*
	IF v_period_mileage < 0 THEN
		RAISE EXCEPTION
			'Cumulative mileage decreased for vehicle % at %: previous %, current %',
			p_vehicle_id,
			p_for_date,
			v_previous_mileage,
			p_cumulative_mileage;
	END IF;
	*/

	v_engine_hours :=
		EXTRACT(EPOCH FROM v_timing)::numeric / 3600;

	/*
	 * quant_distance: fuel per 100 km.
	 * quant_time: fuel per engine hour.
	 *
	 * fuel_consumptions.quant is integer, so the result is rounded.
	 */
	v_quant := ROUND(
		(
			v_period_mileage::numeric
			* COALESCE(v_quant_distance, 0)
			/ 100
		)
		+
		(
			v_engine_hours
			* COALESCE(v_quant_time, 0)
		)
	)::integer;

	INSERT INTO public.fuel_consumptions (
		date_time,
		vehicle_id,
		quant,
		mileage,
		timing,
		fuel_consumption_schema_id
	)
	VALUES (
		v_date_time,
		p_vehicle_id,
		v_quant,
		v_period_mileage,
		v_timing,
		v_applied_schema_id
	)
	ON CONFLICT (vehicle_id, date_time)
	DO UPDATE SET
		quant = EXCLUDED.quant,
		mileage = EXCLUDED.mileage,
		timing = EXCLUDED.timing,
		fuel_consumption_schema_id =
			EXCLUDED.fuel_consumption_schema_id
	RETURNING id
	INTO v_fuel_consumption_id;

	RETURN v_fuel_consumption_id;
END;
$function$;

