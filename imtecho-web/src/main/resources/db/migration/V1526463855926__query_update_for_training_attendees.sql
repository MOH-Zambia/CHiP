update query_master  
set query = 'select * from 
(select us.id,concat(us.first_name,'' '',us.last_name) as name,string_agg(lm.name,'','') as location,cast(''pending'' as varchar(30)) as type
from um_user us,um_user_location ul,location_master lm
where  lm.id = ul.loc_id and us.id = ul.user_id
and us.role_id in (#roleId#)
and ul.loc_id in (select child_id from location_hierchy_closer_det where parent_id in (#locationId#))
and us.id not in (select user_id from tr_certificate_master where course_id = #courseId# and certificate_type = ''COURSECOMPLETION'')
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
group by us.id) ' where code = 'training_eligible_count';