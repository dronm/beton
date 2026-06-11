-- Function: public.special_vehicles_list(in_date timestamp);

-- DROP FUNCTION public.special_vehicles_list(in_date timestamp);

CREATE OR REPLACE FUNCTION public.special_vehicles_list(in_date timestamp)
  RETURNS TABLE(
	vehicles_ref json,
	tracker_id text,
	make text,
	tracker_no_signal bool,
	mileage numeric,
	timing time,
	fuel_flow_start int,
	fuel_flow_in int,
	fuel_flow_out int,
	fuel_flow_end int
) AS
$BODY$
	WITH shift AS (
		SELECT
			get_shift_start(in_date) AS from,
			get_shift_start(in_date) + '24 hours'::interval AS to
		)
	SELECT
		vehicles_ref(v) AS vehicles_ref,
		v.tracker_id,
		v.make,
		now() - tr_last.period > '30 seconds'::interval AS tracker_no_signal,

		-- mileage
		mlg_last.mileage + 
			vehicle_mileage(
				v.tracker_id, 
				(SELECT shift.from FROM shift),
				(SELECT shift.to FROM shift)
		) AS mileage,

		 vehicle_timing(
			v.id, 
			(SELECT shift.from FROM shift),
			(SELECT shift.to FROM shift)
		) AS timing,

		--fuel flow
		coalesce(bal_start.quant, 0) AS fuel_flow_start,
		fflow.flow_in AS fuel_flow_in,
		fflow.flow_out AS fuel_flow_out,
		coalesce(bal_start.quant, 0) + coalesce(fflow.flow_in, 0)
			 - coalesce(fflow.flow_out, 0) AS fuel_flow_end

	FROM vehicles AS v

	LEFT JOIN LATERAL (
		SELECT 
			SUM(CASE WHEN fl.deb THEN fl.quant ELSE 0 END) AS flow_in,
			SUM(CASE WHEN NOT fl.deb THEN fl.quant ELSE 0 END) AS flow_out
		FROM ra_fuel_flow AS fl
		WHERE 
			fl.vehicle_id = v.id
			AND fl.date_time >= (SELECT shift.from FROM shift) 
			AND fl.date_time < (SELECT shift.to FROM shift) 
		LIMIT 1
	) AS fflow ON TRUE

	LEFT JOIN LATERAL (
		SELECT 
			tr.period
		FROM car_tracking AS tr
		WHERE tr.car_id = v.tracker_id AND tr.gps_valid = 1
		ORDER BY tr.period DESC
		LIMIT 1
	) AS tr_last ON TRUE

	LEFT JOIN LATERAL (
		SELECT
			mlg.mileage
		FROM vehicle_mileages AS mlg
		WHERE mlg.vehicle_id = v.id
		ORDER BY mlg.for_date DESC
		LIMIT 1
	) AS mlg_last ON TRUE

	LEFT JOIN LATERAL (
	SELECT 
		SUM(quant) AS quant
	FROM rg_fuel_flow_balance(
			in_date,
			ARRAY[v.id]
		)
	) AS bal_start ON TRUE

	WHERE v.feature = 'основ' -- 'запас' -- спецтехника
		AND coalesce(v.tracker_id, '') <> ''
	;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
