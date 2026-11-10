select
    SalesOrderID as sales_order_id,
    CustomerID as customer_id,
    SalesOrderNumber as sales_order_number,
    PurchaseOrderNumber as purchase_order_number,
    AccountNumber as account_number,
    cast(OrderDate as date) as order_date,
    cast(DueDate as date) as due_date,
    cast(ShipDate as date) as ship_date,
    Status as status,
    case
        when Status = 1 then 'in_process'
        when Status = 2 then 'approved'
        when Status = 3 then 'backordered'
        when Status = 4 then 'rejected'
        when Status = 5 then 'shipped'
        when Status = 6 then 'cancelled'
        else 'unknown'
    end as status_name,
    OnlineOrderFlag as online_order_flag,
    ShipMethod as ship_method,
    cast(SubTotal as decimal(18, 4)) as subtotal,
    cast(TaxAmt as decimal(18, 4)) as tax_amount,
    cast(Freight as decimal(18, 4)) as freight_amount,
    cast(TotalDue as decimal(18, 4)) as total_due
from {{ source('adventureworkslt', 'SalesOrderHeader') }}