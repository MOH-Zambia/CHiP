INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
    VALUES (-1,localtimestamp,null,null,'tr_training_status','userId', 
            'select distinct on (tcm.training_id) tm.training_id as "trainingId",
case when tm.location_name is null then ''N/A'' else tm.location_name end as "location",tm.effective_date as "effectiveDate",
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
on tm.training_id = tcm.training_id and tm.expiration_date = tcm.expiration_date
inner join 
(select count(distinct effective_date) as days,training_id from tr_topic_coverage_master 
group by training_id) days on tm.training_id = days.training_id
inner join 
(select count(*),training_id from tr_attendance_master where  is_present = true
group by training_id,user_id) fully on fully.count = days.days and fully.training_id = days.training_id
where ((tm.expiration_date < current_date or (tm.expiration_date = current_date and tm.training_state = ''SUBMITTED'')) and
((tcm.state = ''SUBMITTED'') or (tcm.state = ''PENDING'' and tcm.expiration_date + ''3 days'' >= current_date))
)
and pt.primary_trainer_id = #userId#
group by fully.training_id,tm.training_id,tcm.state,r1."totalNoOfAttendees",
cert."completedCount",tcm.training_id'
            , true,'ACTIVE','Retrieves date of training_status of userId');


