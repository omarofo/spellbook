{{ config(
        alias ='mints',
        materialized ='incremental',
        file_format ='delta',
        incremental_strategy='merge',
        unique_key='unique_trade_id'
        )
}}

SELECT * FROM (
SELECT * FROM {{ ref('opensea_mints') }} 
         UNION
SELECT * FROM {{ ref('magiceden_mints') }})

{% if is_incremental() %}
-- this filter will only be applied on an incremental run
WHERE block_time > now() - interval 2 days
{% endif %} 