CREATE TABLE [log].[test_execution_history] (

	[execution_datetime] datetime2(0) NULL, 
	[invocation_id] varchar(100) NULL, 
	[test_name] varchar(500) NULL, 
	[test_type] varchar(100) NULL, 
	[entity] varchar(500) NULL, 
	[column_name] varchar(500) NULL, 
	[status] varchar(50) NULL
);