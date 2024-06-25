-- retrieve_anc_information
DELETE FROM public.query_master
WHERE code='retrieve_anc_information';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_anc_information','healthid','with dangsign as ( select rel.anc_id,string_agg(det.value ,'', '') as dangeroussign from rch_anc_dangerous_sign_rel rel
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
where anc.member_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by anc.created_on desc limit 5',true,'ACTIVE','Retrieve RCH ANC Master Information');

-- retrieve_rch_child_service_master_info
DELETE FROM public.query_master
WHERE code='retrieve_rch_child_service_master_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_child_service_master_info','healthid','select csm.id as "csmId",csm.member_id as "memberId",csm.family_id as "familyId",csm.latitude,csm.longitude,csm.mobile_start_date as "mobileStartDate",
csm.mobile_end_date as "mobileEndDate",csm.location_id as "locationId",
csm.location_hierarchy_id as "locationHierarchyId",csm.notification_id as "notification_id",csm.is_alive as "isAlive",
csm.weight as "weight",csm.ifa_syrup_given as "ifaSyrupGiven",csm.complementary_feeding_started as "complementaryFeedingStarted",
csm.is_treatement_done as "isTreatementDone",csm.created_by as "createdBy",csm.created_on as "createdOn",csm.modified_by as "modifiedBy",
csm.modified_on as "modifiedOn",csm.death_date as "deathDate",csm.place_of_death as "placeOfDeath",csm.member_status as "memberStatus",
csm.death_reason as "deathReason",csm.other_death_reason as "otherDeathReason",csm.complementary_feeding_start_period as "complementaryFeedingStartPeriod",
csm.other_diseases as "otherDiseases",csm.mid_arm_circumference as "midArmCircumference",csm.height as "height",
csm.have_pedal_edema as "havePedalEdema",csm.exclusively_breastfeded as "exclusivelyBreastfeded",csm.any_vaccination_pending as "anyVaccinationPending",
csm.service_date as "serviceDate",
csm.sd_score as "sdScore",
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as familyid,
loc.name as locationname
from rch_child_service_master csm 
left join location_master loc on csm.location_id = loc.id
left join imt_family fam on csm.family_id = fam.id
left join um_user usr on csm.created_by = usr.id
where csm.member_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by csm.created_on desc limit 5',true,'ACTIVE','Retrieve RCH Child Service Master Information');

-- retrieve_rch_wpd_mother_master_info
DELETE FROM public.query_master
WHERE code='retrieve_rch_wpd_mother_master_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_wpd_mother_master_info','healthid','with highriskdata as (select highrisk.wpd_id ,string_agg( list.value ,'', '') as highriskdata from rch_wpd_mother_high_risk_rel highrisk
left join listvalue_field_value_detail list on  highrisk.mother_high_risk = list.id group by highrisk.wpd_id )
,dangersigndata as (select danger.wpd_id ,string_agg( list.value ,'', '') as dangeroussigndata from rch_wpd_mother_danger_signs_rel danger
	left join listvalue_field_value_detail list on  danger.mother_danger_signs = list.id group by danger.wpd_id )
,deathdata as (select death.wpd_id ,string_agg( list.value ,'', '') as deathdata from rch_wpd_mother_death_reason_rel death
	left join listvalue_field_value_detail list on  death.mother_death_reason = list.id group by death.wpd_id ) 
select wpdmother.id as "wpdMotherId",wpdmother.member_id as "memberId",wpdmother.family_id as "familyId",
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
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as familyid,
loc.name as locationname, hospitaltype.value as typeofhospital,referralplace.value as referralplacename, 
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
where wpdmother.member_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by wpdmother.created_on desc limit 5',true,'ACTIVE','Retrieve RCH WPD Mother Master Information');

-- retrieve_rch_wpd_child_master_info
DELETE FROM public.query_master
WHERE code='retrieve_rch_wpd_child_master_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_wpd_child_master_info','healthid','with deformity as (select deformity.wpd_id ,string_agg( list.value ,'', '') as deformitysign from rch_wpd_child_congential_deformity_rel deformity
left join listvalue_field_value_detail list on  deformity.congential_deformity = list.id group by deformity.wpd_id )
,dangsign as (select danger.wpd_id ,string_agg( list.value ,'', '') as dangeroussign from rch_wpd_child_danger_signs_rel danger
	left join listvalue_field_value_detail list on  danger.danger_signs = list.id group by danger.wpd_id)
select wpdchild.id as "wpdchildid", wpdchild.member_id as "memberId", wpdchild.family_id as "familyId", 
wpdchild.latitude, wpdchild.longitude, wpdchild.mobile_start_date as "startDate", 
wpdchild.mobile_end_date as "endDate", 
wpdchild.location_id as "locationId", wpdchild.location_hierarchy_id as "locationHierarchyId", wpdchild.wpd_mother_id as "wpdMotherId",
 wpdchild.mother_id as "motherId", wpdchild.pregnancy_outcome as "pregnancyOutcome", wpdchild.gender as "childGender", 
