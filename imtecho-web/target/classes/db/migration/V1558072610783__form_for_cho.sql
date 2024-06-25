DELETE FROM query_master WHERE code='move_to_production_cho_form';
INSERT INTO query_master(created_by, created_on, code,params, query, returns_result_set, state)
values(1, current_date, 'move_to_production_cho_form', 'userId',
'
with temp_details as (
	select * from 
    dblink(''host=localhost user=postgres password=q1w2e3R$ dbname=techo'',''select distinct tcm.user_id,training_id,certification_on from tr_certificate_master tcm where user_id = #userId# and course_id in = 17 and grade_type = ''TRAINED'' '' )
    AS certification_on(user_id bigint,
    training_id bigint,
    certification_on timestamp without time zone )
)select cast(''CHO'' as text) as form_code, case when temp_details.certification_on is not null
then true 
else false end as result
from
(select #userId# as user_id) tmp left join
temp_details on temp_details.user_id = tmp.user_id;
', true, 'ACTIVE');

INSERT into listvalue_form_master 
VALUES ('CHO', 'CHO Role Form', true, true, 'move_to_production_cho_form');
