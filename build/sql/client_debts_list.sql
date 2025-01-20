-- VIEW: client_debts_list

--DROP VIEW client_debts_list;

CREATE OR REPLACE VIEW client_debts_list AS
	SELECT
		t.id,
		t.firm_id,
		firms_1c_ref(firms_1c) AS firms_ref,
		t.client_id,
		t.client_contract_id,
		clients_ref(clients) AS clients_ref,
		client_contracts_1c_ref(contr) AS client_contracts_ref,
		t.debt_total,
		t.update_date
		
	FROM client_debts AS t
	LEFT JOIN firms_1c ON firms_1c.id = t.firm_id
	LEFT JOIN clients ON clients.id = t.client_id
	LEFT JOIN client_contracts_1c AS contr ON contr.id = t.client_contract_id
	ORDER BY
		firms_1c.ref_1c->>'descr',
		clients.name
	;
