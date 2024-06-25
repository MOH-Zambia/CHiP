update query_master 
set query = 'select course.course_id as id,course.course_name as "courseName",urm.name as role,urm.id as "roleId", 
                 case when practiced.practicing is null then 0 else practiced.practicing end,
                 case when scheduled.scheduled  is null then 0 else scheduled.scheduled end, 
                 total.total,total.production, 
                 case when pending.pending is null then 0 else pending. pending end from 
                 (select tcm.course_id,tcm.course_name,tcrr.role_id from tr_course_master tcm left join tr_course_role_rel tcrr 
                 on tcm.course_id = tcrr.course_id) course 
                 left join 
                  (select count(distinct r1.user_id) as practicing,r1.course_id,r1.role_id from 
                 (select tcm.training_id,tcm.user_id,course_id,us.role_id from tr_certificate_master tcm 
                 inner join 
                 tr_training_master tm on tcm.training_id = tm.training_id 
                 inner join 
                 um_user us on us.id = tcm.user_id 
		         inner join um_user_location ul on ul.user_id = us.id
                 inner join 
                 tr_training_org_unit_rel tour on tour.training_id = tm.training_id
                 left join user_form_access ufa on ufa.user_id = us.id
                 where ufa.user_id is null and
                 tour.org_unit_id in (select child_id 
                 from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end)) 
                 and tm.training_state = ''SUBMITTED'' and us.state = ''ACTIVE'' and
		        ul.loc_id in (select child_id 
                 from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end))
		 ) r1 
                 group by r1.role_id,r1.course_id) practiced 
                 on course.course_id = practiced.course_id and course.role_id = practiced.role_id 
                 left join 
               (select count(distinct ul.user_id) as scheduled,tcr.course_id,usr.role_id from tr_training_master tr inner join tr_training_course_rel tcr on tr.training_id = tcr.training_id 
                 inner join tr_training_target_role_rel tarr on tarr.training_id = tr.training_id 
                 inner join tr_training_org_unit_rel trl on tr.training_id = trl.training_id 
                 left join (select * from tr_training_attendee_rel  union select * from tr_training_additional_attendee_rel) r2 
                 on tr.training_id = r2.training_id 
	         inner join um_user usr on usr.id = r2.attendee_id
	         inner join um_user_location ul on usr.id = ul.user_id
                 where (tr.expiration_date >= current_date) and tr.training_state = ''DRAFT''
		 and usr.state = ''ACTIVE'' and ul.loc_id in (select child_id 
                 from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end)
                 )
                 group by tcr.course_id,usr.role_id)  scheduled 
                 on course.course_id = scheduled.course_id and  course.role_id = scheduled.role_id 
                 left join 
                 (select r.course_id,r.role_id, 
                 case when r1.total is null then 0 else r1.total end as total, 
                 case when r1.production is null then 0 else r1.production end as production from 
                 (select tcm.course_id,tcr.role_id from tr_course_master tcm  
                 left join tr_course_role_rel tcr on tcm.course_id = tcr.course_id group by tcm.course_id,tcr.role_id) r 
                 left join  
                 (select role_id,count(*) as total,sum(case when t.state = ''MOVE_TO_PRODUCTION'' then 1 else 0 end) as production  from ( 
                 select distinct us.id,us.role_id,ufa.state
	         from um_user us inner join um_user_location ul on us.id = ul.user_id
                 inner join location_hierchy_closer_det lhcd on lhcd.child_id = ul.loc_id 
		 left join user_form_access ufa on ufa.user_id = us.id
                 where lhcd.parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end) 
                 and ul.state = ''ACTIVE'' 
                 and us.state = ''ACTIVE'' 
                 ) as t 
                 group by role_id) r1 
                 on r.role_id = r1.role_id group by r.course_id,r1.total,r1.production,r.role_id) total 
                 on course.course_id = total.course_id and  course.role_id = total.role_id
	         left join 
	 	 (select count(distinct usr.id) as pending,usr.role_id,tcrr.course_id
from um_user usr 
inner join tr_course_role_rel tcrr on tcrr.role_id = usr.role_id
left join 
(select * from
(select distinct(crt.user_id),crt.course_id from tr_certificate_master crt inner join um_user us  
on crt.user_id = us.id inner join um_user_location ul on ul.user_id = us.id
where ul.loc_id in 
(select child_id from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end))
union
select distinct(attendee_id),tcr.course_id from 
(select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel) res
inner join tr_training_master tm on res.training_id = tm.training_id inner join tr_training_course_rel tcr on tm.training_id = tcr.training_id
inner join um_user us on us.id = res.attendee_id inner join um_user_location ul on us.id = ul.user_id  
where ul.loc_id in 
(select child_id from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end))
and tm.training_state = ''DRAFT'' and tm.expiration_date >= current_date) t1) res
on usr.id = res.user_id and tcrr.course_id = res.course_id
inner join um_user_location ul on usr.id = ul.user_id 
where ul.loc_id in (select child_id from location_hierchy_closer_det where parent_id in (case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end))
and res.user_id is null and usr.state = ''ACTIVE''
group by usr.role_id,tcrr.course_id) pending on pending.course_id = course.course_id and course.role_id = pending.role_id
                 left join
                 (select id,name from um_role_master) urm on urm.id = course.role_id'
