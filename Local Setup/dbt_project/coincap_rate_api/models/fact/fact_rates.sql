{{
config(
    materialized = 'incremental',
    unique_key = ['event_timestamp', 'rate_sr_key'],
    merge_exclude_columns = ['event_timestamp', 'rate_sr_key'],
    incremental_strategy = 'merge'
    )
}}


WITH source_data AS (
    SELECT 
        r.id, 
        r.symbol, 
        r.rateUsd,
        r.event_timestamp,           -- From raw data
        CURRENT_TIMESTAMP AS insert_time,  
        CURRENT_TIMESTAMP AS update_time,  
        'Y' AS active_flag,
        -- Get rate_sr_key from the dimension table
        d.rate_sr_key
    FROM 
        coincap_stg.rates_api_raw r 
    LEFT JOIN 
        coincap_stg.dim_rates d ON r.id = d.id   -- Join with the dimension table
)

SELECT
    -- You can use the raw data and enrich it with your dim table information
    source_data.event_timestamp,
    source_data.rateUsd,
    source_data.rate_sr_key
FROM source_data
{% if is_incremental() %}
WHERE source_data.event_timestamp > (SELECT max(event_timestamp) FROM {{ this }})  -- Ensure only new records are added
{% endif %}