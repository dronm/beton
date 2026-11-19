BEGIN;

DELETE FROM public.views WHERE id = '50028' AND t = 'vehicleDriverWorkTime';
DROP FUNCTION public.vehicle_driver_work_time(date);

COMMIT;
