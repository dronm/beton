BEGIN;	
	DROP VIEW const_ping_elkon_interval_err_view;
	DROP FUNCTION const_ping_elkon_interval_err_set_val(int);
	DROP FUNCTION const_ping_elkon_interval_err_val();
	DROP TABLE const_ping_elkon_interval_err;

COMMIT;

