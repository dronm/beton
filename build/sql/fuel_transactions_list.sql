-- VIEW: fuel_transactions_list

--DROP VIEW fuel_transactions_list;

CREATE OR REPLACE VIEW fuel_transactions_list AS
	SELECT
		t.id,
		t.transaction_id,
		t.date_time,
		t.card_id,
		t.vehicle_id,
		vehicles_ref(vh) AS vehicles_ref,
		t.attrs,
		t.quant,
		t.total
	FROM fuel_transactions AS t
	LEFT JOIN vehicles AS vh ON vh.id = t.vehicle_id
	ORDER BY t.id desc
	;

