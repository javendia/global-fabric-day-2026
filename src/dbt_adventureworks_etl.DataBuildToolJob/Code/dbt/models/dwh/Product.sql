select
    product.product_id as product_key,
    product.product_id,
    product.product_name,
    product.product_number,
    product.color,
    product.size,
    product.standard_cost,
    product.list_price,
    product.is_current_product,
    category.product_category_name,
    parent_category.product_category_name as parent_product_category_name,
    model.product_model_name,
    {{ audit_columns() }}
from {{ ref('stg_awlt_product') }} as product
left join {{ ref('stg_awlt_product_category') }} as category
    on product.product_category_id = category.product_category_id
left join {{ ref('stg_awlt_product_category') }} as parent_category
    on category.parent_product_category_id = parent_category.product_category_id
left join {{ ref('stg_awlt_product_model') }} as model
    on product.product_model_id = model.product_model_id