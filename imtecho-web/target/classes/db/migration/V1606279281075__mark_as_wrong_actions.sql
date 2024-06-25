-- Added column to store data with mark as wrong delivery action from help desk

alter table member_audit_log
add column document_id Integer,
add column reason Integer,
add column remarks varchar(1024);

-- Update rights for help desk

 update menu_config set feature_json = '{"canModifyMemberDob":false,
 "canModifyMemberGender":false,
 "canModifyPregnancyRegDate":false,
 "canModifyLmpDate":false,
 "canModifyAncServiceDate":false,
 "canModifyWpdServiceDate":false,
 "canModifyWpdDeliveryDate":false,
 "canModifyPncServiceDate":false,
 "canModifyChvServiceDate":false,
 "canModifyImmuGivenDate":false,
 "canModifyWpdDeliveryPlace":false,
 "canMarkAsEligibleCouple":false,
 "canMarkMemberAsArchive":false,
 "canMarkAsWrongDelivery":false}'
 where menu_name = 'Helpdesk Tool - Search' and navigation_state = 'techo.manage.searchfeature';

-- Insert query for member_audit_log
DELETE FROM QUERY_MASTER WHERE CODE='insert_member_audit_log_for_wpd';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a5b4faa3-8601-49ac-accd-320035ff1e40', 75398,  current_date , 75398,  current_date , 'insert_member_audit_log_for_wpd',
'reason,documentId,loggedInUserId,wpdMotherId,remarks',
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code,
document_id,reason,remarks)
select lm.member_id,''rch_wpd_mother_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,
''state'',lm.id, #documentId#, #reason#, #remarks#
  from (select id,member_id,state from rch_wpd_mother_master where id=#wpdMotherId#) lm
returning id;',
'Insert query for member_audit_log to insert data of mark as wrong delivery from help desk',
true, 'ACTIVE');

-- Created new form Data Change Request Reason and added reason for mark as wrong delivery

delete from listvalue_form_master where form_key = 'DATA_CHANGE_REQUEST_REASON';
INSERT INTO public.listvalue_form_master(
           form_key, form, is_active, is_training_req, query_for_training_completed)
   VALUES ('DATA_CHANGE_REQUEST_REASON','Data Change Request Reason',TRUE,FALSE,null);

delete from listvalue_field_master where field_key = 'MARK_AS_WRONG_DELIVERY_REASON';
INSERT INTO listvalue_field_master
      (field_key, field, is_active, field_type, form, role_type)
      VALUES('MARK_AS_WRONG_DELIVERY_REASON', 'Mark as Wrong Delivery Reason', true, 'T', 'DATA_CHANGE_REQUEST_REASON', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Similar names', 'MARK_AS_WRONG_DELIVERY_REASON', 0, 'null', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Maternal death', 'MARK_AS_WRONG_DELIVERY_REASON', 0, 'null', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Still/live birth', 'MARK_AS_WRONG_DELIVERY_REASON', 0, 'null', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Place of delivery', 'MARK_AS_WRONG_DELIVERY_REASON', 0, 'null', NULL);

-- Added state field to below query

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_wpd_mother_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7babe190-d7d1-412c-8d7b-934ad83cacb0', 75398,  current_date , 75398,  current_date , 'retrieve_rch_wpd_mother_master_info',
'healthid',
'with highriskdata as (select highrisk.wpd_id ,string_agg( list.value ,'', '') as highriskdata from rch_wpd_mother_high_risk_rel highrisk
left join listvalue_field_value_detail list on  highrisk.mother_high_risk = list.id group by highrisk.wpd_id )
,dangersigndata as (select danger.wpd_id ,string_agg( list.value ,'', '') as dangeroussigndata from rch_wpd_mother_danger_signs_rel danger
	left join listvalue_field_value_detail list on  danger.mother_danger_signs = list.id group by danger.wpd_id )
,deathdata as (select death.wpd_id ,string_agg( list.value ,'', '') as deathdata from rch_wpd_mother_death_reason_rel death
	left join listvalue_field_value_detail list on  death.mother_death_reason = list.id group by death.wpd_id )
select wpdmother.id as "wpdMotherId",wpdmother.member_id as "memberId",wpdmother.family_id as "wpdMotherFamilyId",
wpdmother.state,
wpdmother.latitude,wpdmother.longitude,
wpdmother.mobile_start_date as "mobileStartDate",wpdmother.mobile_end_date as "mobileEndDate",
wpdmother.location_id as "locationId",wpdmother.location_hierarchy_id as "locationHierarchyId",
wpdmother.date_of_delivery as "dateOfDelivery",wpdmother.member_status as "memberStatus",wpdmother.is_preterm_birth as "isPretermBirth",
wpdmother.delivery_place as "deliveryPlace",wpdmother.type_of_hospital as "typeOfHospital",
wpdmother.delivery_done_by as "deliveryDoneBy",wpdmother.mother_alive as "motherAlive",wpdmother.type_of_delivery as "typeOfDelivery",
wpdmother.referral_place as "referralPlace",wpdmother.created_by as "createdBy",
wpdmother.created_on as "createdOn",wpdmother.modified_by as "modifiedBy",wpdmother.modified_on as "modifiedOn",wpdmother.discharge_date as "dischargeDate",
wpdmother.breast_feeding_in_one_hour as "breastFeedingInOneHour",wpdmother.notification_id as "notificationId",
wpdmother.death_date as "deathDate",wpdmother.death_reason as "deathReason",wpdmother.place_of_death as "placeOfDeath",
wpdmother.cortico_steroid_given as "corticoSteroidGiven",wpdmother.mtp_done_at as "mtpDoneAt",
wpdmother.mtp_performed_by as "mtpPerformedBy",wpdmother.has_delivery_happened as "hasDeliveryHappened",wpdmother.other_danger_signs as "otherDangerSigns",
wpdmother.is_high_risk_case as "isHighRiskCase",wpdmother.referral_done as "referralDone",
wpdmother.pregnancy_reg_det_id as "pregnancyRegDetId",wpdmother.pregnancy_outcome as "pregnancyOutcome",wpdmother.misoprostol_given as "misoprostolGiven",
wpdmother.free_drop_delivery as "freeDropDelivery",wpdmother.delivery_person as "deliveryPerson",
wpdmother.is_discharged as "isDischarged",wpdmother.health_infrastructure_id as "healthInfrastructureId",
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as "familyId",
loc.name as locationname, hospitaltype.value as typeofhospitalvalue,referralplace.value as referralplacename,
risk.highriskdata as "highRisks", danger.dangeroussigndata as "motherDangerSigns",death.deathdata
from rch_wpd_mother_master wpdmother
left join location_master loc on wpdmother.location_id = loc.id
left join imt_family fam on wpdmother.family_id = fam.id
left join um_user usr on wpdmother.created_by = usr.id
left join highriskdata risk on wpdmother.id = risk.wpd_id
left join dangersigndata danger on wpdmother.id = danger.wpd_id
left join deathdata death on wpdmother.id = death.wpd_id
left join listvalue_field_value_detail hospitaltype on wpdmother.type_of_hospital = hospitaltype.id
left join listvalue_field_value_detail referralplace on wpdmother.referral_place = referralplace.id
where wpdmother.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by wpdmother.created_on desc limit 5',
'Retrieve RCH WPD Mother Master Information',
true, 'ACTIVE');