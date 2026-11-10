{% macro audit_columns() %}

cast(sysdatetime() as datetime2(0)) as modified_at,
'{{ invocation_id }}' as execution_id

{% endmacro %}