
  
    
        create or replace table `workspace`.`olist_staging`.`stg_category_translation`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    product_category_name,
    product_category_name_english
from `workspace`.`olist_bronze`.`category_translation`
  