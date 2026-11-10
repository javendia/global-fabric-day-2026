select
    CustomerID as customer_id,
    AddressID as address_id,
    AddressType as address_type
from {{ source('adventureworkslt', 'CustomerAddress') }}