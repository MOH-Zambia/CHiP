update query_master 
set query = 'select tcm1.course_name "course1",concat(us.first_name,'' '',us.last_name) as "trainer1",lm.name as "ou1",
res."trainingId",res."effectiveDate",res."expirationDate",res."pending",res."totalNoOfAttendees",res."completedCount",
res."trainingState",res."attendeeCount" from
(select distinct on (tcm.training_id) tm.training_id as "trainingId",
case when tm.location_name is null then ''N/A'' else tm.location_name end as "location",tm.effective_date as "effectiveDate",
tm.expiration_date as "expirationDate",
tcm.state as "pending",r1."totalNoOfAttendees",
case when cert."completedCount" is null then 0 else cert."completedCount" end,tm.training_state as "trainingState",count(*) as "attendeeCount"
from tr_training_master tm  inner join tr_training_primary_trainer_rel pt using (training_id)
inner join 
(select count(*) as "totalNoOfAttendees",training_id from 
(select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel)r group by r.training_id) r1
on r1.training_id = tm.training_id
left join 
(select count(*) as "completedCount",training_id from tr_certificate_master
where certificate_type = ''COURSECOMPLETION''
group by training_id) cert
on tm.training_id= cert.training_id
inner join (select max(topic_id),expiration_date,training_id,state from tr_topic_coverage_master
group by training_id,expiration_date,state ) tcm 
on tm.training_id = tcm.training_id and tm.expiration_date\:\:date = tcm.expiration_date\:\:date
inner join 
(select count(distinct effective_date) as days,training_id from tr_topic_coverage_master 
group by training_id) days on tm.training_id = days.training_id
inner join 
(select count(*),training_id from tr_attendance_master where  is_present = true
group by training_id,user_id) fully on fully.count = days.days and fully.training_id = days.training_id
where ((tm.expiration_date\:\:date < current_date or (tm.expiration_date\:\:date = current_date and tm.training_state = ''SUBMITTED'')) and
((tcm.state = ''SUBMITTED'') or (tcm.state = ''PENDING'' and tcm.expiration_date\:\:date + interval ''3 days'' >= current_date))
)
and pt.primary_trainer_id = #userId#
group by fully.training_id,tm.training_id,tcm.state,r1."totalNoOfAttendees",
cert."completedCount",tcm.training_id) res
inner join tr_training_course_rel tcr on tcr.training_id = res."trainingId"
inner join tr_course_master tcm1 on tcr.course_id = tcm1.course_id
inner join tr_training_primary_trainer_rel ptr on ptr.training_id = res."trainingId"
inner join um_user us on us.id = ptr.primary_trainer_id
inner join tr_training_org_unit_rel torg on torg.training_id = res."trainingId"
inner join location_master lm on lm.id = torg.org_unit_id' 
where code = 'training_dashboard_pending_list';

update query_master
set query = 'select tcm1.course_name "course1",concat(us.first_name,'' '',us.last_name) as "trainer1",lm.name as "ou1",
res."trainingId",res."effectiveDate",res."expirationDate",res."pending",res."totalNoOfAttendees",res."completedCount",
res."trainingState",res."attendeeCount" from
(select distinct on (tcm.training_id) tm.training_id as "trainingId",
case when tm.location_name is null then ''N/A'' else tm.location_name end as "location",tm.effective_date as "effectiveDate",
tm.expiration_date as "expirationDate",
tcm.state as "pending",r1."totalNoOfAttendees",
case when cert."completedCount" is null then 0 else cert."completedCount" end,tm.training_state as "trainingState",count(*) as "attendeeCount"
from tr_training_master tm  inner join tr_training_primary_trainer_rel pt using (training_id)
inner join 
(select count(*) as "totalNoOfAttendees",training_id from 
(select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel)r group by r.training_id) r1
on r1.training_id = tm.training_id
left join 
(select count(*) as "completedCount",training_id from tr_certificate_master
where certificate_type = ''COURSECOMPLETION''
group by training_id) cert
on tm.training_id= cert.training_id
inner join (select max(topic_id),expiration_date,training_id,state from tr_topic_coverage_master
group by training_id,expiration_date,state ) tcm 
on tm.training_id = tcm.training_id and tm.expiration_date\:\:date = tcm.expiration_date\:\:date
inner join 
(select count(distinct effective_date) as days,training_id from tr_topic_coverage_master 
group by training_id) days on tm.training_id = days.training_id
inner join 
(select count(*),training_id from tr_attendance_master where  is_present = true
group by training_id,user_id) fully on fully.count = days.days and fully.training_id = days.training_id
where ((tm.expiration_date\:\:date < current_date or (tm.expiration_date\:\:date = current_date and tm.training_state = ''SUBMITTED'')) and
((tcm.state = ''SUBMITTED'') or (tcm.state = ''PENDING'' and tcm.expiration_date\:\:date + interval ''3 days'' >= current_date))
)
and pt.primary_trainer_id = #userId#
group by fully.training_id,tm.training_id,tcm.state,r1."totalNoOfAttendees",
cert."completedCount",tcm.training_id) res
inner join tr_training_course_rel tcr on tcr.training_id = res."trainingId"
inner join tr_course_master tcm1 on tcr.course_id = tcm1.course_id
inner join tr_training_primary_trainer_rel ptr on ptr.training_id = res."trainingId"
inner join um_user us on us.id = ptr.primary_trainer_id
inner join tr_training_org_unit_rel torg on torg.training_id = res."trainingId"
inner join location_master lm on lm.id = torg.org_unit_id'
where code = 'tr_training_status';










