select
    ProductCategoryID as product_category_id,
    ParentProductCategoryID as parent_product_category_id,
    Name as product_category_name
from {{ source('adventureworkslt', 'ProductCategory') }}