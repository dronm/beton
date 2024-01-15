DELETE FROM contacts;
DELETE FROM entity_contacts;


--************************************
INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'clients',
	tl.client_id,
	ct.id
FROM client_tels AS tl
LEFT JOIN contacts AS ct ON ct.tel = tl.tel
WHERE ct.id is not null
ON CONFLICT (entity_type, entity_id, contact_id) DO NOTHING



-- НАСОСЫ ВСЕ УЖЕ ЕСТЬ!!!
--XX
INSERT INTO contacts
(pump_vehicle_id, name, tel)
SELECT
	s2.pvh_id,
	s2.descr,
	format_cel_standart(s2.tel->'fields'->>'tel') AS tel
FROM (
	SELECT
		s.pvh_id,
		s.descr,
		jsonb_array_elements(s.tels) AS tel
	FROM (
		SELECT 
			p.id AS pvh_id,
			'Насос: '||coalesce(v.owner||' ('||v.plate||')', v.plate)||coalesce(' '||p.comment_text,'') AS descr,
			p.phone_cels->'rows' AS tels
		FROM pump_vehicles AS p
		LEFT JOIN vehicles AS v ON v.id = p.vehicle_id
		WHERE p.deleted=false
	) AS s
) AS s2
ON CONFLICT (tel) DO NOTHING

--XX
INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'pump_vehicles',	
	s2.pvh_id,
	ct.id	
FROM (
	SELECT
		s.pvh_id,
		s.descr,
		jsonb_array_elements(s.tels) AS tel
	FROM (
		SELECT 
			p.id AS pvh_id,
			'Насос: '||coalesce(v.owner||' ('||v.plate||')', v.plate)||coalesce(' '||p.comment_text,'') AS descr,
			p.phone_cels->'rows' AS tels
		FROM pump_vehicles AS p
		LEFT JOIN vehicles AS v ON v.id = p.vehicle_id
		WHERE p.deleted=false
	) AS s
) AS s2
LEFT JOIN contacts AS ct ON ct.tel = format_cel_standart(s2.tel->'fields'->>'tel')
--***********************


-- ВОДИТЕЛИ
--XX
INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'drivers',
	dr.id,
	ct.id
from drivers dr
LEFT JOIN contacts AS ct ON ct.tel = format_cel_standart(phone_cel)
where coalesce(dr.phone_cel,'')<>''

--*************************
--XX
INSERT INTO contacts
(name, email, tel, user_id)
SELECT
	u.name,
	u.email,
	format_cel_standart(u.phone_cel),
	u.id
FROM users AS u
WHERE coalesce(u.phone_cel,'')<>''
ON CONFLICT (tel) DO NOTHING;

--XXX
INSERT INTO contacts
(name, email, tel, client_tel_id)
select
	Coalesce(tl.name, cl.name) AS descr,
	tl.email,
	format_cel_standart(tl.tel),
	tl.id
	
from client_tels AS tl
LEFT JOIN clients AS cl ON cl.id = tl.client_id
ORDER BY tl.id asc
ON CONFLICT (tel) DO NOTHING;


DELETE FROM entity_contacts;
--XX
INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'clients',
	tl.client_id,
	ct.id
FROM contacts AS ct
LEFT JOIN client_tels AS tl ON tl.id = ct.client_tel_id
ON CONFLICT (entity_type, entity_id, contact_id) DO NOTHING;

--XX
INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'users',
	ct.user_id,
	ct.id
FROM contacts AS ct
WHERE ct.user_id IS NOT NULL
ON CONFLICT (entity_type, entity_id, contact_id) DO NOTHING;


INSERT INTO entity_contacts
(entity_type, entity_id, contact_id)
SELECT
	'users',
	u.id,
	ct.id
FROM users AS u
LEFT JOIN contacts AS ct ON ct.tel = format_cel_standart(u.phone_cel)
WHERE coalesce(u.phone_cel,'')<>''
ON CONFLICT (entity_type, entity_id, contact_id) DO NOTHING;


--ext_obj - ext_contact_id
UPDATE notifications.ext_users
SET
	ext_contact_id = (
		select ct.id
		from client_tels AS t
		left join contacts AS ct ON ct.tel = format_cel_standart(t.tel) 
		where t.id = (ext_obj->'keys'->>'id')::int
	);

-- ****
select
	format_cel_standart(tl.tel) AS cel_phone	
from client_tels AS tl
WHERE length(format_cel_standart(tl.tel))>11;


--********************
