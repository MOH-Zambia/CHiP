DELETE FROM QUERY_MASTER WHERE CODE='get_last_n_financial_year_range';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c04a9e6a-1c78-4af4-89d8-4f4533871792', 60512,  current_date , 60512,  current_date , 'get_last_n_financial_year_range',
'count',
'select concat(extract(year from curr), ''-'', extract(year from curr) + 1) as year
from generate_series(current_date - cast(concat(#count#,''year'') as interval), current_date, ''1 year'') as curr order by year desc;',
'To get financial last #count# financial year and current one',
true, 'ACTIVE');