INSERT INTO rates_api_raw_postgres_sink (id, symbol, rateUsd, source, event_timestamp)
SELECT id, symbol, rateUsd, source, event_timestamp 
FROM rates_api_raw;