delete from query_master where code='child_service_retrieve_child_list_by_member_id';
delete from query_master where code='child_service_retrieve_child_list_by_family_id';
delete from query_master where code='child_service_retrieve_child_list_by_location_id';
delete from query_master where code='child_service_retrieve_child_list_by_mobile_number';
delete from query_master where code='child_service_retrieve_child_list_by_family_mobile_number';
delete from query_master where code='child_service_retrieve_child_list_by_name';
delete from query_master where code='child_service_retrieve_child_list_by_dob';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_member_id','memberId,userId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.unique_health_id = ''#memberId#''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_family_id','familyId,userId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.family_id = ''#familyId#''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_location_id','locationId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_mobile_number','mobileNumber,userId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.mobile_number = ''#mobileNumber#''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_family_mobile_number','mobileNumber,userId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_member.family_id in
(select family_id from imt_member where mobile_number = ''#mobileNumber#'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_name','firstName,middleName,lastName,userId,locationId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and similarity(''#firstName#'',imt_member.first_name)>=0.50 and similarity(''#lastName#'',imt_member.last_name)>=0.60
and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='''' then similarity(''#middleName#'',imt_member.middle_name)>=0.50 else 1=1 end
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_service_retrieve_child_list_by_dob','dob,userId,limit,offSet','
select imt_member.id,imt_member.unique_health_id,imt_member.family_id,imt_member.first_name,imt_member.middle_name,imt_member.last_name,imt_member.dob,imt_member.mobile_number from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.dob = ''#dob#''
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#
',true,'ACTIVE');