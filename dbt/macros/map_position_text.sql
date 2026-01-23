{% macro standardize_position_text(column_name) %}
    CASE 
        WHEN {{ column_name }} = '\N' THEN NULL 
        WHEN {{ column_name }} = 'R' THEN 'Retired'
        WHEN {{ column_name }} = 'D' THEN 'Disqualified'
        WHEN {{ column_name }} = 'W' THEN 'Withdrew'
        WHEN {{ column_name }} = 'N' THEN 'Not classified'
        WHEN {{ column_name }} = 'F' THEN 'Failed to qualify'
        WHEN {{ column_name }} = 'E' THEN 'Excluded'
        ELSE {{ column_name }} 
    END
{% endmacro %}