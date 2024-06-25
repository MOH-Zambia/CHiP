delete from query_master where code = 'team_all_types_for_roles';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'team_all_types_for_roles',
 NULL, 'select id ,type from team_type_master where state =''ACTIVE'';', true, 'ACTIVE', NULL);
