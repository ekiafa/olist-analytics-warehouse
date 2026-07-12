with reviews as (
    select * from `workspace`.`olist_staging`.`stg_order_reviews`
),

orders as (
    select * from `workspace`.`olist_staging`.`stg_orders`
),

customers_current as (
    select
        row_number() over (order by dbt_scd_id) as customer_key,
        customer_id
    from `workspace`.`olist_staging`.`dim_customers_snapshot`
    where dbt_valid_to is null
)

select
    row_number() over (order by r.review_id) as review_key,
    r.review_id,
    r.order_id,
    c.customer_key,
    cast(date_format(r.review_creation_date, 'yyyyMMdd') as int) as review_date_key,
    r.review_score

from reviews r
inner join orders o on r.order_id = o.order_id
left join customers_current c on o.customer_id = c.customer_id