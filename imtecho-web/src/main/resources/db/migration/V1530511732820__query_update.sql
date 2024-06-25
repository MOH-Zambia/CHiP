update query_master
set query = 'select string_agg(r1."location",'','') as "location",r1."trainingId",r1."trainerId",r1."courseName",r1."trainer",r1."effectiveDate",r1."expirationDate",r1."module",
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
on res.training_id = tcm.training_id 
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
r1."total",r1."trainingState",r1."completed",r1."pending"'
where code = 'tr_scheduled_trainings';    