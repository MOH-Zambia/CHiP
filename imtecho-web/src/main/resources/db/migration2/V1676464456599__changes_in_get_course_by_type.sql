DELETE FROM QUERY_MASTER WHERE CODE='get_course_by_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e98418aa-0a59-4a11-8de3-07674de0fa55', 97070,  current_date , 97070,  current_date , 'get_course_by_type',
'courseType,locationId,userId',
'select distinct cm.course_id, cm.course_name
from
    tr_training_course_rel tcr
inner join tr_training_org_unit_rel torg on
    tcr.training_id = torg.training_id
inner join tr_course_master cm on
    tcr.course_id = cm.course_id
where torg.org_unit_id in (
	    select
	        child_id
	    from
	        location_hierchy_closer_det
	    where
	        ((#locationId# is null
	        and parent_id in (
	        select
	            loc_id
	        from
	            um_user_location
	        where
	            user_id = #userId#
	            and state = ''ACTIVE''))
	    or #locationId# is not null
	    and parent_id = #locationId#)
	)
	and (case
		when #courseType# = ''ONLINE'' then cm.course_type = ''ONLINE''
		when #courseType# = ''OFFLINE'' then cm.course_type = ''OFFLINE''
		else true
	end)
	and cm.course_state = ''ACTIVE'';',
'Get active courses by course_type',
true, 'ACTIVE');