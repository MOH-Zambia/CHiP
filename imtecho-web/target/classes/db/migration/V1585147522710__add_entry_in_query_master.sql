INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params, query,description, returns_result_set, state)
    VALUES (1027,localtimestamp,null,null,'retrieve_all_tables',null,
    'select * from pg_catalog.pg_tables where schemaname != ''pg_catalog'' AND schemaname != ''information_schema'' order by tablename',
    'Fire postgres query to get all the tables from database',
    true,'ACTIVE');


INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params, query,description, returns_result_set, state)
    VALUES (1027,localtimestamp,null,null,'retrieve_limited_query_history','userId,limit',
    'SELECT * from query_history where user_id = ''#userId#'' order by id desc limit ''#limit#''  ',
    'Fire postgres query to get limited records from query_history table for given user',
    true,'ACTIVE');