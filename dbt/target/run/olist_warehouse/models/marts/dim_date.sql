
  
    
        create or replace table `workspace`.`olist_staging`.`dim_date`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      with date_spine as (
    select explode(sequence(
        to_date('2016-01-01'),
        to_date('2018-12-31'),
        interval 1 day
    )) as full_date
)

select
    cast(date_format(full_date, 'yyyyMMdd') as int) as date_key,
    full_date,
    dayofweek(full_date) as day_of_week,
    date_format(full_date, 'EEEE') as day_name,
    month(full_date) as month_number,
    date_format(full_date, 'MMMM') as month_name,
    quarter(full_date) as quarter,
    year(full_date) as year,
    case when dayofweek(full_date) in (1, 7) then true else false end as is_weekend
from date_spine
  