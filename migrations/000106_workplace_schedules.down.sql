BEGIN;
	DROP TABLE public.workplace_schedules;

	DELETE FROM views WHERE id = '20032';

COMMIT;

