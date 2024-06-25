delete from query_master where code='child_cmtc_nrc_location_check';

delete from query_master where code='child_cmtc_nrc_location_check_by_unique_health_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_location_check_by_unique_health_id','userId,uniqueHealthId','
select location_id from imt_family where family_id in (select family_id from imt_member where unique_health_id = ''#uniqueHealthId#'')
and location_id in
(select child_id from location_hierchy_closer_det where parent_id  in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))
',true,'ACTIVE');

delete from query_master where code='child_cmtc_nrc_location_check_by_family_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_location_check_by_family_id','userId,familyId','
select location_id from imt_family where family_id in (select family_id from imt_member where family_id = ''#familyId#'')
and location_id in
(select child_id from location_hierchy_closer_det where parent_id  in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))
',true,'ACTIVE');

delete from query_master where code='child_cmtc_nrc_location_check_by_mobile_number';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_location_check_by_mobile_number','userId,mobileNumber','
select location_id from imt_family where family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'')
and location_id in
(select child_id from location_hierchy_closer_det where parent_id  in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))
',true,'ACTIVE');