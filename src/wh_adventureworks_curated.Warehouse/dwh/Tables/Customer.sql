CREATE TABLE [dwh].[Customer] (
    [customer_key]   INT            NULL,
    [customer_id]    INT            NULL,
    [customer_name]  VARCHAR (8000) NULL,
    [company_name]   VARCHAR (8000) NULL,
    [sales_person]   VARCHAR (8000) NULL,
    [email_address]  VARCHAR (1600) NULL,
    [phone]          VARCHAR (8000) NULL,
    [city]           VARCHAR (8000) NULL,
    [state_province] VARCHAR (8000) NULL,
    [country_region] VARCHAR (8000) NULL,
    [postal_code]    VARCHAR (8000) NULL,
    [modified_at]    DATETIME2 (0)  NULL,
    [execution_id]   VARCHAR (36)   NOT NULL
);


GO