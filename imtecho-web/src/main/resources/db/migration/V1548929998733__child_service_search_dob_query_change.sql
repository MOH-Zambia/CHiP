delete from query_master where code='child_service_retrieve_child_list_by_dob';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_dob','dob,userId,locationId,limit,offSet','
with member_details as
(select member_id from rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years'' 
and rch_child_analytics_details.dob = ''#dob#''
and rch_child_analytics_details.loc_id in 
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join member_details on member_details.member_id = imt_member.id
where imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
',true,'ACTIVE');