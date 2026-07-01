begin;
alter table car_tracking add column if not exists pins jsonb;
CREATE INDEX IF NOT EXISTS car_tracking_pins_gin_idx
	ON car_tracking USING gin (pins);
commit;
