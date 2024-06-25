update techo_notification_master 
set state = 'MARK_AS_DEATH', 
modified_on = now(), 
modified_by = rch_wpd_mother_master.modified_by 
from rch_wpd_mother_master
where techo_notification_master.member_id = rch_wpd_mother_master.member_id 
and techo_notification_master.state in ('PENDING','RESCHEDULE')
and rch_wpd_mother_master.member_status = 'DEATH' 
and rch_wpd_mother_master.death_date is not null;

update event_mobile_notification_pending 
set is_completed = true, 
state = 'MARK_AS_DEATH', 
modified_by = rch_wpd_mother_master.modified_by, 
modified_on = now() 
from event_mobile_configuration, rch_wpd_mother_master
where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id 
and event_mobile_notification_pending.member_id = rch_wpd_mother_master.member_id
and event_mobile_notification_pending.state = 'PENDING'
and rch_wpd_mother_master.member_status = 'DEATH' 
and rch_wpd_mother_master.death_date is not null;

INSERT INTO public.rch_member_death_deatil(member_id, family_id, dod, death_reason, created_on, created_by) 
select rch_wpd_mother_master.member_id, rch_wpd_mother_master.family_id, 
rch_wpd_mother_master.death_date, cast(rch_wpd_mother_master.death_reason as integer), 
now(), rch_wpd_mother_master.modified_by 
from rch_wpd_mother_master
where rch_wpd_mother_master.member_status = 'DEATH' 
and rch_wpd_mother_master.death_date is not null;

update imt_member 
set death_detail_id = rch_member_death_deatil.id, 
state = 'com.argusoft.imtecho.member.state.dead', 
modified_on = now(), 
modified_by = rch_wpd_mother_master.modified_by 
from rch_member_death_deatil, rch_wpd_mother_master 
where rch_member_death_deatil.member_id = imt_member.id 
and rch_wpd_mother_master.member_id = imt_member.id
and rch_wpd_mother_master.member_status = 'DEATH' 
and rch_wpd_mother_master.death_date is not null;