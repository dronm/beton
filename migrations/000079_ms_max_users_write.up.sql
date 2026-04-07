begin;

	CREATE FOREIGN TABLE notifications.max_users_write (
		max_user_id bigint,
		username text,
		avatar_url text,
		raw_user jsonb,
		raw_user_with_photo jsonb,
		contact_id integer,
		updated_at timestamptz
	)
	SERVER ms
	OPTIONS (
		schema_name 'notifications',
		table_name 'max_users'
	);

	CREATE FOREIGN TABLE notifications.max_in_messages_write (
		message jsonb,
		contact_id integer,
		app_id integer
	)
	SERVER ms
	OPTIONS (
		schema_name 'notifications',
		table_name 'max_in_messages'
	);

	CREATE FOREIGN TABLE notifications.max_out_messages_write (
		message jsonb,
		max_chat_id bigint,
		contact_id integer,
		app_id integer
	)
	SERVER ms
	OPTIONS (
		schema_name 'notifications',
		table_name 'max_out_messages'
	);
commit;
