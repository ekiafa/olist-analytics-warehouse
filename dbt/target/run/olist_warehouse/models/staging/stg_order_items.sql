
  
    
        create or replace table `workspace`.`olist_staging`.`stg_order_items`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    order_id,
    order_item_id as order_item_number,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
from `workspace`.`olist_bronze`.`order_items`
  