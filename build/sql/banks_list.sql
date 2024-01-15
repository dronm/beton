-- View: banks.banks_list

-- DROP VIEW banks.banks_list;

CREATE OR REPLACE VIEW banks.banks_list
 AS
 SELECT b.bik,
    b.codegr,
    b.name,
    b.korshet,
    b.adres,
    b.gor,
    b.tgroup,
    bgr.name AS gr_descr
   FROM banks.banks b
     LEFT JOIN banks.banks bgr ON b.codegr::text = bgr.bik::text
  WHERE b.tgroup = false
  ORDER BY b.bik;

ALTER TABLE banks.banks_list OWNER TO ;


