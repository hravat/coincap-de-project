
{{
config(
    materialized = 'incremental',
    unique_key = 'currency_id',
    merge_exclude_columns = ['insert_time','active_flag','currency_sr_key'],
    incremental_strategy = 'merge'
    )
}}

WITH source_data AS (
    SELECT 
        id, 
        symbol, 
        type,
        event_timestamp,
        CURRENT_TIMESTAMP AS insert_time,  
        CURRENT_TIMESTAMP AS update_time,  
        'Y' AS active_flag,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY event_timestamp DESC) AS rn
    FROM coincap_stg.rates_api_raw
)
SELECT
    --{{ dbt_utils.generate_surrogate_key(['source_data.id']) }} AS rate_sr_key,
    nextval('coincap_stg.rate_sr_key_sequence') AS currency_sr_key,
    source_data.id AS currency_id, 
    source_data.symbol AS currency_symbol,
    source_data.type AS currency_type,
    source_data.insert_time,
    source_data.update_time,
    source_data.active_flag,
    source_data.event_timestamp
FROM source_data
{% if is_incremental() %}
WHERE source_data.rn = 1
{% endif %}