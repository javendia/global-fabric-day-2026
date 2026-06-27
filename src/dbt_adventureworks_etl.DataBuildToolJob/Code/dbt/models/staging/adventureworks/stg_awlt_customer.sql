select
    CustomerID as customer_id,
    Title as title,
    FirstName as first_name,
    MiddleName as middle_name,
    LastName as last_name,
    Suffix as suffix,
    nullif(ltrim(rtrim(concat(
        coalesce(FirstName, ''),
        case when MiddleName is null then '' else concat(' ', MiddleName) end,
        case when LastName is null then '' else concat(' ', LastName) end
    ))), '') as customer_full_name,
    CompanyName as company_name,
    SalesPerson as sales_person,
    lower(cast(EmailAddress as varchar(200))) as email_address,
    Phone as phone
from {{ source('adventureworkslt', 'Customer') }}