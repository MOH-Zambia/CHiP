DELETE FROM public.query_master
 WHERE code='retrieve_call_count_detail_of_highrisk_usr';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_call_count_detail_of_highrisk_usr','user_id','with todaycount as 
(
select 
sum(case when is_fhw_called = ''t'' then 1 else 0 end) as fhwtod,
sum(case when is_asha_called = ''t'' then 1 else 0 end) as ashatod,
sum(case when is_beneficiary_called = ''t'' then 1 else 0 end) as beneficiarytod 
from gvk_high_risk_follow_up_responce where gvk_call_response_status = ''com.argusoft.imtecho.gvk.call.success''
and cast(created_on as date) = current_date and created_by = #user_id#
group by is_fhw_called, is_asha_called, is_beneficiary_called
), today_sum as (
select 
sum(todaycount.fhwtod) as fhwtodaycount, 
sum(todaycount.ashatod) as ashatodaycount, 
sum(todaycount.beneficiarytod) as beneficiarytodaycount,
(select count(id) from gvk_high_risk_follow_up_responce where gvk_call_response_status != ''com.argusoft.imtecho.gvk.call.success'' 
and created_by = #user_id# and cast(created_on as date) = current_date) as unsuccessfultodaycount
 from todaycount
), totalcount as (
select 
sum(case when is_fhw_called = ''t'' then 1 else 0 end) as fhwtot,
sum(case when is_asha_called = ''t'' then 1 else 0 end) as ashatot,
sum(case when is_beneficiary_called = ''t'' then 1 else 0 end) as beneficiarytot 
from gvk_high_risk_follow_up_responce where gvk_call_response_status = ''com.argusoft.imtecho.gvk.call.success''
and created_by = #user_id#
group by is_fhw_called, is_asha_called, is_beneficiary_called
), total_sum as (
select 
sum(totalcount.fhwtot) as fhwtotalcount, 
sum(totalcount.ashatot) as ashatotalcount, 
sum(totalcount.beneficiarytot) as beneficiarytotalcount,
(select count(id) from gvk_high_risk_follow_up_responce where gvk_call_response_status != ''com.argusoft.imtecho.gvk.call.success'' 
and created_by = #user_id# ) as unsuccessfultotalcount 
from totalcount
)
select * from today_sum, total_sum;',true,'ACTIVE','Retrieve call count information for highrisk usr');

alter table gvk_high_risk_follow_up_responce 
add column is_beneficiary_received_iron_sucrose_injection_anemia varchar(255),
add column is_fhw_called boolean,
add column is_asha_called boolean,
add column is_beneficiary_called boolean,
add column is_conference_call boolean;


alter table gvk_high_risk_follow_up_usr_info 
add column highrisk_reason varchar(255),
add column location_id bigint;