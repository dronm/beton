begin;
ALTER TABLE public.material_fact_balance_corrections DROP COLUMN last_modif_user_id;
ALTER TABLE public.material_fact_balance_corrections DROP COLUMN last_modif_date_time;

commit;
