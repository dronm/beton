
--DROP FUNCTION vehicle_mileages_update()
--DROP FUNCTION vehicle_mileages_update();

CREATE OR REPLACE FUNCTION vehicle_mileages_update()
RETURNS void AS $$
DECLARE
    vehicle RECORD; -- Holds the current vehicle record in the loop
    start_time TIMESTAMPTZ; -- Time to start updating
    end_time TIMESTAMPTZ; -- Time to calculate up to
    new_mileage INT; -- Computed mileage
    new_user_id INT;
BEGIN
	new_user_id := ((SELECT const_reglament_user_val()->'keys'->>'id'))::int;
	
    -- Main loop to iterate through vehicles
    FOR vehicle IN
	    -- Use a CTE to find the most recent mileage records for each vehicle
	    WITH latest_mileage AS (
		SELECT 
		    vehicle_id, 
		    MAX(for_date) AS last_date
		FROM vehicle_mileages
		GROUP BY vehicle_id
	    )
    
        SELECT 
            vm.vehicle_id, 
            vm.for_date, 
            vm.mileage,
            veh.tracker_id
        FROM vehicle_mileages vm
        INNER JOIN latest_mileage lm
        ON vm.vehicle_id = lm.vehicle_id AND vm.for_date = lm.last_date
        LEFT JOIN vehicles AS veh ON veh.id = vm.vehicle_id
    LOOP
        -- Initialize the start time from the last recorded mileage
        start_time := vehicle.for_date;

        -- Process mileage for each day until the current time
        WHILE (start_time + INTERVAL '1 day') <= now() LOOP
            -- Set the end of the current day at 06:00
            end_time := start_time + INTERVAL '1 day';

            -- Calculate mileage using the custom function
            new_mileage := round(vehicle_mileage(
                vehicle.tracker_id,
                start_time,
                end_time - INTERVAL '1 second'
            ));

            -- Insert the new mileage record into the table
            INSERT INTO vehicle_mileages (vehicle_id, for_date, user_id, mileage)
            VALUES (
                vehicle.vehicle_id,
                end_time,
                new_user_id,
                vehicle.mileage + new_mileage
            );

            -- Update the vehicle's mileage and increment the start time
            vehicle.mileage := vehicle.mileage + new_mileage;
            start_time := end_time;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