wpdchild.birth_weight as "childBirthWeight", wpdchild.date_of_delivery as "deliveryDate", wpdchild.created_by as "createdBy",
 wpdchild.created_on as "createdOn", wpdchild.modified_by as "modifiedBy", wpdchild.modified_on as "modifiedOn", 
wpdchild.baby_cried_at_birth as "childCry", wpdchild.notification_id as "notificationId", wpdchild.death_date as "deathDate",
 wpdchild.death_reason as "deathReason", wpdchild.place_of_death as "placeOfDeath", wpdchild.member_status as "memberStatus", 
wpdchild.type_of_delivery as "typeOfDelivery", wpdchild.breast_feeding_in_one_hour as "breastFeeding",
 wpdchild.other_congential_deformity as "congenitalDeformityOther", wpdchild.is_high_risk_case as "isHighRiskCase", 
wpdchild.was_premature as "wasPremature", wpdchild.referral_reason as "childReferralReason", wpdchild.referral_transport as "childReferralTransport",
 wpdchild.referral_place as "childReferralPlace", wpdchild.name as "name", wpdchild.breast_crawl as "breastCrawl", 
wpdchild.kangaroo_care as "kangarooCare", wpdchild.other_danger_sign as "childOtherDangerSign",dan.dangeroussign,def.deformitysign,
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as familyid,
loc.name as locationname, referralplace.value as referralplacename
from rch_wpd_child_master wpdchild 
left join location_master loc on wpdchild.location_id = loc.id
left join imt_family fam on wpdchild.family_id = fam.id
left join deformity def on wpdchild.id = def.wpd_id
left join dangsign dan on wpdchild.id = dan.wpd_id
left join um_user usr on wpdchild.created_by = usr.id
left join listvalue_field_value_detail referralplace on wpdchild.referral_place = referralplace.id
where wpdchild.member_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by wpdchild.created_on desc limit 5
',true,'ACTIVE','Retrieve RCH WPD Child Master Information');

-- retrieve_rch_pnc_mother_master_info
DELETE FROM public.query_master
WHERE code='retrieve_rch_pnc_mother_master_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_pnc_mother_master_info','healthid','with dangersign as (select danger.mother_pnc_id, string_agg(list.value,'', '') as dangersigndata from rch_pnc_mother_danger_signs_rel danger
left join listvalue_field_value_detail list on  danger.mother_danger_signs = list.id group by danger.mother_pnc_id)
,deathsign  as (select death.mother_pnc_id, string_agg(list.value,'', '') as deathsigndata from rch_pnc_mother_death_reason_rel death
left join listvalue_field_value_detail list on  death.mother_death_reason = list.id group by death.mother_pnc_id)
select pncmother.id as "pcnmotherid", pncmother.pnc_master_id as "pncMasterId", pncmother.mother_id as "motherId", 
pncmother.date_of_delivery as "dateOfDelivery", pncmother.service_date as "serviceDate", pncmother.is_alive as "isAlive", 
pncmother.ifa_tablets_given as "ifaTabletsGiven", pncmother.other_danger_sign as "otherDangerSign", pncmother.referral_place as "referralPlace",
 pncmother.created_by as "createdBy", pncmother.created_on as "createdOn", 
pncmother.modified_by as "modifiedBy", pncmother.modified_on as "modifiedOn", pncmother.member_status as "memberStatus",
 pncmother.death_date as "deathDate", pncmother.death_reason as "deathReason", pncmother.place_of_death as "placeOfDeath", 
pncmother.fp_insert_operate_date as "fpInsertOperateDate", pncmother.family_planning_method as "familyPlanningMethod", 
pncmother.other_death_reason as "otherDeathReason", pncmother.is_high_risk_case as "isHighRiskCase", pncmother.mother_referral_done as "motherReferralDone", 
pncmaster.family_id, pncmaster.latitude, pncmaster.longitude,
 pncmaster.mobile_start_date as "mobileStartDate", pncmaster.mobile_end_date as "mobileEndDate", 
pncmaster.location_id as "locationId", pncmaster.location_hierarchy_id as "locationHierarchyId", pncmaster.notification_id as "notificationId",
 pncmaster.pregnancy_reg_det_id as "pregnancyRegDetId", pncmaster.pnc_no as "pncNo", 
