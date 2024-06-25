--new column: 'size' in tr_topic_media_master
alter table tr_topic_media_master
add column if not exists size bigint;




--get_course_media_size_by_id
DELETE FROM QUERY_MASTER WHERE CODE='get_course_media_size_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0c24b46c-2f64-4dcd-8b35-97522e2fdac5', 97070,  current_date , 97070,  current_date , 'get_course_media_size_by_id',
'courseId',
'select sum(tm.size) as "size"
from tr_topic_media_master tm
inner join tr_course_topic_rel rel on rel.topic_id = tm.topic_id
inner join tr_course_master course on rel.course_id = course.course_id
where course.course_id = #courseId#',
'Returns total media size of course in bytes',
true, 'ACTIVE');