{% snapshot dim_customers_snapshot %}

{{
    config(
      target_schema='olist_staging',
      unique_key='customer_id',
      strategy='check',
      check_cols=['customer_city', 'customer_state'],
    )
}}

select
    customer_id,
    customer_unique_id,
    customer_zip_prefix,
    customer_city,
    customer_state
from {{ ref('stg_customers') }}

{% endsnapshot %}
