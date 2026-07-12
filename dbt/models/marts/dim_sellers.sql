select
    row_number() over (order by seller_id) as seller_key,
    seller_id,
    seller_city,
    seller_state,
    seller_zip_prefix
from {{ ref('stg_sellers') }}
