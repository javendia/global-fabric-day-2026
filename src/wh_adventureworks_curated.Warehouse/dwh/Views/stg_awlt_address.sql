-- Auto Generated (Do not modify) 2A47ABEE45CA603132FF811932900A007782E387E8DA43E11DCE6A023443BBED
create view "dwh"."stg_awlt_address" as with source as (

    select
        AddressID
        ,AddressLine1
        ,AddressLine2
        ,City
        ,StateProvince
        ,CountryRegion
        ,PostalCode
    from "lh_adventureworks_raw"."SalesLT"."Address"

),

renamed as (

    select
        AddressID as address_id,
        AddressLine1 as address_line_1,
        AddressLine2 as address_line_2,
        City as city,
        StateProvince as state_province,
        CountryRegion as country_region,
        PostalCode as postal_code
    from source

)

select *
from renamed;