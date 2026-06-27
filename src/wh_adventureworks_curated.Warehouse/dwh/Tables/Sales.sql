CREATE TABLE [dwh].[Sales] (

	[sales_key] int NULL, 
	[sales_order_id] int NULL, 
	[sales_order_number] varchar(8000) NULL, 
	[customer_key] int NULL, 
	[product_key] int NULL, 
	[order_date] date NULL, 
	[ship_date] date NULL, 
	[status] smallint NULL, 
	[status_name] varchar(11) NOT NULL, 
	[online_order_flag] bit NULL, 
	[ship_method] varchar(8000) NULL, 
	[order_quantity] smallint NULL, 
	[unit_price] decimal(18,4) NULL, 
	[unit_price_discount] decimal(18,4) NULL, 
	[line_total] decimal(18,4) NULL, 
	[gross_amount] decimal(18,4) NULL, 
	[discount_amount] decimal(18,4) NULL, 
	[is_discounted] bit NULL, 
	[modified_at] datetime2(0) NULL, 
	[execution_id] varchar(36) NOT NULL
);