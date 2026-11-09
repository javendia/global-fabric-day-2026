CREATE TABLE [dwh].[Product] (
    [product_key]                  INT             NULL,
    [product_id]                   INT             NULL,
    [product_name]                 VARCHAR (8000)  NULL,
    [product_number]               VARCHAR (400)   NULL,
    [color]                        VARCHAR (8000)  NULL,
    [size]                         VARCHAR (8000)  NULL,
    [standard_cost]                DECIMAL (18, 4) NULL,
    [list_price]                   DECIMAL (18, 4) NULL,
    [is_current_product]           BIT             NULL,
    [product_category_name]        VARCHAR (8000)  NULL,
    [parent_product_category_name] VARCHAR (8000)  NULL,
    [product_model_name]           VARCHAR (8000)  NULL,
    [modified_at]                  DATETIME2 (0)   NULL,
    [execution_id]                 VARCHAR (36)    NOT NULL
);


GO