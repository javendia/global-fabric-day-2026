select customer_id
from {{ ref('dim_customer') }}
where email not like '%@adventure-works.com'