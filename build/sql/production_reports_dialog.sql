-- VIEW: public.production_reports_dialog;

--DROP VIEW public.production_reports_dialog;

CREATE OR REPLACE VIEW public.production_reports_dialog AS
SELECT
    t.id,
    t.shift_from,
    t.shift_to,
    t.ref_1c,
    t.data_for_1c,
    
    -- Use json_agg to handle multiple rows
    (SELECT json_agg(row_to_json(it.*)) 
     FROM production_reports_items(t.shift_from, t.shift_to) AS it) AS items,
    
    (SELECT json_agg(row_to_json(mat.*)) 
     FROM production_reports_materials(t.shift_from, t.shift_to) AS mat) AS materials,
    
    (SELECT
        json_build_object(
            'ref_1c', t.ref_1c->>'id',
            'date', t.shift_to,
            'comment', 'Отчет за смену ' ||
                      to_char(t.shift_from, 'DD/MM/YY') || ' - ' ||
                      to_char(t.shift_to, 'DD/MM/YY'),
            'items', (SELECT json_agg(row_to_json(it.*)) 
                     FROM production_reports_items(t.shift_from, t.shift_to) AS it),
            'materials', (SELECT json_agg(row_to_json(mat.*)) 
                         FROM production_reports_materials(t.shift_from, t.shift_to) AS mat)
        )
    ) AS data_for_1c_current
    
FROM production_reports AS t;
