BEGIN;
DELETE FROM views WHERE id = '10063' AND t = 'ClientMerge';
DROP FUNCTION IF EXISTS public.clients_merge(integer, integer[]);
COMMIT;
-- This removes the feature. It cannot restore clients deleted by completed merges.
