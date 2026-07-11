
  
    
        create or replace table `workspace`.`olist_staging`.`stg_sellers`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    seller_id,
    seller_zip_code_prefix as seller_zip_prefix,
    seller_city,
    seller_state
from `workspace`.`olist_bronze`.`sellers`
  