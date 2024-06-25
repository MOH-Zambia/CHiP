update query_master 
set query = 'select * from 
(select us.id,concat(us.first_name,'' '',us.last_name) as name,string_agg(lm.name,'','') as location,cast(''pending'' as varchar(30)) as type
from um_user us,um_user_location ul,location_master lm
where  lm.id = ul.loc_id and us.id = ul.user_id
and us.role_id in (#roleId#)
and ul.loc_id in (select child_id from location_hierchy_closer_det where parent_id in (#locationId#))
and us.id not in (select user_id from tr_certificate_master where course_id = #courseId# and certificate_type = ''COURSECOMPLETION'')
and us.id not in (
select distinct(tam.user_id) from  tr_attendance_master tam inner join tr_training_master tm using (training_id)
inner join um_user us on us.id = tam.user_id inner join tr_training_course_rel tcr on tm.training_id = tcr.training_id
inner join um_user_location ul on us.id = ul.user_id 
where (tm.expiration_date >= current_date or tm.training_state = ''DRAFT'') and tcr.course_id = #courseId#  and us.role_id = #roleId#
)
and ul.state = ''ACTIVE'' and us.state = ''ACTIVE''
group by us.id) r1
union
(select us.id,concat(us.first_name,'' '',us.last_name) as name,string_agg(lm.name,'','') as location,cast(''completed'' as varchar(30)) as type
from um_user us,um_user_location ul,location_master lm
where  lm.id = ul.loc_id and us.id = ul.user_id
and us.role_id in (#roleId#)
and ul.loc_id in (select child_id from location_hierchy_closer_det where parent_id in (#locationId#))
and us.id in (select user_id from tr_certificate_master where course_id = #courseId# and certificate_type = ''COURSECOMPLETION'')
and ul.state = ''ACTIVE'' and us.state = ''ACTIVE''
group by us.id)' 
where code = 'training_eligible_count'