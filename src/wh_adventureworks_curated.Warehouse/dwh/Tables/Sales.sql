CREATE TABLE [dwh].[Sales] (
    [sales_key]           INT             NULL,
    [sales_order_id]      INT             NULL,
    [sales_order_number]  VARCHAR (8000)  NULL,
    [customer_key]        INT             NULL,
    [product_key]         INT             NULL,
    [order_date]          DATE            NULL,
    [ship_date]           DATE            NULL,
    [status]              SMALLINT        NULL,
    [status_name]         VARCHAR (11)    NOT NULL,
    [online_order_flag]   BIT             NULL,
    [ship_method]         VARCHAR (8000)  NULL,
    [order_quantity]      SMALLINT        NULL,
    [unit_price]          DECIMAL (18, 4) NULL,
    [unit_price_discount] DECIMAL (18, 4) NULL,
    [line_total]          DECIMAL (18, 4) NULL,
    [gross_amount]        DECIMAL (18, 4) NULL,
    [discount_amount]     DECIMAL (18, 4) NULL,
    [is_discounted]       BIT             NULL,
    [modified_at]         DATETIME2 (0)   NULL,
    [execution_id]        VARCHAR (36)    NOT NULL
);


GO