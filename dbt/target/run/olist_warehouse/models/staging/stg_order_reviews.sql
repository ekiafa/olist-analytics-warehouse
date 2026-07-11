
  
    
        create or replace table `workspace`.`olist_staging`.`stg_order_reviews`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      select
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
from `workspace`.`olist_bronze`.`order_reviews`
  