DELETE FROM QUERY_MASTER WHERE CODE='fetch_stroke_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61385a3c-7418-4c54-9f1b-ac33bf657529', 97070,  current_date , 97070,  current_date , 'fetch_stroke_data',
'member_id',
'select
	case when
		nmiad.history_disease ilike ''%stroke%''
	then
		''Yes''
	else
		''No''
	end as "isStrokePresent",
	case when
		ngs.stroke_history = ''true''
	then
		''Yes''
	else
		''No''
	end as "researcherRoleInput"
from
	ncd_member_initial_assessment_detail nmiad
join
	ncd_general_screening ngs
on
	nmiad.member_id = ngs.member_id
where
	nmiad.member_id  = cast(#member_id# as integer)',
null,
true, 'ACTIVE');