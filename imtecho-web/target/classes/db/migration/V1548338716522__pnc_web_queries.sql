delete from query_master where code='pnc_retrieve_childs_by_member_id';
delete from query_master where code='pnc_retrieve_mother_list';
delete from query_master where code='pnc_retrieve_mother_list_by_member_id';
delete from query_master where code='pnc_retrieve_mother_list_by_family_id';
delete from query_master where code='pnc_retrieve_mother_list_by_location_id';
delete from query_master where code='pnc_retrieve_mother_list_by_mobile_number';
delete from query_master where code='pnc_retrieve_mother_list_by_family_mobile_number';
delete from query_master where code='pnc_retrieve_mother_list_by_name';
delete from query_master where code='pnc_retrieve_mother_list_by_woman_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_childs_by_member_id','memberId','
select * from imt_member where id in 
(select member_id from rch_wpd_child_master where wpd_mother_id in 
(select id from rch_wpd_mother_master where pregnancy_reg_det_id in 
(select id from rch_pregnancy_registration_det where member_id = #memberId# and delivery_date > now() - interval ''60 days''
and state=''DELIVERY_DONE'')))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list','userId','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#)))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_member_id','memberId','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where unique_health_id = ''#memberId#''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_family_id','familyId','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where family_id = ''#familyId#''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_location_id','locationId','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and location_id in
(select child_id from location_hierchy_closer_det where parent_id = #locationId#))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_mobile_number','mobileNumber','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where mobile_number = ''#mobileNumber#''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_family_mobile_number','mobileNumber','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'')))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_name','firstName,lastName,middleName','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where similarity(''#firstName#'',first_name)>=0.50 and similarity(''#lastName#'',last_name)>=0.60
and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='''' then similarity(''#middleName#'',middle_name)>=0.50 else 1=1 end))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'pnc_retrieve_mother_list_by_woman_id','womanId','
select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and mthr_reg_no = ''#womanId#'')
',true,'ACTIVE');