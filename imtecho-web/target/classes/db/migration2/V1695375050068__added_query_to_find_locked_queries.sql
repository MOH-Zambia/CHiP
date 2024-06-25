DELETE FROM QUERY_MASTER WHERE CODE='retrieve_locked_queries';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0925594e-189f-4dba-a3c8-b57931c447f6', 97632,  current_date , 97632,  current_date , 'retrieve_locked_queries',
 null,
'select cast(pid as text) as pid, cast(usename as text) as usename, cast(pg_blocking_pids(pid) as text) as blocked_by, cast(query as text) as blocked_query from pg_stat_activity where cardinality(pg_blocking_pids(pid)) > 0;',
'Retrieves the locked queries in the database.',
true, 'ACTIVE');