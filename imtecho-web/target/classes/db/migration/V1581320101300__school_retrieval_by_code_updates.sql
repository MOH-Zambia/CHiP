-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3129

delete from query_master where code='school_retrieval_by_code';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'school_retrieval_by_code', 'id,code','
    SELECT
    id,
    name,
    english_name as "englishName",
    code,
	location_id as "locationId",
	get_location_hierarchy(location_id) as "locationHierarchy"
    FROM public.school_master
    WHERE
    code = ''#code#''
    and id != #id#;
', true, 'ACTIVE', 'Retrieve School By Code');
