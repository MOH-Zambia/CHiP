delete from query_master where code='pnc_retrieve_mother_list_by_location_id';
delete from query_master where code='pnc_retrieve_mother_list_by_mobile_number';
delete from query_master where code='pnc_retrieve_mother_list_by_family_mobile_number';
delete from query_master where code='pnc_retrieve_mother_list_by_name';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_location_id','locationId,limit,offSet','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_mobile_number','mobileNumber,limit,offSet','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where mobile_number = ''#mobileNumber#'') limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_family_mobile_number','mobileNumber,limit,offSet','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'')) limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_name','firstName,middleName,lastName,limit,offSet','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where similarity(''#firstName#'',first_name)>=0.50 and similarity(''#lastName#'',last_name)>=0.60
and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='''' then similarity(''#middleName#'',middle_name)>=0.50 else 1=1 end) limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
',true,'ACTIVE');