where code = 'training_dashboard_pending_list';


INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
    VALUES (-1,localtimestamp,null,null,'tr_scheduled_trainings','userId,locationId,moduleId,courseId,isShowPast',
 'select string_agg(r1."location",'','') as "location",r1."trainingId",r1."trainerId",r1."courseName",r1."trainer",r1."effectiveDate",r1."expirationDate",r1."module",
r1."total",r1."trainingState",r1."completed",r1."pending" from 
(select string_agg(lm.name,''>'' order by lhcd.depth desc) as "location",res.training_id "trainingId",res.primary_trainer_id "trainerId"
,res.course_name as "courseName",concat(us.first_name,'' '',us.last_name) as "trainer",fvm.field_value as "module",total.total as "total",
res.effective_date as "effectiveDate",res.expiration_date as "expirationDate",res.training_state as "trainingState",cert."completed",
tcm.state as "pending"
from 
(select tm.training_id,ptr.primary_trainer_id,cm.course_id,cm.course_name,cm.module_id,torg.org_unit_id,
tm.effective_date,tm.expiration_date,tm.training_state
from 
tr_training_master tm inner join tr_training_course_rel tcr on tm.training_id = tcr.training_id
inner join tr_training_org_unit_rel torg on tm.training_id = torg.training_id 
inner join tr_training_primary_trainer_rel ptr on ptr.training_id = tm.training_id
inner join tr_course_master cm on tcr.course_id = cm.course_id
where torg.org_unit_id in (select child_id from location_hierchy_closer_det where parent_id in  
(case when #locationId# is null then (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'') else #locationId# end))
and (case when #moduleId# is not null then cm.module_id = #moduleId# else true end)
and (case when #courseId# is not null then tcr.course_id =  #courseId# else true end)
and (case when #isShowPast# = true then true else tm.expiration_date\:\:date >= current_date end)) res
inner join 
(select count(*) as "total",training_id from 
(select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel)r group by r.training_id) total
on res.training_id = total.training_id
left join (select * from 
(select max(topic_id) over (partition by training_id) as max_topic,topic_id,training_id,state,expiration_date from tr_topic_coverage_master
) t
where topic_id = t.max_topic) tcm 
on res.training_id = tcm.training_id and res.expiration_date\:\:date = tcm.expiration_date\:\:date
left join 
(select count(*) as "completed",training_id from tr_certificate_master
where certificate_type = ''COURSECOMPLETION''
group by training_id) cert
on res.training_id= cert.training_id
inner join location_hierchy_closer_det lhcd on lhcd.child_id = res.org_unit_id
inner join location_master lm on lm.id = lhcd.parent_id
inner join um_user us on us.id = res.primary_trainer_id
left join field_value_master fvm on fvm.id = res.module_id
group by res.training_id,res.primary_trainer_id,res.course_name,us.first_name,us.last_name,fvm.field_value,res.effective_date,
res.expiration_date,total.total,res.training_state,cert."completed",tcm.state,res.org_unit_id) r1
group by r1."trainingId",r1."trainerId",r1."courseName",r1."trainer",r1."effectiveDate",r1."expirationDate",r1."module",
r1."total",r1."trainingState",r1."completed",r1."pending"',true,'ACTIVE',null);