{% macro save_test_results(results) %}

    {% for result in results %}

        {% if result.node.resource_type == 'test' %}

            {% set sql %}
                insert into [log].test_execution_history
                (
                    execution_datetime,
                    invocation_id,
                    test_name,
                    test_type,
                    entity,
                    column_name,
                    status
                )
                values
                (
                    current_timestamp,
                    '{{ invocation_id }}',
                    '{{ result.node.name }}',
                    '{{ result.node.test_metadata.name }}',
                    '{{ result.node.depends_on.nodes[0].split(".")[-1] }}',
                    '{{ result.node.test_metadata.kwargs.get("column_name", "") }}',
                    '{{ result.status }}'
                )
            {% endset %}

            {% do run_query(sql) %}

        {% endif %}

    {% endfor %}

{% endmacro %}