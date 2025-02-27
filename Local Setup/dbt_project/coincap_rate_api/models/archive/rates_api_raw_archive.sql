{{ config(
    materialized='append_only'
) }}

INSERT INTO coincap_stg.rates_api_raw_archive 
    SELECT * FROM coincap_stg.rates_api_raw 
    WHERE event_timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'Pacific/Auckland' 
        < CURRENT_TIMESTAMP - INTERVAL '10 minutes'