delete from QUERY_MASTER where CODE='helpdesk_update_member_dob';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'20483f2d-5a84-4a94-900f-ed6c372b40bc', -1,  current_date , -1,  current_date , 'helpdesk_update_member_dob',
'dob,loggedInUserId,memberId',
'with preg_mother_id as (
	select
	child.wpd_mother_id, mot.member_id
	from rch_wpd_child_master child
	left join rch_wpd_mother_master mot on child.wpd_mother_id = mot.id
	where child.member_id = #memberId#
)
,member_dob as (
	select dob from imt_member where id = #memberId#
)
,twin_brother_info as(
	select rch_wpd_child_master.member_id from rch_wpd_child_master, preg_mother_id
	where rch_wpd_child_master.wpd_mother_id = preg_mother_id.wpd_mother_id
	union
	select #memberId#
)
, insert_member_audit_log as (
 	insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
	select id,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''dob'',lm.id
	from (select id,dob from imt_member where id in(select member_id from twin_brother_info)) lm
	returning member_id
)
, update_member_dob_immmun_in_imt_member as (
	update imt_member set dob = ''#dob#'', immunisation_given = null, modified_by = #loggedInUserId#, modified_on = current_timestamp
	from twin_brother_info where id = twin_brother_info.member_id
	returning id
)
, delete_immun as (
	delete from rch_immunisation_master where member_id in (select member_id from twin_brother_info) and member_type = ''C''
	returning id
)
, update_mobile_noti_child as (
	update event_mobile_notification_pending
	set base_date = ''#dob#'' ,	modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id in (select member_id from twin_brother_info)
	and state=''PENDING''
	and notification_configuration_type_id in (''f51c8c4f-6b2b-4dcb-8e64-ada1a3044a67'',''dfa2b7ee-0ae4-4d5e-bb8e-20252905ebc6'')
	returning id
)
,delete_techo_noti_child as (
	delete from techo_notification_master
	where notification_type_id = 4
	and member_id in (select member_id from twin_brother_info) and state in (''PENDING'',''RESCHEDULE'')
	returning id
),
update_date_of_del_child as (
	update rch_wpd_child_master
	set date_of_delivery = ''#dob#'',  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id in (select member_id from twin_brother_info)
	returning id
),
update_date_of_del_mother as (
	 update rch_wpd_mother_master
	set date_of_delivery = ''#dob#'',  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id = (select member_id from preg_mother_id)
	returning id
),
update_mobile_noti_mother as (
	update event_mobile_notification_pending
	set base_date = ''#dob#'', 	modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id = (select member_id from preg_mother_id)
	and state=''PENDING''
	and notification_configuration_type_id = (select id from event_configuration_type
					where mobile_notification_type = (select id from notification_type_master where code = (''FHW_PNC'')))
	returning id
)
,delete_techo_noti_mother as (
	delete from techo_notification_master
	where notification_type_id = (select id from notification_type_master where code = (''FHW_PNC''))
	and member_id in (select member_id from twin_brother_info) and state in (''PENDING'',''RESCHEDULE'')
	returning id
)
update imt_member mother
set last_delivery_date = ''#dob#'', modified_by = #loggedInUserId#, modified_on = current_timestamp
from member_dob,preg_mother_id
where mother.id = preg_mother_id.member_id
and to_char(mother.last_delivery_date, ''dd/mm/yyyy'') = to_char(member_dob.dob, ''dd/mm/yyyy'');',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_member_gender';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'16ca4d1f-b4a5-4a9f-8217-2c8383ba32d1', -1,  current_date , -1,  current_date , 'helpdesk_update_member_gender',
'gender,loggedInUserId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''gender'',lm.id
  from (select id,gender from imt_member where id=#memberId#) lm;
update imt_member set gender =''#gender#'', modified_by = #loggedInUserId#, modified_on = now() where id=#memberId#;

delete from rch_pregnancy_registration_det where member_id = #memberId#;
delete from rch_anc_previous_pregnancy_complication_rel  where anc_id in (select id from rch_anc_master where member_id = #memberId#);
delete from rch_anc_dangerous_sign_rel  where anc_id in (select id from rch_anc_master where member_id = #memberId#);
delete from rch_anc_master where member_id = #memberId#;
delete from rch_pnc_mother_danger_signs_rel where mother_pnc_id in (select id from rch_pnc_mother_master where mother_id = #memberId#);
delete from rch_pnc_mother_master where mother_id  = #memberId#;
delete from rch_pnc_master where member_id = #memberId#;
delete from rch_lmp_follow_up where member_id = #memberId#;
delete from rch_wpd_mother_danger_signs_rel where wpd_id in (select id from rch_wpd_mother_master where member_id = #memberId#);
delete from rch_wpd_mother_high_risk_rel where wpd_id in (select id from rch_wpd_mother_master where member_id = #memberId#);
delete from rch_wpd_mother_treatment_rel where wpd_id in (select id from rch_wpd_mother_master where member_id = #memberId#);
delete from rch_wpd_mother_master where member_id = #memberId#;
delete from rch_immunisation_master where member_id = #memberId# and member_type = ''M'';',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_pregregdetails_reg_date';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'73f547e2-8f1a-4f19-884e-e73b0383f806', -1,  current_date , -1,  current_date , 'helpdesk_update_pregregdetails_reg_date',
'regDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_pregnancy_registration_det'',row_to_json(lm) as data, #loggedInUserId# as user_id,''reg_date'',lm.id  from (select id,member_id,reg_date from rch_pregnancy_registration_det where id=#rchPregnancyRegistrationDetId#) lm;

update rch_pregnancy_registration_det set reg_date =''#regDate#'',modified_by = #loggedInUserId#,modified_on=now() where id=#rchPregnancyRegistrationDetId# and member_id=#memberId#;

update imt_member set cur_preg_reg_date=''#regDate#'',modified_by = #loggedInUserId#,modified_on = now() where cur_preg_reg_det_id   = #rchPregnancyRegistrationDetId# and id=#memberId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_pregregdetails_lmp_date';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3829a14f-022e-4488-9f8a-c6d1ef6f55ff', -1,  current_date , -1,  current_date , 'helpdesk_update_pregregdetails_lmp_date',
'lmpDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''lmp'',lm.id  from (select id,lmp from imt_member where id=#memberId#) lm;

insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''rch_pregnancy_registration_det'',row_to_json(lm) as data, #loggedInUserId# as user_id,''lmp_date'',lm.id  from (select id,lmp_date from rch_pregnancy_registration_det where id=#rchPregnancyRegistrationDetId#) lm;

update rch_pregnancy_registration_det set lmp_date =''#lmpDate#'', edd = to_date(''#lmpDate#'', ''YYYY/MM/DD'') + interval ''281 days'',modified_by=#loggedInUserId#,modified_on=now() where id=#rchPregnancyRegistrationDetId# and member_id=#memberId#;

update imt_member set lmp = ''#lmpDate#'', edd = to_date(''#lmpDate#'', ''YYYY/MM/DD'') + interval ''281 days'',modified_by=#loggedInUserId#,modified_on=now() WHERE id=#memberId# and cur_preg_reg_det_id=#rchPregnancyRegistrationDetId#;

update event_mobile_notification_pending set base_date =  ''#lmpDate#'' where member_id=#memberId# and state=''PENDING'' and ref_code =#rchPregnancyRegistrationDetId# and notification_configuration_type_id in (''5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a'',''faedb8e7-3e46-40a2-a9ac-ea7d5de944fa'');

delete from techo_notification_master where notification_type_id in (5,2) and member_id=#memberId# and state=''PENDING'' and ref_code =#rchPregnancyRegistrationDetId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_anc_service_date';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'02db8c3b-751e-4c38-a3c5-cd9f6b01a0c8', -1,  current_date , -1,  current_date , 'helpdesk_update_anc_service_date',
'ancMasterId,serviceDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code
)
select lm.member_id,''rch_anc_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_anc_master where id=#ancMasterId#) lm;

update rch_anc_master set service_date =''#serviceDate#'',modified_by=#loggedInUserId#,modified_on=now() where id=#ancMasterId# and member_id = #memberId#;

with service_dates as (
select string_agg(to_char(service_date,''dd/MM/yyyy''),'','' order by service_date) service_dates ,pregnancy_reg_det_id
from rch_anc_master where pregnancy_reg_det_id =#rchPregnancyRegistrationDetId# group by pregnancy_reg_det_id)
update imt_member im set anc_visit_dates  = sd.service_dates,modified_by=#loggedInUserId#,modified_on=now()
from service_dates sd where sd.pregnancy_reg_det_id = cur_preg_reg_det_id and im.id = #memberId#',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_wpd_date_of_delivery';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'05ad3cdf-2cc5-4e8d-b06a-d04082e4a575', -1,  current_date , -1,  current_date , 'helpdesk_update_wpd_date_of_delivery',
'dateOfDelivery,loggedInUserId,wpdMotherId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_wpd_mother_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''date_of_delivery'',lm.id  from (select id,member_id,date_of_delivery from rch_wpd_mother_master where id=#wpdMotherId#) lm;

update rch_wpd_mother_master set date_of_delivery  =''#dateOfDelivery#'',modified_by=#loggedInUserId#,modified_on=now() where id=#wpdMotherId#;

update rch_wpd_child_master set date_of_delivery = ''#dateOfDelivery#'',modified_by=#loggedInUserId#,modified_on=now() where wpd_mother_id = #wpdMotherId#;

with wpd_childs as (
select * from rch_wpd_child_master where wpd_mother_id = #wpdMotherId# )
update imt_member im set dob=''#dateOfDelivery#'',modified_by=#loggedInUserId#,modified_on=now()
from wpd_childs wc where wc.member_id=im.id;


DELETE FROM rch_immunisation_master where member_type=''C'' and member_id in (
	select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#
);

update imt_member set immunisation_given = null,modified_by=#loggedInUserId#,modified_on=now() where id in (
select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#
);


update event_mobile_notification_pending  set base_date= ''#dateOfDelivery#'' where member_id=#memberId# and state=''PENDING'' and notification_configuration_type_id = ''9b1a331b-fac5-48f0-908e-ef545e0b0c52'';

delete from techo_notification_master where notification_type_id in (3) and member_id=#memberId# and state in (''PENDING'',''RESCHEDULE'');

delete from techo_notification_master where notification_type_id =4 and member_id
in(select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#)
and state in (''PENDING'',''RESCHEDULE'');

update event_mobile_notification_pending  set base_date= ''#dateOfDelivery#'' where
member_id in(select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#)
and state=''PENDING''
and notification_configuration_type_id in (''f51c8c4f-6b2b-4dcb-8e64-ada1a3044a67'',''dfa2b7ee-0ae4-4d5e-bb8e-20252905ebc6'');',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_pnc_service_date';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'72fb2bc9-7238-46bd-bf2d-55af353b89c0', -1,  current_date , -1,  current_date , 'helpdesk_update_pnc_service_date',
'serviceDate,pncMasterId,loggedInUserId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_pnc_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_pnc_master where id=#pncMasterId#) lm;

insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.mother_id,''rch_pnc_mother_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,mother_id,service_date from rch_pnc_mother_master where pnc_master_id=#pncMasterId#) lm;

update rch_pnc_master set service_date   =''#serviceDate#'',modified_by=#loggedInUserId#,modified_on=now() where id=#pncMasterId#; -- and member_id = #memberId#;

update rch_pnc_mother_master set service_date =''#serviceDate#'',modified_by=#loggedInUserId#,modified_on=now() where pnc_master_id=#pncMasterId#; -- and mother_id = #memberId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_child_service_date';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e005605d-e905-41a7-9c1b-5155c04514c9', -1,  current_date , -1,  current_date , 'helpdesk_update_child_service_date',
'serviceDate,rchChildServiceMasterId,loggedInUserId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_child_service_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_child_service_master where id=#rchChildServiceMasterId#) lm;

update rch_child_service_master set service_date = ''#serviceDate#'',modified_by=#loggedInUserId#,modified_on=now() where id=#rchChildServiceMasterId# and member_id = #memberId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_immu_update_given_on';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8b34ae99-0cdf-4195-903d-ef856dbf2460', -1,  current_date , -1,  current_date , 'helpdesk_immu_update_given_on',
'givenOn,rchImmuId,loggedInUserId,memberId',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_immunisation_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''given_on'',lm.id  from (select id,member_id,given_on from rch_immunisation_master where id=#rchImmuId#) lm;

update rch_immunisation_master set given_on = ''#givenOn#'',modified_by=#loggedInUserId#,modified_on=now() where id=#rchImmuId# and member_id= #memberId#;

update imt_member set immunisation_given = get_vaccination_string(id),modified_by=#loggedInUserId#,modified_on=now() where id = #memberId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='helpdesk_update_wpd_mother_delivery_place';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a77b2a4b-e432-42bf-8f9b-135c94b5e0ce', -1,  current_date , -1,  current_date , 'helpdesk_update_wpd_mother_delivery_place',
'deliveryPlace,healthInfrastructureId,typeOfHospital,userId,id',
'
INSERT INTO member_audit_log (member_id , table_name,  created_on , user_id, data , column_name, ref_code)
Values ((select member_id from rch_wpd_mother_master where id=#id# ), ''rch_wpd_mother_master'' , now() , #userId# , json_build_object(''id'',#id# , ''health_infrastructure_id'' , (select health_infrastructure_id from rch_wpd_mother_master where id= #id#) , ''type_of_hospital'' , (select type_of_hospital from rch_wpd_mother_master where id= #id#) ,''delivery_place'', (select rch_wpd_mother_master.delivery_place from rch_wpd_mother_master where id= #id# )) , ''health_infrastructure_id'' , #id#);

INSERT INTO member_audit_log  (member_id , table_name,  created_on , user_id, data , column_name, ref_code)
select member_id,''imt_member'' , now() , #userId# , json_build_object(''id'',member_id , ''place_of_birth'' , (select place_of_birth from imt_member where id = member_id)),''place_of_birth'', member_id from rch_wpd_child_master where wpd_mother_id = #id#;

update rch_wpd_mother_master set delivery_place = ''#deliveryPlace#'' , health_infrastructure_id = #healthInfrastructureId# , type_of_hospital = #typeOfHospital# , modified_on = now() , modified_by = #userId# where id = #id#;

update imt_member set place_of_birth = ''#deliveryPlace#'',modified_by = #userId# , modified_on = now() where id IN (select member_id from rch_wpd_child_master where wpd_mother_id = #id# );',
'Update Delivery Place',
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='remove_last_method_of_contraception';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'48a0b7c8-57e5-43fa-b766-977671a9f09a', -1,  current_date , -1,  current_date , 'remove_last_method_of_contraception',
'reason_for_change,unique_health_id,loggedInUserId',
'with insert_change_log_detail as (
insert into support_change_request_log(member_id,change_type,other_detail,reason_for_change,created_on)
select id as member_id,''REMOVE_LAST_METHOD_OF_CONTRACEPTION'',null,(case when ''null'' = ''#reason_for_change#'' then null else  ''#reason_for_change#'' end ),now() from imt_member
where unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id
),update_imt_member as (
update imt_member set last_method_of_contraception = null,modified_on = now(),modified_by=#loggedInUserId# where  unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id)
select cast(''Changes done'' as text) result from update_imt_member;',
'',
true, 'ACTIVE');