BEGIN;
	-- ********** Adding new table from model **********
	CREATE TABLE public.workplace_schedules
	(
		id serial NOT NULL,
		workplace_id int NOT NULL REFERENCES workplaces(id),
		user_id int NOT NULL REFERENCES users(id),
		for_date date NOT NULL,
		CONSTRAINT workplace_schedules_pkey PRIMARY KEY (id)
	);
	DROP INDEX IF EXISTS workplace_schedules_for_date_idx;
	CREATE INDEX workplace_schedules_for_date_idx
	ON workplace_schedules(for_date);

	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'20032',
	'WorkplaceSchedule_Controller',
	'get_list',
	'WorkplaceScheduleList',
	'Документы',
	'Расписание работы пользователей',
	FALSE
	);

COMMIT;
