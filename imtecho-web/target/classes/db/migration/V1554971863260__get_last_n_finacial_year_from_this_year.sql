delete from query_master where code='get_last_n_financial_year_range';

INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'get_last_n_financial_year_range','count',
'select concat(extract(year from curr), ''-'', extract(year from curr) + 1) as year 
from generate_series(current_date - interval ''#count# year'', current_date, ''1 year'') as curr order by year desc;'
,true,'ACTIVE','To get financial last #count# financial year and current one');