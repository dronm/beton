-- View: ast_calls_current

-- DROP VIEW ast_calls_current;

-- View: public.ast_calls_current

-- DROP VIEW public.ast_calls_current;

CREATE OR REPLACE VIEW public.ast_calls_current
 AS
 SELECT DISTINCT ON (ast.ext) ast.unique_id,
    ast.ext,
    COALESCE(ct.tel::text,
        CASE
            WHEN clt.tel IS NOT NULL THEN replace(
            CASE
                WHEN substr(clt.tel::text, 1, 2) = '8-'::text THEN substr(clt.tel::text, 3)::character varying
                ELSE clt.tel
            END::text, '-'::text, ''::text)
            WHEN substr(ast.caller_id_num::text, 1, 1) = '+'::text THEN '8'::text || substr(ast.caller_id_num::text, 2)
            ELSE ast.caller_id_num::text
        END) AS contact_tel,
    COALESCE(ct.tel::text,
        CASE
            WHEN clt.tel IS NOT NULL THEN replace(
            CASE
                WHEN substr(clt.tel::text, 1, 2) = '8-'::text THEN substr(clt.tel::text, 3)::character varying
                ELSE clt.tel
            END::text, '-'::text, ''::text)
            WHEN substr(ast.caller_id_num::text, 1, 1) = '+'::text THEN '8'::text || substr(ast.caller_id_num::text, 2)
            ELSE ast.caller_id_num::text
        END) AS num,
    ast.dt AS ring_time,
    ast.start_time AS answer_time,
    ast.end_time AS hangup_time,
    ast.client_id,
    clients_ref(cl.*) AS clients_ref,
    cl.name AS client_descr,
    cl.client_kind,
    get_client_kinds_descr(cl.client_kind) AS client_kind_descr,
    ast.manager_comment,
    ast.informed,
    COALESCE(ct.name::text, clt.name) AS contact_name,
    cld.debt_total::numeric(15,2) AS debt,
    man.name AS client_manager_descr,
    client_types_ref(ctp.*) AS client_types_ref,
    client_come_from_ref(ccf.*) AS client_come_from_ref,
    p.name AS contact_post_name,
    ct.email AS contact_email
   FROM ast_calls ast
     LEFT JOIN clients cl ON cl.id = ast.client_id
     LEFT JOIN users man ON cl.manager_id = man.id
     LEFT JOIN client_tels clt ON clt.client_id = ast.client_id AND (clt.tel::text = ast.caller_id_num::text OR clt.tel::text = format_cel_phone("right"(ast.caller_id_num::text, 10)))
     LEFT JOIN (
	SELECT
		d.client_id,
		sum(d.debt_total) AS debt_total
	FROM client_debts AS d		
	GROUP BY d.client_id
     ) cld ON cld.client_id = ast.client_id
     LEFT JOIN client_types ctp ON ctp.id = cl.client_type_id
     LEFT JOIN client_come_from ccf ON ccf.id = cl.client_come_from_id
     LEFT JOIN contacts ct ON ct.id = ast.contact_id
     LEFT JOIN posts p ON p.id = ct.post_id
  WHERE ast.end_time IS NULL AND char_length(ast.ext::text) <> char_length(ast.caller_id_num::text) AND ast.caller_id_num::text <> ''::text AND (ast.start_time IS NULL AND ast.dt::date = now()::date OR ast.start_time IS NOT NULL AND ast.start_time::date = now()::date)
  ORDER BY ast.ext, ast.dt DESC;

ALTER TABLE public.ast_calls_current
    OWNER TO beton;

