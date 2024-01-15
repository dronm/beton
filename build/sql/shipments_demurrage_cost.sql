-- Function: public.shipments_demurrage_cost(interval, in_date_time timestamp)

-- DROP FUNCTION public.shipments_demurrage_cost(interval, in_date_time timestamp);

CREATE OR REPLACE FUNCTION public.shipments_demurrage_cost(in_demurrage_time interval, in_date_time timestamp)
  RETURNS numeric AS
$BODY$
	SELECT 
		CASE
			WHEN in_demurrage_time>'00:00' THEN
				/*
				round( (EXTRACT(EPOCH FROM GREATEST(in_demurrage_time,constant_min_demurrage_time()))::numeric
					* demurrage_cost_per_hour_on_date(in_date_time) / 3600::numeric
					)/100
				)*100
				*/
				((
					extract(hour FROM in_demurrage_time) + 
					round( extract(minute FROM in_demurrage_time)::numeric/60,1)
				) * demurrage_cost_per_hour_on_date(in_date_time)

				)::numeric			
			ELSE 0
		END;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION public.shipments_demurrage_cost(interval, in_date_time timestamp)
  OWNER TO beton;

