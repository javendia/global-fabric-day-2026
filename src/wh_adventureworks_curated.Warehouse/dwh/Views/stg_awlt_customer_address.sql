-- Auto Generated (Do not modify) CD7F198CDCDFD4C717352FF4A961CB3EA342768FFAA12364A58F1AF28C2F0499
create view "dwh"."stg_awlt_customer_address" as with source as (

    select
        CustomerID
        ,AddressID
        ,AddressType
    from "lh_adventureworks_raw"."SalesLT"."CustomerAddress"

),

renamed as (

    select
        CustomerID as customer_id,
        AddressID as address_id,
        AddressType as address_type
    from source

)

select *
from renamed;