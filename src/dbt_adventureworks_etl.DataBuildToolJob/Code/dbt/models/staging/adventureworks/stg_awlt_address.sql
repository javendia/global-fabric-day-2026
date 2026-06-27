select
    AddressID as address_id,
    AddressLine1 as address_line_1,
    AddressLine2 as address_line_2,
    City as city,
    StateProvince as state_province,
    CountryRegion as country_region,
    PostalCode as postal_code
from {{ source('adventureworkslt', 'Address') }}