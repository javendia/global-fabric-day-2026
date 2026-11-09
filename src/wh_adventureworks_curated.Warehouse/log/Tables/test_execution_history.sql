CREATE TABLE [log].[test_execution_history] (
    [execution_datetime] DATETIME2 (0) NULL,
    [invocation_id]      VARCHAR (100) NULL,
    [test_name]          VARCHAR (500) NULL,
    [test_type]          VARCHAR (100) NULL,
    [entity]             VARCHAR (500) NULL,
    [column_name]        VARCHAR (500) NULL,
    [status]             VARCHAR (50)  NULL
);


GO