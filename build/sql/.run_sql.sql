-- Function: logins_process()

-- DROP FUNCTION logins_process();

CREATE OR REPLACE FUNCTION logins_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF OLD.date_time_out IS NULL AND NEW.date_time_out IS NOT NULL
		AND coalesce(NEW.pub_key,'')<>'' THEN
			--event
			--RAISE EXCEPTION 'pub_key=%',trim(NEW.pub_key);
			-- deprecated event
			PERFORM pg_notify(
				'User.logout'
				,json_build_object(
					'params',json_build_object(
						'pub_key',trim(NEW.pub_key)
					)
				)::text
			);
			
			-- new event trapped by browsers
			PERFORM pg_notify(
				'User.logout.' || trim(NEW.pub_key), NULL
			);			
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION logins_process()
  OWNER TO beton;

