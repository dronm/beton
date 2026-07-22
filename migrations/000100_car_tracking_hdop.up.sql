BEGIN;

ALTER TABLE public.car_tracking
	ADD COLUMN IF NOT EXISTS hdop numeric(5, 2);

COMMENT ON COLUMN public.car_tracking.hdop IS
	'Arnavi horizontal dilution of precision. Protocol tag 151 stores uint16 little-endian divided by 100. NULL means the tracker did not send HDOP.';

COMMIT;

