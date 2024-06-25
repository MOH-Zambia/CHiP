DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_tables';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd7bf94cf-794d-4fe4-af50-10adc3bd58d0', 849483,  current_date , 849483,  current_date , 'retrieve_all_tables',
 null,
'select
    relname as tablename,
    pg_size_pretty(pg_total_relation_size(oid)) as size_pretty
from pg_class
where relkind in (''r'',''p'')
and relispartition = false
and relnamespace = (select oid from pg_namespace where nspname = ''public'')
order by relname asc;',
'Retrieves metadata of tables for Query Builder',
true, 'ACTIVE');