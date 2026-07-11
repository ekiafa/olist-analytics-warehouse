select
    order_id,
    order_item_id as order_item_number,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
from {{ source('olist_bronze', 'order_items') }}
