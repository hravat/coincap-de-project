INSERT INTO coincap_stg.rates_api_raw_archive
    SELECT id, symbol, rateUsd, type,source, event_timestamp
    FROM coincap_stg.rates_api_raw
    WHERE event_timestamp < CURRENT_TIMESTAMP - INTERVAL '10 minutes';


DELETE FROM coincap_stg.rates_api_raw
WHERE event_timestamp < CURRENT_TIMESTAMP - INTERVAL '10 minutes';
