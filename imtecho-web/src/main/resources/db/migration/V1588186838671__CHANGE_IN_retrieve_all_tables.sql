DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_tables';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
1027,  current_date , 1027,  current_date , 'retrieve_all_tables', 
 null, 
'select iss.schemaname,iss.tablename,
 pg_size_pretty(pg_relation_size(''"'' || iss.schemaname || ''"."'' || iss.tablename || ''"'')) as "size_pretty",
 pg_relation_size(''"'' || iss.schemaname || ''"."'' || iss.tablename || ''"'') as "size"
 from pg_catalog.pg_tables iss where iss.schemaname != ''pg_catalog'' AND iss.schemaname != ''information_schema'' order by iss.tablename;', 
'Fire postgres query to get all the tables from database', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_limited_query_history';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
1027,  current_date , 1027,  current_date , 'retrieve_limited_query_history', 
'limit,searchKey,userId', 
'SELECT * from query_history where user_id = ''#userId#'' AND  ( ''#searchKey#'' = ''null'' OR query ILIKE ''%#searchKey#%'' ) order by id desc limit ''#limit#''', 
'Fire postgres query to get limited records from query_history table for given user', 
true, 'ACTIVE');
