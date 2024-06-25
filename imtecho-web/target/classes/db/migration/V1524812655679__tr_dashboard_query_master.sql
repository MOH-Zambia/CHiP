INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state)
VALUES (1027,localtimestamp,null,null,'training_dashboard_pending_list','userId',
'select course.course_id as id,course.course_name as "courseName",urm.name as role,urm.id as "roleId", 
                 case when practiced.practicing is null then 0 else practiced.practicing end, 
                 case when scheduled.scheduled  is null then 0 else scheduled.scheduled end, 
                 total.total,total.production, 
                 total.total- (case when practiced.practicing is null then 0 else practiced.practicing end)  
                 -( case when scheduled.scheduled  is null then 0 else scheduled.scheduled  end)  
                 as pending from 
                 (select tcm.course_id,tcm.course_name,tcrr.role_id from tr_course_master tcm left join tr_course_role_rel tcrr 
                 on tcm.course_id = tcrr.course_id) course 
                 left join 
                 (select count(*) as practicing,r1.course_id,r1.role_id from 
                 (select tcm.training_id,user_id,course_id,us.role_id from tr_certificate_master tcm 
                 inner join 
                 tr_training_master tm on tcm.training_id = tm.training_id 
                 inner join 
                 um_user us on us.id = tcm.user_id 
                 inner join 
                 tr_training_org_unit_rel tour on tour.training_id = tm.training_id where 
                 tour.org_unit_id in (select child_id 
                 from location_hierchy_closer_det where parent_id in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'')) 
                 and tm.training_state = ''SUBMITTED'') r1 
                 group by r1.role_id,r1.course_id) practiced 
                 on course.course_id = practiced.course_id and course.role_id = practiced.role_id 
                 left join 
                 (select count(*) as scheduled,tcr.course_id,tarr.target_role_id from tr_training_master tr inner join tr_training_course_rel tcr on tr.training_id = tcr.training_id 
                 inner join tr_training_target_role_rel tarr on tarr.training_id = tr.training_id 
                 inner join tr_training_org_unit_rel trl on tr.training_id = trl.training_id 
                 left join (select * from tr_training_attendee_rel  union select * from tr_training_additional_attendee_rel) r2 
                 on tr.training_id = r2.training_id 
                 where (trl.org_unit_id in (select child_id 
                 from location_hierchy_closer_det where parent_id in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'')) 
                 or trl.org_unit_id in (select parent_id 
                 from location_hierchy_closer_det where child_id in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))) 
                 and (tr.effective_date > current_date or tr.effective_date = current_date) and tr.training_state = ''DRAFT'' 
                 group by tcr.course_id,tarr.target_role_id) scheduled 
                 on course.course_id = scheduled.course_id and  course.role_id = scheduled.target_role_id 
                 left join 
                 (select r.course_id,r.role_id, 
                 case when r1.total is null then 0 else r1.total end as total, 
                 case when r1.production is null then 0 else r1.production end as production from 
                 (select tcm.course_id,tcr.role_id from tr_course_master tcm  
                 left join tr_course_role_rel tcr on tcm.course_id = tcr.course_id group by tcm.course_id,tcr.role_id) r 
                 left join  
                 (select role_id,count(*) as total,sum(case when server_type = ''P'' then 1 else 0 end) as production  from ( 
                 select distinct um_user.id,um_user.role_id,um_user.server_type from um_user,um_user_location,location_hierchy_closer_det 
                 where location_hierchy_closer_det.parent_id in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') 
                 and location_hierchy_closer_det.child_id = um_user_location.loc_id 
                 and um_user_location.state = ''ACTIVE'' 
                 and  um_user_location.user_id = um_user.id and um_user.state = ''ACTIVE'' 
                 ) as t 
                 group by role_id) r1 
                 on r.role_id = r1.role_id group by r.course_id,r1.total,r1.production,r.role_id) total 
                 on course.course_id = total.course_id and  course.role_id = total.role_id 
                 left join 
                 (select id,name from um_role_master) urm on urm.id = course.role_id',true,'ACTIVE');
