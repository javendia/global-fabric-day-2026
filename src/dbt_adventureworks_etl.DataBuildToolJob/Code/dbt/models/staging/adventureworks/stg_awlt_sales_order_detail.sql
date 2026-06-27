select
    SalesOrderID as sales_order_id,
    SalesOrderDetailID as sales_order_detail_id,
    OrderQty as order_quantity,
    ProductID as product_id,
    cast(UnitPrice as decimal(18, 4)) as unit_price,
    cast(UnitPriceDiscount as decimal(18, 4)) as unit_price_discount,
    cast(LineTotal as decimal(18, 4)) as line_total,
    cast(OrderQty * cast(UnitPrice as decimal(18, 4)) as decimal(18, 4)) as gross_line_amount,
    cast(OrderQty * cast(UnitPrice as decimal(18, 4)) * cast(UnitPriceDiscount as decimal(18, 4)) as decimal(18, 4)) as discount_line_amount,
    case
        when coalesce(cast(UnitPriceDiscount as decimal(18, 4)), 0) > 0 then cast(1 as bit)
        else cast(0 as bit)
    end as is_discounted
from {{ source('adventureworkslt', 'SalesOrderDetail') }}