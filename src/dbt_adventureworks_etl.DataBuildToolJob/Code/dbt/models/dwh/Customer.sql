select
    customer.customer_id as customer_key,
    customer.customer_id,
    customer.customer_full_name as customer_name,
    customer.company_name,
    customer.sales_person,
    customer.email_address,
    customer.phone,
    address.city,
    address.state_province,
    address.country_region,
    address.postal_code,
    {{ audit_columns() }}
from {{ ref('stg_awlt_customer') }} as customer
left join {{ ref('stg_awlt_customer_address') }} as customer_address
    on customer.customer_id = customer_address.customer_id
    and customer_address.address_type = 'Main Office'
left join {{ ref('stg_awlt_address') }} as address
    on customer_address.address_id = address.address_id