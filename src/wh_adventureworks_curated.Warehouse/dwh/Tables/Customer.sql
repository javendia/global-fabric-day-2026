CREATE TABLE [dwh].[Customer] (

	[customer_key] int NULL, 
	[customer_id] int NULL, 
	[customer_name] varchar(8000) NULL, 
	[company_name] varchar(8000) NULL, 
	[sales_person] varchar(8000) NULL, 
	[email_address] varchar(1600) NULL, 
	[phone] varchar(8000) NULL, 
	[city] varchar(8000) NULL, 
	[state_province] varchar(8000) NULL, 
	[country_region] varchar(8000) NULL, 
	[postal_code] varchar(8000) NULL, 
	[modified_at] datetime2(0) NULL, 
	[execution_id] varchar(36) NOT NULL
);