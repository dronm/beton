BEGIN;	

CREATE TABLE IF NOT EXISTS const_ping_elkon_interval_err
	(name text, descr text, val  int,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);

	INSERT INTO const_ping_elkon_interval_err (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Elkon error ping interval in ms ping'
		,'Elkon ping'
		,300000
		,'int'
		,NULL
		,NULL
		,NULL
		,NULL
	);
		--constant get value
	CREATE OR REPLACE FUNCTION const_ping_elkon_interval_err_val()
	RETURNS  int AS
	$BODY$
		SELECT val AS val FROM const_ping_elkon_interval_err LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;

	--constant set value
	CREATE OR REPLACE FUNCTION const_ping_elkon_interval_err_set_val(int)
	RETURNS void AS
	$BODY$
		UPDATE const_ping_elkon_interval_err SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;

	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_ping_elkon_interval_err_view AS
	SELECT
		'ping_elkon_interval_err'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_ping_elkon_interval_err AS t
	;

COMMIT;
