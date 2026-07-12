select
    row_number() over (order by p.product_id) as product_key,
    p.product_id,
    coalesce(t.product_category_name_english, p.product_category_name) as product_category,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
from `workspace`.`olist_staging`.`stg_products` p
left join `workspace`.`olist_staging`.`stg_category_translation` t
    on p.product_category_name = t.product_category_name