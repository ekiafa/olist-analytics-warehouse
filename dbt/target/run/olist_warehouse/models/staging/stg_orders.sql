
  
    
        create or replace table `workspace`.`olist_staging`.`stg_orders`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
from `workspace`.`olist_bronze`.`orders`
  