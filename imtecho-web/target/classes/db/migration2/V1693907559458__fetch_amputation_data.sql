DELETE FROM QUERY_MASTER WHERE CODE='fetch_amputation_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7c543191-a7bc-4d9f-8c28-4c915e251f70', 97070,  current_date , 97070,  current_date , 'fetch_amputation_data',
'member_id',
'select
	case when
		ngs.foot_problem_history = ''true''
	then
		''Yes''
	else
		''No''
	end as "isAmputation"
from
	ncd_general_screening ngs
where
	ngs.member_id = cast(#member_id# as integer)',
null,
true, 'ACTIVE');