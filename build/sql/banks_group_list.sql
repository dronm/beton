-- View: banks.banks_group_list

-- DROP VIEW banks.banks_group_list;

CREATE OR REPLACE VIEW banks.banks_group_list
 AS
 SELECT b.bik,
    b.codegr,
    b.name,
    b.korshet,
    b.adres,
    b.gor,
    b.tgroup
   FROM banks.banks b
  WHERE b.tgroup = true
  ORDER BY b.name;

ALTER TABLE banks.banks_group_list
    OWNER TO ;

