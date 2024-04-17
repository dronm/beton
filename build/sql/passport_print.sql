-- Function: passport_print(in_shipment_id int, in_all bool)

-- DROP FUNCTION passport_print(in_shipment_id int, in_all bool);

CREATE OR REPLACE FUNCTION passport_print(in_shipment_id int, in_all bool)
  RETURNS table(
  	nomer text,
  	client text,
  	smes text,
  	uklad text,
  	smes_num text,
  	obiem text,
  	vremia_otpravki text,
	klass_prochnosti text,
	drugie_pokazateli_kach text,
	sohran_udobouklad text,
	kf_prochnosti text,
	prochnost text,
	naim_dobavki text,
	aeff text,
	krupnost text,
	vidan text,
	reg_nomer_dekl text
  ) AS
$BODY$
BEGIN
	IF in_all THEN
		-- all shipments
		RETURN QUERY
		WITH
		sh_orders AS (SELECT t.order_id AS id FROM shipments AS t WHERE t.id = in_shipment_id)
		
		SELECT
			--o.number order_num(o.*)
			'Документ о качестве бетонной смеси заданного качества партии № '||
				(SELECT 
				CASE WHEN EXTRACT(DAY FROM o.date_time)<10 THEN
					'0' || EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
				ELSE
					EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
				END)
			AS nomer,
			coalesce(cl.name_full, cl.name) AS client,
			
			CASE
				WHEN upper(substring(ct.name, 1,2)) = 'ПБ' THEN
					FORMAT('БСМ %s %s',
						CASE
							WHEN position('(' in official_name)>0 THEN
								substring(ct.official_name, 1, position('(' in ct.official_name)-1)
							ELSE ct.official_name
						END,
						pas.vid_smesi_gost::text					
					)					
				ELSE
					FORMAT('БСТ %s F%sW%s %s',
						--ct.official_name::text,
						CASE
							WHEN position('(' in official_name)>0 THEN
								substring(ct.official_name, 1, position('(' in ct.official_name)-1)
							ELSE ct.official_name
						END,
						pas.f_val::text, pas.w_val::text, pas.vid_smesi_gost::text					
					)
			END AS smes,
			
			pas.uklad AS uklad,
			
			--ID подбора/порядковый номер материала в подбре
			pas.smes_num AS smes_num,
			
			REPLACE(sum(sh.quant)::text, '.', ',') || ' м3' AS obiem,
			to_char(o.date_time, 'dd/mm/yy') || (
				SELECT
					to_char(min(t.ship_date_time), 'HH24:MI')|| ' - ' ||to_char(max(t.ship_date_time), 'HH24:MI')
				FROM shipments AS t
				WHERE t.order_id = (SELECT id FROM sh_orders)
			) AS vremia_otpravki,
			ct.official_name::text AS klass_prochnosti,
			FORMAT('F%sW%s', pas.f_val::text, pas.w_val::text) AS drugie_pokazateli_kach,
			pas.sohran_udobouklad AS sohran_udobouklad,
			pas.kf_prochnosti AS kf_prochnosti,
			pas.prochnost::text AS prochnost,
			pas.naim_dobavki AS naim_dobavki,
			pas.aeff AS aeff,
			pas.krupnost::text AS krupnost,
			to_char(o.date_time, 'dd/mm/yyyy') AS vidan,
			pas.reg_nomer_dekl::text AS reg_nomer_dekl
			
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		LEFT JOIN clients AS cl ON cl.id = o.client_id
		LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
		LEFT JOIN quality_passports AS pas ON pas.shipment_id = in_shipment_id
		WHERE sh.order_id = (SELECT id FROM sh_orders)
		GROUP BY
			cl.name_full, cl.name,
			o.date_time,
			o.number,
			ct.official_name,
			pas.uklad,
			pas.f_val,pas.w_val,
			pas.vid_smesi_gost,
			pas.sohran_udobouklad,
			pas.kf_prochnosti,
			pas.prochnost,
			pas.naim_dobavki,
			pas.aeff,
			pas.krupnost,
			pas.reg_nomer_dekl,
			pas.id,
			ct.name		
		;
	ELSE
		-- one shipment
		RETURN QUERY
		WITH
		ship_num AS (
			SELECT
				ROW_NUMBER() OVER() AS num,
				sh.id
			FROM shipments AS sh
			WHERE sh.order_id = (SELECT sh_t.order_id FROM shipments AS sh_t WHERE sh_t.id = in_shipment_id)
			ORDER BY sh.ship_date_time		
		)
		SELECT
			--o.number/shipment порядковый номер отрузки
			'Документ о качестве бетонной смеси заданного качества партии № '||
				(SELECT 
				CASE WHEN EXTRACT(DAY FROM o.date_time)<10 THEN
					'0' || EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
				ELSE
					EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
				END) ||'/'|| (SELECT ship_num.num::text FROM ship_num WHERE ship_num.id = in_shipment_id)			
			AS nomer,
			
			coalesce(cl.name_full, cl.name) AS client,
			
			CASE
				WHEN upper(substring(ct.name, 1,2)) = 'ПБ' THEN
					FORMAT('БСМ %s %s',
						CASE
							WHEN position('(' in official_name)>0 THEN
								substring(ct.official_name, 1, position('(' in ct.official_name)-1)
							ELSE ct.official_name
						END,
						pas.vid_smesi_gost::text					
					)
				ELSE
					-- убрать то, что в скобках
					FORMAT('БСТ %s F%sW%s %s',
						--ct.official_name::text,
						CASE
							WHEN position('(' in official_name)>0 THEN
								substring(ct.official_name, 1, position('(' in ct.official_name)-1)
							ELSE ct.official_name
						END,
						pas.f_val::text, pas.w_val::text, pas.vid_smesi_gost::text					
					)
			END AS smes,
			
			pas.uklad AS uklad,
			
			--ID подбора/порядковый номер материала в подбре
			pas.smes_num AS smes_num,
			
			REPLACE(sh.quant::text, '.', ',') || ' м3' AS obiem,
			to_char(sh.ship_date_time, 'dd/mm/yy HH24:MI') vremia_otpravki,
			ct.official_name::text AS klass_prochnosti,
			FORMAT('F%sW%s', pas.f_val::text, pas.w_val::text) AS drugie_pokazateli_kach,
			pas.sohran_udobouklad AS sohran_udobouklad,
			pas.kf_prochnosti AS kf_prochnosti,
			pas.prochnost::text AS prochnost,
			pas.naim_dobavki AS naim_dobavki,
			pas.aeff AS aeff,
			pas.krupnost::text AS krupnost,
			to_char(sh.date_time, 'dd/mm/yyyy') AS vidan,
			pas.reg_nomer_dekl::text AS reg_nomer_dekl
			
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		LEFT JOIN clients AS cl ON cl.id = o.client_id
		LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
		LEFT JOIN quality_passports AS pas ON pas.shipment_id = sh.id
		WHERE sh.id = in_shipment_id;
	END IF;		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION passport_print(in_shipment_id int, in_all bool) OWNER TO ;
