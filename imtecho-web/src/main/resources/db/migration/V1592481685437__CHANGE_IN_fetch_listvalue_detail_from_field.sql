DELETE FROM QUERY_MASTER WHERE CODE='fetch_listvalue_detail_from_field';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'161086f3-5a83-47f5-b5b6-0d8e809fd5d7', 75398,  current_date , 75398,  current_date , 'fetch_listvalue_detail_from_field', 
'field', 
'select * from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field =#field#) and is_active = true', 
'It will fetch the active list values from field name', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_previous_anc_information';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'79d055e3-176c-449a-bedc-ccc2527bbec4', 75398,  current_date , 75398,  current_date , 'retrieve_previous_anc_information', 
'healthid,curPregRegDetId', 
'with dangsign as ( select rel.anc_id,string_agg(det.value ,'', '') as dangeroussign from rch_anc_dangerous_sign_rel rel
inner join listvalue_field_value_detail det on rel.dangerous_sign_id = det.id group by rel.anc_id )
select anc.id,anc.member_id,anc.family_id as ancfamilyid,anc.latitude,anc.longitude,anc.mobile_start_date,anc.mobile_end_date,anc.location_id,anc.location_hierarchy_id,
anc.lmp,anc.weight,anc.jsy_beneficiary,anc.kpsy_beneficiary,anc.iay_beneficiary,anc.chiranjeevi_yojna_beneficiary,anc.anc_place,anc.systolic_bp,
anc.diastolic_bp,anc.member_height,anc.foetal_height,anc.foetal_heart_sound,anc.ifa_tablets_given,anc.fa_tablets_given,anc.calcium_tablets_given,
anc.hbsag_test,anc.blood_sugar_test,anc.urine_test_done,anc.albendazole_given,anc.referral_place,anc.dead_flag,anc.other_dangerous_sign,anc.created_by,
anc.created_on,anc.modified_by,anc.modified_on,anc.member_status,anc.edd,anc.notification_id,anc.death_date,anc.vdrl_test,
anc.hiv_test,anc.place_of_death,anc.haemoglobin_count,anc.death_reason,anc.jsy_payment_done,anc.last_delivery_outcome,anc.expected_delivery_place,
anc.family_planning_method,anc.foetal_position,anc.dangerous_sign_id,anc.other_previous_pregnancy_complication,anc.foetal_movement,anc.referral_done,
anc.urine_albumin,anc.urine_sugar,anc.is_high_risk_case,anc.blood_group,anc.sugar_test_after_food_val,anc.sugar_test_before_food_val,anc.pregnancy_reg_det_id,
anc.service_date,anc.sickle_cell_test, 
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,fam.family_id as familyid,
dan.dangeroussign, ancplace.value as ancplacename, referralplace.value as referralplacename, loc.name as locationname
from rch_anc_master anc 
left join imt_family fam on anc.family_id = fam.id
left join um_user usr on anc.created_by = usr.id
left join location_master loc on anc.location_id = loc.id
left join dangsign dan on anc.id = dan.anc_id
left join listvalue_field_value_detail ancplace on anc.anc_place = ancplace.id
left join listvalue_field_value_detail referralplace on anc.referral_place = referralplace.id
where anc.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) and anc.pregnancy_reg_det_id = #curPregRegDetId# order by anc.created_on desc limit 5', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_health_infra_for_user';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'867748e8-97fb-4f62-9d28-4f2e268cbd8f', 75398,  current_date , 75398,  current_date , 'retrieve_health_infra_for_user', 
'userId', 
'select  h.name , h.id,h.type as type from health_infrastructure_details  h
 ,user_health_infrastructure  u
 where u.health_infrastrucutre_id=h.id and user_id=#userId# and u.state=''ACTIVE''', 
'Retrieve Health Infrastructure for the user id', 
true, 'ACTIVE');