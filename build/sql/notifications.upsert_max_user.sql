CREATE OR REPLACE FUNCTION notifications.upsert_max_user(
	p_max_user_id bigint,
	p_username text,
	p_avatar_url text,
	p_raw_user jsonb,
	p_raw_user_with_photo jsonb,
	p_contact_id integer
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE notifications.max_users_write
	SET
		username = p_username,
		avatar_url = COALESCE(p_avatar_url, avatar_url),
		raw_user = p_raw_user,
		raw_user_with_photo = COALESCE(p_raw_user_with_photo, raw_user_with_photo),
		contact_id = COALESCE(p_contact_id, contact_id),
		updated_at = now()
	WHERE max_user_id = p_max_user_id;

	IF FOUND THEN
		RETURN;
	END IF;

	BEGIN
		INSERT INTO notifications.max_users_write (
			max_user_id,
			username,
			avatar_url,
			raw_user,
			raw_user_with_photo,
			contact_id,
			updated_at
		)
		VALUES (
			p_max_user_id,
			p_username,
			p_avatar_url,
			p_raw_user,
			p_raw_user_with_photo,
			p_contact_id,
			now()
		);
	EXCEPTION
		WHEN unique_violation THEN
			UPDATE notifications.max_users_write
			SET
				username = p_username,
				avatar_url = COALESCE(p_avatar_url, avatar_url),
				raw_user = p_raw_user,
				raw_user_with_photo = COALESCE(p_raw_user_with_photo, raw_user_with_photo),
				contact_id = COALESCE(p_contact_id, contact_id),
				updated_at = now()
			WHERE max_user_id = p_max_user_id;
	END;
END;
$$;
