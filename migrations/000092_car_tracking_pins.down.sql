begin;

alter table car_tracking drop column if exists pins;

DROP INDEX IF EXISTS car_tracking_pins_gin_idx;
commit;
