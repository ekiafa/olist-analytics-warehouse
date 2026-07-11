
  
    
        create or replace table `workspace`.`olist_staging`.`stg_customers`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix as customer_zip_prefix,
    customer_city,
    customer_state
from `workspace`.`olist_bronze`.`customers`
  