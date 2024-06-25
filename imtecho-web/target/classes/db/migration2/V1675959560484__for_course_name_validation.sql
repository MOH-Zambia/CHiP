DELETE FROM QUERY_MASTER WHERE CODE='verify_course_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f3fe124f-638f-435a-96ad-8e19ee836b16', 97070,  current_date , 97070,  current_date , 'verify_course_name',
'courseName,courseId',
'select course_id from tr_course_master
where course_name = #courseName#
and case
		when #courseId# is not null
		then course_id != #courseId#
		else true
	end',
'To validate duplicate course name',
true, 'ACTIVE');