
  
    
        create or replace table `workspace`.`olist_staging`.`stg_order_payments`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
from `workspace`.`olist_bronze`.`order_payments`
  