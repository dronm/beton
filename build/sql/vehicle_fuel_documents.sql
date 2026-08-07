-- View: vehicle_fuel_documents;

 DROP VIEW vehicle_fuel_documents;

CREATE OR REPLACE VIEW vehicle_fuel_documents AS

SELECT
	fc.date_time,
	fc.vehicle_id,
	'fuel_consumptions'::text AS doc_type,
	1::smallint AS doc_type_order,
	fc.id::bigint AS source_id,
	0::numeric(15,2) AS quant_deb,
	fc.quant::numeric(15, 2) AS quant_kred,
	NULL::numeric(15, 2) AS total,
	fc.mileage,
	fc.timing,
	NULL::text AS card_id,
	NULL::text AS transaction_id,
	NULL::json AS attrs
FROM fuel_consumptions AS fc

UNION ALL

SELECT
	ft.date_time,
	ft.vehicle_id,
	'fuel_transactions'::text AS doc_type,
	2::smallint AS doc_type_order,
	ft.id AS source_id,
	ft.quant AS quant_deb,
	0::numeric(15,2) AS quant_kred,
	ft.total,
	NULL::integer AS mileage,
	NULL::interval AS timing,
	ft.card_id,
	ft.transaction_id,
	ft.attrs
FROM fuel_transactions AS ft

UNION ALL

SELECT
	ft.date_time,
	ft.vehicle_id,
	'fuel_corrections'::text AS doc_type,
	3::smallint AS doc_type_order,
	ft.id AS source_id,
	CASE WHEN ft.quant_correction >= 0 THEN ft.quant_correction ELSE 0 END AS quant_deb,
	CASE WHEN ft.quant_correction < 0 THEN ft.quant_correction ELSE 0 END AS quant_kred,
	NULL::numeric(15, 2) AS total,
	NULL::integer AS mileage,
	NULL::interval AS timing,
	NULL::text AS card_id,
	NULL::text AS transaction_id,
	NULL::json AS attrs
FROM fuel_corrections AS ft;
