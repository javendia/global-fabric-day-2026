select
    ProductID as product_id,
    Name as product_name,
    upper(nullif(ltrim(rtrim(cast(ProductNumber as varchar(50)))), '')) as product_number,
    Color as color,
    cast(StandardCost as decimal(18, 4)) as standard_cost,
    cast(ListPrice as decimal(18, 4)) as list_price,
    Size as size,
    cast(Weight as decimal(18, 4)) as weight,
    ProductCategoryID as product_category_id,
    ProductModelID as product_model_id,
    cast(SellStartDate as date) as sell_start_date,
    cast(SellEndDate as date) as sell_end_date,
    cast(DiscontinuedDate as date) as discontinued_date,
    case
        when SellEndDate is null and DiscontinuedDate is null then cast(1 as bit)
        else cast(0 as bit)
    end as is_current_product
from {{ source('adventureworkslt', 'Product') }}