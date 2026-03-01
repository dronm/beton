CREATE OR REPLACE FUNCTION attachments_for_key(in_id int, in_data_type text)
  RETURNS jsonb AS
$BODY$
	SELECT
		jsonb_agg(
			att.content_info || 
			case when att.content_preview is not null then 
				jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			else '{}'::jsonb
			end
		)
	FROM attachments AS att
	WHERE att.ref->>'dataType' = in_data_type AND (att.ref->'keys'->>'id')::int = in_id
	;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

