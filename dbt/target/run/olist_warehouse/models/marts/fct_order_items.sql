
  
    
        create or replace table `workspace`.`olist_staging`.`fct_order_items`
      
      
    using delta
  
      
      
      
      
      
      
      
      
      as
      with order_items as (
    select * from `workspace`.`olist_staging`.`stg_order_items`
),

orders as (
    select * from `workspace`.`olist_staging`.`stg_orders`
),

customers_current as (
    select
        row_number() over (order by dbt_scd_id) as customer_key,
        customer_id,
        dbt_valid_to
    from `workspace`.`olist_staging`.`dim_customers_snapshot`
    where dbt_valid_to is null
),

products as (
    select * from `workspace`.`olist_staging`.`dim_products`
),

sellers as (
    select * from `workspace`.`olist_staging`.`dim_sellers`
)

select
    row_number() over (order by oi.order_id, oi.order_item_number) as order_item_key,
    oi.order_id,
    oi.order_item_number,

    c.customer_key,
    p.product_key,
    s.seller_key,
    cast(date_format(o.order_purchase_timestamp, 'yyyyMMdd') as int) as order_date_key,

    oi.price,
    oi.freight_value,
    o.order_status

from order_items oi
inner join orders o on oi.order_id = o.order_id
left join customers_current c on o.customer_id = c.customer_id
left join products p on oi.product_id = p.product_id
left join sellers s on oi.seller_id = s.seller_id
  