select
    ProductModelID as product_model_id,
    Name as product_model_name
from {{ source('adventureworkslt', 'ProductModel') }}