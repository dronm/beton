BEGIN;

ALTER TABLE public.car_tracking
	DROP COLUMN IF EXISTS hdop;

COMMIT;

