
	DROP INDEX IF EXISTS period_values_idx;
	CREATE UNIQUE INDEX period_values_idx
	ON period_values(period_value_type,key,date_time);
		