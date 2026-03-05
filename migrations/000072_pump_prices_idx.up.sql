CREATE INDEX CONCURRENTLY IF NOT EXISTS pump_prices_values_lookup_idx
ON pump_prices_values (pump_price_id, quant_to);
