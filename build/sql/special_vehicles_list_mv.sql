-- First, create a materialized view
CREATE MATERIALIZED VIEW public.special_vehicles_list_mv AS
WITH shift_bounds AS (
    SELECT
        get_shift_start(CURRENT_DATE) AS shift_from,
        get_shift_start(CURRENT_DATE) + interval '24 hours' AS shift_to
)
SELECT
    v.id,
    vehicles_ref(v) AS vehicles_ref,
    v.tracker_id,
    v.make,

    CASE
        WHEN COALESCE(v.tracker_id, '') = '' THEN FALSE
        WHEN tr_last.period IS NULL THEN TRUE
        ELSE NOW() - (tr_last.period + interval '5 hours') > interval '8 hours'
    END AS tracker_no_signal,

    COALESCE(v.tracker_id, '') = '' AS no_tracker,

    CASE
        WHEN mlg_for_date.id IS NOT NULL THEN
            mlg_for_date.mileage::numeric
        WHEN COALESCE(v.tracker_id, '') = '' THEN
            COALESCE(mlg_last.mileage, 0)::numeric
        ELSE
            COALESCE(mlg_last.mileage, 0)::numeric
            +
            ROUND(
                COALESCE(
                    vehicle_mileage(
                        v.tracker_id,
                        COALESCE(mlg_last.for_date, s.shift_from),
                        s.shift_to
                    ),
                    0
                )
            )::numeric
    END AS mileage,

    CASE
        WHEN mlg_for_date.id IS NOT NULL THEN
            mlg_for_date.timing
        WHEN COALESCE(v.tracker_id, '') = '' THEN
            COALESCE(mlg_last.timing, interval '0 seconds')
        ELSE
            COALESCE(mlg_last.timing, interval '0 seconds')
            +
            COALESCE(
                vehicle_timing(
                    v.id,
                    COALESCE(mlg_last.for_date, s.shift_from),
                    s.shift_to
                ),
                interval '0 seconds'
            )
    END AS timing,

    COALESCE(bal_start.quant, 0)::int AS fuel_flow_start,
    COALESCE(fflow.flow_in, 0)::int AS fuel_flow_in,
    COALESCE(fflow.flow_out, 0)::int AS fuel_flow_out,
    (
        COALESCE(bal_start.quant, 0)
        + COALESCE(fflow.flow_in, 0)
        - COALESCE(fflow.flow_out, 0)
    )::int AS fuel_flow_end,

    v.map_picture

FROM vehicles AS v
CROSS JOIN shift_bounds AS s

LEFT JOIN LATERAL (
    SELECT
        SUM(CASE WHEN fl.deb THEN fl.quant ELSE 0 END) AS flow_in,
        SUM(CASE WHEN NOT fl.deb THEN fl.quant ELSE 0 END) AS flow_out
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
        SUM(quant) AS quant
    FROM rg_fuel_flow_balance(
        CURRENT_DATE,
        ARRAY[v.id]
    )
) AS bal_start ON true

WHERE
    v.feature = 'спецтехника';

-- Create unique index for concurrent refresh
CREATE UNIQUE INDEX idx_special_vehicles_list_mv_id 
ON public.special_vehicles_list_mv (id);
