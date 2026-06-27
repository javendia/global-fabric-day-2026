{{ config(
    materialized='incremental',
    unique_key='sales_key'
) }}

select
    detail.sales_order_detail_id as sales_key,
    detail.sales_order_id,
    header.sales_order_number,
    customer.customer_key,
    product.product_key,
    header.order_date,
    header.ship_date,
    header.status,
    header.status_name,
    header.online_order_flag,
    header.ship_method,
    detail.order_quantity,
    detail.unit_price,
    detail.unit_price_discount,
    detail.line_total,
    detail.gross_line_amount as gross_amount,
    detail.discount_line_amount as discount_amount,
    detail.is_discounted,
    {{ audit_columns() }}
from {{ ref('stg_awlt_sales_order_detail') }} as detail
inner join {{ ref('stg_awlt_sales_order_header') }} as header
    on detail.sales_order_id = header.sales_order_id
left join {{ ref('Customer') }} as customer
    on header.customer_id = customer.customer_key
left join {{ ref('Product') }} as product
    on detail.product_id = product.product_key