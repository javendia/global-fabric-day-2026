CREATE TABLE [dwh].[Product] (

	[product_key] int NULL, 
	[product_id] int NULL, 
	[product_name] varchar(8000) NULL, 
	[product_number] varchar(400) NULL, 
	[color] varchar(8000) NULL, 
	[size] varchar(8000) NULL, 
	[standard_cost] decimal(18,4) NULL, 
	[list_price] decimal(18,4) NULL, 
	[is_current_product] bit NULL, 
	[product_category_name] varchar(8000) NULL, 
	[parent_product_category_name] varchar(8000) NULL, 
	[product_model_name] varchar(8000) NULL, 
	[modified_at] datetime2(0) NULL, 
	[execution_id] varchar(36) NOT NULL
);