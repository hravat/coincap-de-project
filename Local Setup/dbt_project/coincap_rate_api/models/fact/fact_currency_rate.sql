{{
config(
    materialized='incremental',
    unique_key=['event_timestamp', 'CURRENCY_SR_KEY'],
    merge_exclude_columns=['event_timestamp', 'CURRENCY_SR_KEY'],
    incremental_strategy='merge'
)
}}

WITH source_data AS (
    SELECT 
        d.CURRENCY_SR_KEY,
        to_char(r.event_timestamp, 'YYYYMMDD')::integer date_sr_key, 
        to_char(r.event_timestamp, 'HH24MISS') time_sr_key,
        r.event_timestamp,           -- From raw data
        r.rateUsd as CURRENNCY_RATE_IN_USD, -- From raw data
        CURRENT_TIMESTAMP AS insert_time,  
        CURRENT_TIMESTAMP AS update_time,  
        'Y' AS active_flag
        
    FROM 
        coincap_stg.rates_api_raw r 
    LEFT JOIN 
        coincap_prod.dim_currency_rate d 
        ON r.id = d.CURRENCY_ID
    {% if is_incremental() %}
    WHERE r.event_timestamp > (SELECT COALESCE(max(event_timestamp),'1900-01-01')  FROM {{ this }})
    {% endif %}
)

{{ dbt_utils.deduplicate(
    relation='source_data',
    partition_by='event_timestamp, CURRENCY_SR_KEY',
    order_by='event_timestamp desc'
) }}
