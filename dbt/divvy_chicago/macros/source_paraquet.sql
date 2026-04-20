{% macro source_parquet(path) %}
    read_parquet('{{ path }}')
{% endmacro %}