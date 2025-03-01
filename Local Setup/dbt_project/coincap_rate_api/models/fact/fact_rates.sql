{{
config(
    materialized='incremental',
    unique_key=['event_timestamp', 'rate_sr_key'],
    merge_exclude_columns=['event_timestamp', 'rate_sr_key'],
    incremental_strategy='merge'
)
}}

WITH source_data AS (
    SELECT 
        d.rate_sr_key,
        to_char(r.event_timestamp, 'YYYYMMDD')::integer date_sr_key, 
        to_char(r.event_timestamp, 'HH24MISS') time_sr_key,
        r.event_timestamp,           -- From raw data
        r.rateUsd,
        CURRENT_TIMESTAMP AS insert_time,  
        CURRENT_TIMESTAMP AS update_time,  
        'Y' AS active_flag
        
    FROM 
        coincap_stg.rates_api_raw r 
    LEFT JOIN 
        coincap_prod.dim_rates d 
        ON r.id = d.id
    {% if is_incremental() %}
    WHERE r.event_timestamp > (SELECT COALESCE(max(event_timestamp),'1900-01-01')  FROM {{ this }})
    {% endif %}
)

{{ dbt_utils.deduplicate(
    relation='source_data',
    partition_by='event_timestamp, rate_sr_key',
    order_by='event_timestamp desc'
) }}