pncmaster.is_from_web as "isFromWeb", pncmaster.service_date as "serviceDate", 
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,referralplace.value as referralplacename,
fam.family_id as familyid,loc.name as locationname, danger.dangersigndata, death.deathsigndata
from rch_pnc_mother_master pncmother 
left join rch_pnc_master pncmaster on pncmother.pnc_master_id = pncmaster.id 	
left join imt_family fam on pncmaster.family_id = fam.id
left join location_master loc on pncmaster.location_id = loc.id
left join um_user usr on pncmother.created_by = usr.id
left join deathsign death on pncmother.id = death.mother_pnc_id
left join dangersign danger on pncmother.id = danger.mother_pnc_id
left join listvalue_field_value_detail referralplace on pncmother.referral_place = referralplace.id
where pncmother.mother_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by pncmother.created_on desc limit 5
',true,'ACTIVE','Retrieve RCH PNC Mother Master Information');

-- retrieve_rch_pnc_child_master_info
DELETE FROM public.query_master
WHERE code='retrieve_rch_pnc_child_master_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_pnc_child_master_info','healthid','with dangersign as (select danger.child_pnc_id, string_agg(list.value,'', '') as dangersigndata from rch_pnc_child_danger_signs_rel danger
left join listvalue_field_value_detail list on  danger.child_danger_signs = list.id group by danger.child_pnc_id)
,deathsign  as (select death.child_pnc_id, string_agg(list.value,'', '') as deathsigndata from rch_pnc_child_death_reason_rel death
left join listvalue_field_value_detail list on  death.child_death_reason = list.id group by death.child_pnc_id)
select pncchild.id as "pncChildId", pncchild.pnc_master_id as "pncMasterId", pncchild.child_id as "childId", 
pncchild.is_alive as "isAlive", pncchild.other_danger_sign as "childOtherDanger", pncchild.child_weight as "childWeight", 
pncchild.created_by as "createdBy", pncchild.created_on as "createdOn", pncchild.modified_by as "modifiedBy", 
pncchild.modified_on as "modifiedOn", pncchild.member_status as "memberStatus", pncchild.death_date as "childDeathDate", 
pncchild.death_reason as "childDeathReason", pncchild.place_of_death as "childDeathPlace", pncchild.referral_place as "childReferralPlace", 
pncchild.other_death_reason as "childDeathOtherReason", pncchild.is_high_risk_case as "isHighRiskCase", 
pncchild.child_referral_done as "childReferralDone", pncmaster.family_id,pncmaster.latitude,pncmaster.longitude,
pncmaster.mobile_start_date as "mobileStartDate", pncmaster.mobile_end_date as "mobileEndDate", 
pncmaster.location_id as "locationId", pncmaster.location_hierarchy_id as "locationHierarchyId", pncmaster.notification_id as "notificationId",
pncmaster.pregnancy_reg_det_id as "pregnancyRegDetId", pncmaster.pnc_no as "pncNo", 
pncmaster.is_from_web as "isFromWeb", pncmaster.service_date as "serviceDate", 
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,referralplace.value as referralplacename,
fam.family_id as familyid,loc.name as locationname, danger.dangersigndata, death.deathsigndata
from rch_pnc_child_master pncchild 
left join rch_pnc_master pncmaster on pncchild.pnc_master_id = pncmaster.id 	
left join imt_family fam on pncmaster.family_id = fam.id
left join location_master loc on pncmaster.location_id = loc.id
left join um_user usr on pncchild.created_by = usr.id
left join deathsign death on pncchild.id = death.child_pnc_id
left join dangersign danger on pncchild.id = danger.child_pnc_id
left join listvalue_field_value_detail referralplace on pncchild.referral_place = referralplace.id 
where pncchild.child_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by pncchild.created_on desc limit 5 
',true,'ACTIVE','Retrieve RCH PNC Child Master Information');

-- retrieve_rch_pregnancy_registration_det
DELETE FROM public.query_master
WHERE code='retrieve_rch_pregnancy_registration_det';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_rch_pregnancy_registration_det','healthid','select 
preg.id as "pregId",preg.mthr_reg_no as "motherRegNo",preg.member_id,preg.lmp_date as "lmpDate",preg.edd as "expectedDeliveryDate",
preg.reg_date as "registrationDate",preg.state,preg.created_on as "createdOn",preg.created_by as "createdBy",preg.modified_on as "modifiedOn",
preg.modified_by as "modifiedBy",preg.location_id as "locationId",preg.family_id as "familyId",preg.current_location_id as "currLocationId",
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,fam.family_id as familyid,
loc.name as locationname, curloc.name as currentlocationname
from rch_pregnancy_registration_det preg 
left join um_user usr on preg.created_by = usr.id
left join imt_family fam on preg.family_id = fam.id
left join location_master loc on preg.location_id = loc.id
left join location_master curloc on preg.current_location_id = curloc.id
where preg.member_id = (select id from imt_member where unique_health_id = ''#healthid#'' limit 1) order by preg.created_on desc limit 5
',true,'ACTIVE','Retrieve Pregnancy Registration Details');