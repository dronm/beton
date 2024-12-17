SELECT
	--pg_terminate_backend(pid)
	pid
FROM pg_stat_activity
WHERE datname = 'beton'
AND pid <> pg_backend_pid()
AND state in ('idle');

SELECT
	pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'concrete1'
AND pid <> pg_backend_pid()
AND state in ('idle');
