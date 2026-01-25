begin;
drop view vehicles_dialog;
ALTER TABLE public.vehicles DROP COLUMN fuel_card_id;
commit;

