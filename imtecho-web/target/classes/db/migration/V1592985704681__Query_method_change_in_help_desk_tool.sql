DELETE FROM QUERY_MASTER WHERE CODE='retrieve_family_and_member_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'83a1447e-2abe-43c9-94d5-3ee37aaa5460', 75398,  current_date , 75398,  current_date , 'retrieve_family_and_member_info', 
'familyid', 
'with emamtalocation as (
        select
        f.family_id,string_agg(lm.name,''> '' order by lhcd.depth desc) as emamtalocationname
        from imt_family f
	    inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
	    inner join location_master lm on lm.id = lhcd.parent_id where f.family_id = #familyid#
	    group by f.family_id
    )
    select
    f.family_id,
    f.address1 as address1,
    f.address2 as address2,
    f.bpl_flag as bplflag,
    f.house_number as housenumber,
    f.is_verified_flag as verifiedflag,
    f.migratory_flag as migratoryflag,
    f.toilet_available_flag as toiletavailableflag,
    f.vulnerable_flag as vulnerableflag,
    f.basic_state as familybasicstate,
    m.id as memberid,
    m.unique_health_id as uniquehealthid,
    m.first_name || '' '' || m.middle_name || '' '' || m.last_name as membername,
    m.family_head as familyhead,
    m.is_pregnant as ispregnant,
    m.gender as gender,
    m.mobile_number as mobilenumber,
    m.basic_state as memberbasicstate,
    string_agg(lm.name,''> '' order by lhcd.depth desc) as locationname,
    emm.emamtalocationname,
    case
        when f.state in (''CFHC_FN'',''CFHC_FV'') then ''Yes''
        else ''No''
    end as "isFamilyVerifiedUnderCFHC"
    from imt_family f
    inner join imt_member m on f.family_id = m.family_id
    inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
    inner join location_master lm on lm.id = lhcd.parent_id
    left join emamtalocation emm on f.family_id = emm.family_id
    where f.family_id = #familyid#
    group by m.id,
    f.address1,
    f.address2,
    f.bpl_flag,
    f.house_number,
    f.is_verified_flag,
    f.migratory_flag,
    f.toilet_available_flag,
    f.vulnerable_flag,
    f.basic_state,
    emm.emamtalocationname,
    f.family_id,
    f.state', 
'Retrieve family and members basic info using familyId', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_member_info_by_health_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9ac89158-c675-4c52-b423-9de8294675c7', 75398,  current_date , 75398,  current_date , 'retrieve_member_info_by_health_id', 
'healthid', 
'select m.unique_health_id as "uniqueHealthId",m.id as "memberId", concat( m.first_name, '' '' ,m.middle_name ,'' '',m.last_name) as "memberName",  
                    m.family_id as "familyId", m.dob as "dob",  
                    case when m.aadhar_number_encrypted is not null then ''Yes'' else ''No'' end as "aadharAvailable", 
                    m.mobile_number as "mobileNumber", m.is_pregnant as "isPregnantFlag", m.gender,  
                    m.basic_state as "memberState", m.ifsc, m.account_number as "accountNumber",  
                    m.family_head as "familyHeadFlag", m.immunisation_given as "immunisationGiven", 
                    case when (m.dob > now() - interval ''5 years'') then ''Yes'' else ''No'' end as "isChild", 
                    case when (
				(m.fp_insert_operate_date is null or  ( now() - m.fp_insert_operate_date < interval ''3 month''))
				and (m.last_method_of_contraception is null or m.last_method_of_contraception not in (''FMLSTR'',''MLSTR''))
				and (m.hysterectomy_done is null or m.hysterectomy_done = false)
				and (m.menopause_arrived is null or  m.menopause_arrived = false)
				and (m.is_pregnant is null or m.is_pregnant = false)
				and (m.dob < now() - interval ''18 years'' and m.dob > now() - interval ''45 years'')
				and m.marital_status = 629
				and m.gender = ''F''
			)  then ''Yes'' else ''No'' end as "isEligibleCouple",
			case when m.last_method_of_contraception in (''FMLSTR'',''MLSTR'') then true else false end as "isFemaleSterilizationFlag",
		    concat(case 
			  when (now() - m.fp_insert_operate_date > interval ''3 month'') then (
			   case 
			    when m.last_method_of_contraception in (''IUCD5'',''IUCD10'') then '' Last contraception method is IUCD.''
			    when m.last_method_of_contraception = ''CHHAYA'' then '' Last contraception method is CHHAYA.''
			    when m.last_method_of_contraception = ''ANTARA'' then '' Last contraception method is ANTARA.''
			   end
			  )end,
			 case when m.last_method_of_contraception = ''FMLSTR'' then '' Last contraception method is FEMALE STERILIZATION.'' end,
			 case when m.last_method_of_contraception = ''MLSTR'' then ''Last contraception method is MALE STERILIZATION.'' end,
			 case when m.menopause_arrived = true then ''Menopause is arrived.'' end,
			 case when m.marital_status != 629 then ''Merital status is not married.'' end,
			 case when m.is_pregnant = true then ''Member is pregnant.'' end,
			 case when m.hysterectomy_done = true then ''Hysterectomy is done.'' end,
			 case when (m.dob > now() - interval ''18 years'' and m.dob < now() - interval ''45 years'') then ''Age is not between 18 to 45 year.'' end,
			 case when m.gender = ''M'' then ''Member is Male.'' end
			) as "reasonForNotEligibleCouple",
                    (select string_agg(to_char(created_on, ''dd/mm/yyyy''),'','' order by created_on desc)  
                    from rch_child_service_master  where member_id  = m.id group by member_id) as "childServiceVisitDatesList", 
                    m.weight as weight, m.haemoglobin, 
                    concat( usr.first_name , '' '' , usr.middle_name , '' '' , usr.last_name)  as "fhwName", 
                    concat(ashaName.first_name , '' '' , ashaName.middle_name , '' '' , ashaName.last_name)  as "ashaName",
                    usr.user_name as fhwUserName, usr.contact_number as "fhwMobileNumber", 
                    (select concat(first_name , '' '' , middle_name , '' '' , last_name) from imt_member where id = m.mother_id) as "motherName" , 
                    (select string_agg(to_char(service_date , ''dd/mm/yyyy''),'','' order by service_date  desc)  
                    from rch_anc_master where member_id  = m.id group by member_id) as "ancVisitDatesList", 
                    f.basic_state as "familyState", 
                    string_agg(lm.name,''> '' order by lhcd.depth desc) as "memberLocation",
                    case when f.area_id is not null then get_location_hierarchy(f.area_id) else null end as "areaHierarchy"
                    from imt_member m  
                    left join imt_family f on f.family_id = m.family_id 
                    left join um_user_location ul on f.location_id = ul.loc_id  and ul.state = ''ACTIVE'' 
                    left join um_user usr on ul.user_id = usr.id and usr.role_id = 30 and usr.state = ''ACTIVE'' 
                    left join um_user_location ashaLoc on f.area_id = ashaLoc.loc_id  and ashaLoc.state = ''ACTIVE'' 
                    left join um_user ashaName on ashaLoc.user_id = ashaname.id and ashaName.role_id = 24 and ashaName.state = ''ACTIVE''
                    left join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id 
                    left join location_master lm on lm.id = lhcd.parent_id 
                    left join location_type_master loc_name on lm.type = loc_name.type 
                    where unique_health_id = #healthid#
                    group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,
                    ashaName.middle_name,ashaName.last_name,m.unique_health_id,f.basic_state,f.area_id limit 1', 
'', 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_child_service_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c44f124a-b856-4576-8720-de03478a41da', 75398,  current_date , 75398,  current_date , 'retrieve_rch_child_service_master_info', 
'healthid', 
'select csm.id as "csmId",csm.member_id as "memberId",csm.family_id as "csmFamilyId",csm.latitude,csm.longitude,csm.mobile_start_date as "mobileStartDate",
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
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as "familyId",
loc.name as locationname
from rch_child_service_master csm 
left join location_master loc on csm.location_id = loc.id
left join imt_family fam on csm.family_id = fam.id
left join um_user usr on csm.created_by = usr.id
where csm.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by csm.created_on desc limit 5', 
'Retrieve RCH Child Service Master Information', 
true, 'ACTIVE');


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


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_wpd_child_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3c4d910e-6a1d-4977-890d-762109441751', 75398,  current_date , 75398,  current_date , 'retrieve_rch_wpd_child_master_info', 
'healthid', 
'with deformity as (select deformity.wpd_id ,string_agg( list.value ,'', '') as deformitysign from rch_wpd_child_congential_deformity_rel deformity
left join listvalue_field_value_detail list on  deformity.congential_deformity = list.id group by deformity.wpd_id )
,dangsign as (select danger.wpd_id ,string_agg( list.value ,'', '') as dangeroussign from rch_wpd_child_danger_signs_rel danger
	left join listvalue_field_value_detail list on  danger.danger_signs = list.id group by danger.wpd_id)
select wpdchild.id as "wpdchildid", wpdchild.member_id as "memberId", wpdchild.family_id as "wpdChildFamilyId", 
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
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username, fam.family_id as "familyId",
loc.name as locationname, referralplace.value as referralplacename
from rch_wpd_child_master wpdchild 
left join location_master loc on wpdchild.location_id = loc.id
left join imt_family fam on wpdchild.family_id = fam.id
left join deformity def on wpdchild.id = def.wpd_id
left join dangsign dan on wpdchild.id = dan.wpd_id
left join um_user usr on wpdchild.created_by = usr.id
left join listvalue_field_value_detail referralplace on wpdchild.referral_place = referralplace.id
where wpdchild.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by wpdchild.created_on desc limit 5', 
'Retrieve RCH WPD Child Master Information', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_pnc_mother_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3efdda8a-c4ed-4b02-a545-f9e617348bb4', 75398,  current_date , 75398,  current_date , 'retrieve_rch_pnc_mother_master_info', 
'healthid', 
'with pncmother as(
select * from rch_pnc_mother_master
where
	mother_id = (
		select id
	from
		imt_member
	where
		unique_health_id = #healthid#
	limit 1)
order by
	created_on desc
limit 5
), dangersign as (
	select danger.mother_pnc_id,
	string_agg(list.value, '', '') as dangersigndata
from
pncmother 
inner join 
	rch_pnc_mother_danger_signs_rel danger on 
	danger.mother_pnc_id = pncmother.id
inner join listvalue_field_value_detail list on
	danger.mother_danger_signs = list.id
group by
	danger.mother_pnc_id) ,
deathsign as (
	select death.mother_pnc_id,
	string_agg(list.value, '', '') as deathsigndata
from
pncmother 
inner join 
	rch_pnc_mother_death_reason_rel death on death.mother_pnc_id = pncmother.id
left join listvalue_field_value_detail list on
	death.mother_death_reason = list.id
group by
	death.mother_pnc_id) 
select
	pncmother.id as "pcnmotherid",
	pncmother.pnc_master_id as "pncMasterId",
	pncmother.mother_id as "motherId",
	pncmother.date_of_delivery as "dateOfDelivery",
	pncmaster.service_date as "serviceDate",
	pncmother.is_alive as "isAlive",
	pncmother.ifa_tablets_given as "ifaTabletsGiven",
	pncmother.other_danger_sign as "otherDangerSign",
	pncmother.referral_place as "referralPlace",
	pncmother.created_by as "createdBy",
	pncmother.created_on as "createdOn",
	pncmother.modified_by as "modifiedBy",
	pncmother.modified_on as "modifiedOn",
	pncmother.member_status as "memberStatus",
	pncmother.death_date as "deathDate",
	deathreason.value as "deathReason",
	pncmother.place_of_death as "placeOfDeath",
	pncmother.fp_insert_operate_date as "fpInsertOperateDate",
	pncmother.family_planning_method as "familyPlanningMethod",
	pncmother.other_death_reason as "otherDeathReason",
	pncmother.is_high_risk_case as "isHighRiskCase",
	pncmother.mother_referral_done as "motherReferralDone",
	pncmaster.family_id,
	pncmaster.latitude,
	pncmaster.longitude,
	pncmaster.mobile_start_date as "mobileStartDate",
	pncmaster.mobile_end_date as "mobileEndDate",
	pncmaster.location_id as "locationId",
	pncmaster.location_hierarchy_id as "locationHierarchyId",
	pncmaster.notification_id as "notificationId",
	pncmaster.pregnancy_reg_det_id as "pregnancyRegDetId",
	pncmaster.pnc_no as "pncNo",
	pncmaster.is_from_web as "isFromWeb",
	usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,
	usr.user_name as username,
	referralplace.value as referralplacename,
	fam.family_id as familyid,
	loc.name as locationname,
	danger.dangersigndata,
	death.deathsigndata
from
	pncmother
inner join rch_pnc_master pncmaster on
	pncmother.pnc_master_id = pncmaster.id
inner join imt_family fam on
	pncmaster.family_id = fam.id
left join location_master loc on
	pncmaster.location_id = loc.id
left join um_user usr on
	pncmother.created_by = usr.id
left join deathsign death on
	pncmother.id = death.mother_pnc_id
left join dangersign danger on
	pncmother.id = danger.mother_pnc_id
left join listvalue_field_value_detail referralplace on
	pncmother.referral_place = referralplace.id
left join listvalue_field_value_detail deathreason on
	pncmother.death_reason\:\:bigint = deathreason.id
order by
	pncmother.created_on desc;', 
'Retrieve RCH PNC Mother Master Information', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_pnc_child_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2c4e56e2-3528-4e30-a4b7-6679233cfc21', 75398,  current_date , 75398,  current_date , 'retrieve_rch_pnc_child_master_info', 
'healthid', 
'with pncchild as (
select
	*
from
	rch_pnc_child_master
where
	child_id = (
	select
		id
	from
		imt_member
	where
		unique_health_id = #healthid#
	limit 1)
order by
	created_on desc
limit 5 )
,dangersign as (
select
	danger.child_pnc_id,
	string_agg(list.value, '', '') as dangersigndata
from
pncchild
inner join 
	rch_pnc_child_danger_signs_rel danger on danger.child_pnc_id = pncchild.id
inner join listvalue_field_value_detail list on
	danger.child_danger_signs = list.id
group by
	danger.child_pnc_id) ,
deathsign as (
select
	death.child_pnc_id,
	string_agg(list.value, '', '') as deathsigndata
from
	rch_pnc_child_death_reason_rel death
left join listvalue_field_value_detail list on
	death.child_death_reason = list.id
group by
	death.child_pnc_id) select
	pncchild.id as "pncChildId",
	pncchild.pnc_master_id as "pncMasterId",
	pncchild.child_id as "childId",
	pncchild.is_alive as "isAlive",
	pncchild.other_danger_sign as "childOtherDanger",
	pncchild.child_weight as "childWeight",
	pncchild.created_by as "createdBy",
	pncchild.created_on as "createdOn",
	pncchild.modified_by as "modifiedBy",
	pncchild.modified_on as "modifiedOn",
	pncchild.member_status as "memberStatus",
	pncchild.death_date as "childDeathDate",
	pncchild.death_reason as "childDeathReason",
	pncchild.place_of_death as "childDeathPlace",
	pncchild.referral_place as "childReferralPlace",
	pncchild.other_death_reason as "childDeathOtherReason",
	pncchild.is_high_risk_case as "isHighRiskCase",
	pncchild.child_referral_done as "childReferralDone",
	pncmaster.family_id,
	pncmaster.latitude,
	pncmaster.longitude,
	pncmaster.mobile_start_date as "mobileStartDate",
	pncmaster.mobile_end_date as "mobileEndDate",
	pncmaster.location_id as "locationId",
	pncmaster.location_hierarchy_id as "locationHierarchyId",
	pncmaster.notification_id as "notificationId",
	pncmaster.pregnancy_reg_det_id as "pregnancyRegDetId",
	pncmaster.pnc_no as "pncNo",
	pncmaster.is_from_web as "isFromWeb",
	pncmaster.service_date as "serviceDate",
	usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,
	usr.user_name as username,
	referralplace.value as referralplacename,
	fam.family_id as familyid,
	loc.name as locationname,
	danger.dangersigndata,
	death.deathsigndata
from
	pncchild
left join rch_pnc_master pncmaster on
	pncchild.pnc_master_id = pncmaster.id
left join imt_family fam on
	pncmaster.family_id = fam.id
left join location_master loc on
	pncmaster.location_id = loc.id
left join um_user usr on
	pncchild.created_by = usr.id
left join deathsign death on
	pncchild.id = death.child_pnc_id
left join dangersign danger on
	pncchild.id = danger.child_pnc_id
left join listvalue_field_value_detail referralplace on
	pncchild.referral_place = referralplace.id
order by
	pncchild.created_on desc
limit 5', 
'Retrieve RCH PNC Child Master Information', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_pregnancy_registration_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'058013df-5435-4244-83e5-708a7569c0b8', 75398,  current_date , 75398,  current_date , 'retrieve_rch_pregnancy_registration_det', 
'healthid', 
'select 
preg.id as "pregId",preg.mthr_reg_no as "motherRegNo",preg.member_id,preg.lmp_date as "lmpDate",preg.edd as "expectedDeliveryDate",
preg.reg_date as "registrationDate",preg.state,preg.created_on as "createdOn",preg.created_by as "createdBy",preg.modified_on as "modifiedOn",
preg.modified_by as "modifiedBy",preg.location_id as "locationId",preg.family_id as "pregFamilyId",preg.current_location_id as "currLocationId",
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,fam.family_id as "familyId",
loc.name as locationname, curloc.name as currentlocationname
from rch_pregnancy_registration_det preg 
left join um_user usr on preg.created_by = usr.id
left join imt_family fam on preg.family_id = fam.id
left join location_master loc on preg.location_id = loc.id
left join location_master curloc on preg.current_location_id = curloc.id
where preg.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by preg.created_on desc limit 5', 
'Retrieve Pregnancy Registration Details', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_anc_information';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3073dcba-c8f8-4f94-9f25-aaa0c1588b17', 75398,  current_date , 75398,  current_date , 'retrieve_anc_information', 
'healthid', 
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
where anc.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by anc.created_on desc limit 5', 
'Retrieve RCH ANC Master Information', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_immunisation_master_by_health_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c08b1314-a55c-49af-a0ff-695b39096579', 75398,  current_date , 75398,  current_date , 'retrieve_rch_immunisation_master_by_health_id', 
'healthid', 
'select rim.* from rch_immunisation_master rim inner join imt_member im on im.id=rim.member_id 
where im.unique_health_id=#healthid# and
case when im.dob < current_date - interval ''5 years'' then rim.member_type = ''M''
else rim.member_type = ''C'' end;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_screening_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'183f9e41-b7a3-4855-96f3-fe811693b05b', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_screening_details_retrieve', 
'healthid', 
'select child_nutrition_sam_screening_master.id as "id",
service_date as "serviceDate",
height as "height",
weight as "weight",
muac as "muac",
have_pedal_edema as "oedema",
medical_complications_present as "medicalComplications",
breast_feeding_done as "breastFeedingDone",
breast_sucking_problems as "breastSuckingProblems",
sd_score as "sdScore",
appetite_test as "apetiteTest",
referral_done as "referralDone",
health_infrastructure_details.name_in_english as "referralHealthInfra",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "createdBy",
child_nutrition_sam_screening_master.created_on as "createdOn"
from child_nutrition_sam_screening_master
inner join um_user on child_nutrition_sam_screening_master.created_by = um_user.id
left join health_infrastructure_details on child_nutrition_sam_screening_master.referral_place = health_infrastructure_details.id
where member_id in (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_fsam_screening_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fc329dda-5edd-4f30-b988-9e4d8abd08ad', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_fsam_screening_details_retrieve', 
'healthid', 
'select child_cmtc_nrc_screening_detail.id as "caseId",
admission_id as "admissionId",
discharge_id as "dischargeId",
identified_from as "identifiedFrom",
case when is_case_completed then ''Yes'' else ''No'' end as "caseCompleted",
child_cmtc_nrc_screening_detail.created_on as "createdOn",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy"
from child_cmtc_nrc_screening_detail
inner join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
where child_id = (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_fsam_admission_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5fb4edc7-4af8-4d51-84d5-955e28231bee', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_fsam_admission_details_retrieve', 
'healthid', 
'select child_cmtc_nrc_admission_detail.id as "admissionId",
admission_date as "admissionDate",
case_id as "caseId",
weight_at_admission as "weightAtAdmission",
height as "height",
mid_upper_arm_circumference as "muac",
bilateral_pitting_oedema as "oedema",
sd_score as "sdScore",
apetite_test as "apetiteTest",
breast_feeding as "breastFeeding",
problem_in_breast_feeding as "problemInBreastFeeding",
problem_in_milk_injection as "problemInMilkInjection",
visible_wasting as "visibleWasting",
kmc_provided as "kmcProvided",
no_of_times_kmc_done as "noOfTimesKmcDone",
no_of_times_amoxicillin_given as "noOfTimesAmoxicillinGiven",
medical_officer_visit_flag as "medicalOfficerVisit",
specialist_pediatrician_visit_flag as "specialistPediatricianVisit",
defaulter_date as "defaulterDate",
health_infrastructure_details.name_in_english as "screeningCenter",
child_cmtc_nrc_admission_detail.created_on as "createdOn",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy"
from child_cmtc_nrc_admission_detail
inner join um_user on child_cmtc_nrc_admission_detail.created_by = um_user.id
inner join health_infrastructure_details on child_cmtc_nrc_admission_detail.screening_center = health_infrastructure_details.id
where child_id = (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_fsam_weight_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8dab6b96-c099-4ae7-92ea-d7391d17d0aa', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_fsam_weight_details_retrieve', 
'healthid', 
'select admission_id as "admissionId",
weight_date as "weightDate",
weight as "weight",
height as "height",
bilateral_pitting_oedema as "oedema",
formula_given as "formulaGiven",
is_mother_councelling as "motherCouncelling",
is_amoxicillin as "amoxicillin",
is_vitamina as "vitaminA",
is_albendazole as "albendazole",
is_folic_acid as "folicAcid",
is_potassium as "potassium",
is_magnesium as "magnesium",
is_zinc as "zinc",
is_iron as "iron",
other_higher_nutrients_given as "otherHigherNutrients",
multi_vitamin_syrup as "multiVitaminSyrup",
is_sugar_solution as "sugarSolution",
night_stay as "nightStay",
kmc_provided as "kmcProvided",
no_of_times_kmc_done as "noOfTimesKmcDone",
child_cmtc_nrc_weight_detail.created_on as "createdOn",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy"
from child_cmtc_nrc_weight_detail
inner join um_user on child_cmtc_nrc_weight_detail.created_by = um_user.id
where child_id = (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_fsam_discharge_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7d024d0c-8893-4497-98b4-b629db9f0fb8', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_fsam_discharge_details_retrieve', 
'healthid', 
'select child_cmtc_nrc_discharge_detail.id as "dischargeId",
child_cmtc_nrc_discharge_detail.discharge_date as "dischargeDate",
admission_id as "admissionId",
case_id as "caseId",
weight as "weight",
height as "height",
mid_upper_arm_circumference as "muac",
bilateral_pitting_oedema as "oedema",
sd_score as "sdScore",
kmc_provided as "kmcProvided",
no_of_times_kmc_done as "noOfTimesKmcDone",
discharge_status as "dischargeStatus",
child_cmtc_nrc_discharge_detail.created_on as "createdOn",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy"
from child_cmtc_nrc_discharge_detail
inner join um_user on child_cmtc_nrc_discharge_detail.created_by = um_user.id
where child_id = (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_fsam_follow_up_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ed8cc4bd-31aa-48b8-afc9-8da458020869', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_fsam_follow_up_details_retrieve', 
'healthid', 
'select child_cmtc_nrc_follow_up.id as "id",
admission_id as "admissionId",
case_id as "caseId",
follow_up_visit as "visitNo",
follow_up_date as "visitDate",
weight as "weight",
height as "height",
mid_upper_arm_circumference as "muac",
bilateral_pitting_oedema as "oedema",
sd_score as "sdScore",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy",
child_cmtc_nrc_follow_up.created_on as "createdOn"
from child_cmtc_nrc_follow_up
inner join um_user on child_cmtc_nrc_follow_up.created_by = um_user.id
where child_id in (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_cmam_admission_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3143010b-fbee-45c5-8570-790ccdb92f88', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_cmam_admission_details_retrieve', 
'healthid', 
'select child_nutrition_cmam_master.id as "id",
service_date as "serviceDate",
identified_from as "identifiedFrom",
cured_on as "curedOn",
cured_muac as "curedMuac",
case when is_case_completed is true then ''Yes'' else ''No'' end as "isCaseCompleted",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy",
child_nutrition_cmam_master.created_on as "createdOn"
from child_nutrition_cmam_master
inner join um_user on child_nutrition_cmam_master.created_by = um_user.id
where child_id in (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='help_desk_nutrition_cmam_follow_up_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'44ffea95-6179-4c5e-9f7c-663ddfdf475b', 75398,  current_date , 75398,  current_date , 'help_desk_nutrition_cmam_follow_up_details_retrieve', 
'healthid', 
'select child_nutrition_cmam_followup.id as "id",
cmam_master_id as "cmamMasterId",
service_date as "serviceDate",
weight as "weight",
height as "height",
muac as "muac",
given_sachets as "givenSachets",
consumed_sachets as "consumedSachets",
concat(um_user.first_name,'' '',um_user.last_name) as "createdBy",
child_nutrition_cmam_followup.created_on as "createdOn"
from child_nutrition_cmam_followup
inner join um_user on child_nutrition_cmam_followup.created_by = um_user.id
where member_id in (select id from imt_member where unique_health_id = #healthid#)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_name_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ae708090-2b0a-41b0-ae75-f801d4188092', 75398,  current_date , 75398,  current_date , 'helpdesk_name_search', 
'firstName,lastName,locationId', 
'with family_ids as (
	select family_id from imt_family
	where location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
),member_ids as(
	select id from imt_member
	where family_id in (select * from family_ids)
	and imt_member.first_name ilike concat(''%'',#firstName#,''%'') and imt_member.last_name ilike concat(''%'',#lastName#,''%'')
)
select m.id as memberid,
m.unique_health_id as uniquehealthid,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as membername,
m.family_head as familyhead,
m.is_pregnant as ispregnant,
m.gender as gender,
m.mobile_number as mobilenumber,
m.basic_state as memberbasicstate
from imt_member m where id in (select * from member_ids)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_user_login_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1763225a-07b2-48ac-9179-dcd1e0df8f0f', 75398,  current_date , 75398,  current_date , 'retrieve_user_login_details', 
'username', 
'select loginfo.imei_number as imeinumber, loginfo.apk_version as apkversion, loginfo.logging_from_web as loggingfromweb, loginfo.no_of_attempts as noofattempts,
to_char(loginfo.created_on, ''dd/mm/yyyy hh12:mi:ss'') as logindet  from um_user_login_det loginfo
left join um_user um on um.id = loginfo.user_id 
where um.user_name = #username# 
group by loginfo.created_on,loginfo.imei_number,loginfo.apk_version,loginfo.logging_from_web,loginfo.no_of_attempts  
order by loginfo.created_on 
desc limit 5', 
'Retrieve User Information using userName', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_information_of_user';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b5228870-2951-4c98-9d62-0bad36a3f1d2', 75398,  current_date , 75398,  current_date , 'retrieve_all_information_of_user', 
'username', 
'select 
um.contact_number as mobilenumber, 
um.email_id as emailid, um.first_name || '' '' || um.middle_name || '' '' || um.last_name as fullname,
um.gender, to_char(um.date_of_birth, ''dd/mm/yyyy'') as dateofbirth, um.user_name as username, um.state, um.title, um.techo_phone_number as techophonenumber,
loc.level as locationlevel, loc.state as areaofinterventionstate, 
rol.name as rolename, rol.state as rolestate,
string_agg(lm.name,''> '' order by lhcd.depth desc) as locationname, locname.state as locationstate
from um_user um
inner join um_user_location loc on loc.user_id = um.id and loc.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on loc.loc_id = lhcd.child_id
inner join location_master lm on lm.id = lhcd.parent_id
inner join um_role_master rol on um.role_id = rol.id
left join location_master locname on loc.loc_id = locname.id and locName.state = ''ACTIVE''
where um.user_name = #username#
group by um.aadhar_number, um.contact_number, um.email_id, um.first_name, um.middle_name, um.last_name,
um.gender, um.date_of_birth, um.user_name, um.state, um.title, um.techo_phone_number,
loc.level, loc.state,rol.name, rol.state, locname.state , lhcd.child_id limit 1', 
'Retrieve User Information using userName', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='remove_last_method_of_contraception';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'48a0b7c8-57e5-43fa-b766-977671a9f09a', 75398,  current_date , 75398,  current_date , 'remove_last_method_of_contraception', 
'reason_for_change,unique_health_id,loggedInUserId', 
'with insert_change_log_detail as (
insert into support_change_request_log(member_id,change_type,other_detail,reason_for_change,created_on)
select id as member_id,''REMOVE_LAST_METHOD_OF_CONTRACEPTION'',null,(case when ''null'' = #reason_for_change# then null else  #reason_for_change# end ),now() from imt_member
where unique_health_id = #unique_health_id# and last_method_of_contraception is not null
returning id
),update_imt_member as (
update imt_member set last_method_of_contraception = null,modified_on = now(),modified_by=#loggedInUserId# where  unique_health_id = #unique_health_id# and last_method_of_contraception is not null
returning id)
select cast(''Changes done'' as text) result from update_imt_member;', 
'', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_member_dob';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'20483f2d-5a84-4a94-900f-ed6c372b40bc', 75398,  current_date , 75398,  current_date , 'helpdesk_update_member_dob', 
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
	update imt_member set dob = #dob#, immunisation_given = null, modified_by = #loggedInUserId#, modified_on = current_timestamp
	from twin_brother_info where id = twin_brother_info.member_id
	returning id
)
, delete_immun as (
	delete from rch_immunisation_master where member_id in (select member_id from twin_brother_info) and member_type = ''C''
	returning id
)
, update_mobile_noti_child as (
	update event_mobile_notification_pending
	set base_date = #dob# ,	modified_by = #loggedInUserId#, modified_on = current_timestamp
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
	set date_of_delivery = #dob#,  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id in (select member_id from twin_brother_info)
	returning id
),
update_date_of_del_mother as (
	 update rch_wpd_mother_master
	set date_of_delivery = #dob#,  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id = (select member_id from preg_mother_id)
	returning id
),
update_mobile_noti_mother as (
	update event_mobile_notification_pending
	set base_date = #dob#, 	modified_by = #loggedInUserId#, modified_on = current_timestamp
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
set last_delivery_date = #dob#, modified_by = #loggedInUserId#, modified_on = current_timestamp
from member_dob,preg_mother_id
where mother.id = preg_mother_id.member_id
and to_char(mother.last_delivery_date, ''dd/mm/yyyy'') = to_char(member_dob.dob, ''dd/mm/yyyy'');', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_pregregdetails_reg_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'73f547e2-8f1a-4f19-884e-e73b0383f806', 75398,  current_date , 75398,  current_date , 'helpdesk_update_pregregdetails_reg_date', 
'regDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_pregnancy_registration_det'',row_to_json(lm) as data, #loggedInUserId# as user_id,''reg_date'',lm.id  from (select id,member_id,reg_date from rch_pregnancy_registration_det where id=#rchPregnancyRegistrationDetId#) lm;

update rch_pregnancy_registration_det set reg_date =#regDate#,modified_by = #loggedInUserId#,modified_on=now() where id=#rchPregnancyRegistrationDetId# and member_id=#memberId#;

update imt_member set cur_preg_reg_date=#regDate#,modified_by = #loggedInUserId#,modified_on = now() where cur_preg_reg_det_id   = #rchPregnancyRegistrationDetId# and id=#memberId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_pregregdetails_lmp_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3829a14f-022e-4488-9f8a-c6d1ef6f55ff', 75398,  current_date , 75398,  current_date , 'helpdesk_update_pregregdetails_lmp_date', 
'lmpDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''lmp'',lm.id  from (select id,lmp from imt_member where id=#memberId#) lm;

insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''rch_pregnancy_registration_det'',row_to_json(lm) as data, #loggedInUserId# as user_id,''lmp_date'',lm.id  from (select id,lmp_date from rch_pregnancy_registration_det where id=#rchPregnancyRegistrationDetId#) lm;

update rch_pregnancy_registration_det set lmp_date =#lmpDate#, edd = to_date(#lmpDate#, ''YYYY/MM/DD'') + interval ''281 days'',modified_by=#loggedInUserId#,modified_on=now() where id=#rchPregnancyRegistrationDetId# and member_id=#memberId#;

update imt_member set lmp = #lmpDate#, edd = to_date(#lmpDate#, ''YYYY/MM/DD'') + interval ''281 days'',modified_by=#loggedInUserId#,modified_on=now() WHERE id=#memberId# and cur_preg_reg_det_id=#rchPregnancyRegistrationDetId#;

update event_mobile_notification_pending set base_date =  #lmpDate# where member_id=#memberId# and state=''PENDING'' and ref_code =#rchPregnancyRegistrationDetId# and notification_configuration_type_id in (''5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a'',''faedb8e7-3e46-40a2-a9ac-ea7d5de944fa'');

delete from techo_notification_master where notification_type_id in (5,2) and member_id=#memberId# and state=''PENDING'' and ref_code =#rchPregnancyRegistrationDetId#;', 
null, 
false, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_immu_update_given_on';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8b34ae99-0cdf-4195-903d-ef856dbf2460', 75398,  current_date , 75398,  current_date , 'helpdesk_immu_update_given_on', 
'givenOn,rchImmuId,loggedInUserId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_immunisation_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''given_on'',lm.id  from (select id,member_id,given_on from rch_immunisation_master where id=#rchImmuId#) lm;

update rch_immunisation_master set given_on = #givenOn#,modified_by=#loggedInUserId#,modified_on=now() where id=#rchImmuId# and member_id= #memberId#;

update imt_member set immunisation_given = get_vaccination_string(id),modified_by=#loggedInUserId#,modified_on=now() where id = #memberId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_anc_service_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'02db8c3b-751e-4c38-a3c5-cd9f6b01a0c8', 75398,  current_date , 75398,  current_date , 'helpdesk_update_anc_service_date', 
'ancMasterId,serviceDate,loggedInUserId,rchPregnancyRegistrationDetId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code
)
select lm.member_id,''rch_anc_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_anc_master where id=#ancMasterId#) lm;

update rch_anc_master set service_date =#serviceDate#,modified_by=#loggedInUserId#,modified_on=now() where id=#ancMasterId# and member_id = #memberId#;

with service_dates as (
select string_agg(to_char(service_date,''dd/MM/yyyy''),'','' order by service_date) service_dates ,pregnancy_reg_det_id
from rch_anc_master where pregnancy_reg_det_id =#rchPregnancyRegistrationDetId# group by pregnancy_reg_det_id)
update imt_member im set anc_visit_dates  = sd.service_dates,modified_by=#loggedInUserId#,modified_on=now()
from service_dates sd where sd.pregnancy_reg_det_id = cur_preg_reg_det_id and im.id = #memberId#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_wpd_date_of_delivery';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'05ad3cdf-2cc5-4e8d-b06a-d04082e4a575', 75398,  current_date , 75398,  current_date , 'helpdesk_update_wpd_date_of_delivery', 
'dateOfDelivery,loggedInUserId,wpdMotherId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_wpd_mother_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''date_of_delivery'',lm.id  from (select id,member_id,date_of_delivery from rch_wpd_mother_master where id=#wpdMotherId#) lm;

update rch_wpd_mother_master set date_of_delivery  =#dateOfDelivery#,modified_by=#loggedInUserId#,modified_on=now() where id=#wpdMotherId#;

update rch_wpd_child_master set date_of_delivery = #dateOfDelivery#,modified_by=#loggedInUserId#,modified_on=now() where wpd_mother_id = #wpdMotherId#;

with wpd_childs as (
select * from rch_wpd_child_master where wpd_mother_id = #wpdMotherId# )
update imt_member im set dob=#dateOfDelivery#,modified_by=#loggedInUserId#,modified_on=now()
from wpd_childs wc where wc.member_id=im.id;


DELETE FROM rch_immunisation_master where member_type=''C'' and member_id in (
	select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#
);

update imt_member set immunisation_given = null,modified_by=#loggedInUserId#,modified_on=now() where id in (
select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#
);


update event_mobile_notification_pending  set base_date= #dateOfDelivery# where member_id=#memberId# and state=''PENDING'' and notification_configuration_type_id = ''9b1a331b-fac5-48f0-908e-ef545e0b0c52'';

delete from techo_notification_master where notification_type_id in (3) and member_id=#memberId# and state in (''PENDING'',''RESCHEDULE'');

delete from techo_notification_master where notification_type_id =4 and member_id
in(select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#)
and state in (''PENDING'',''RESCHEDULE'');

update event_mobile_notification_pending  set base_date= #dateOfDelivery# where
member_id in(select member_id from rch_wpd_child_master where wpd_mother_id = #wpdMotherId#)
and state=''PENDING''
and notification_configuration_type_id in (''f51c8c4f-6b2b-4dcb-8e64-ada1a3044a67'',''dfa2b7ee-0ae4-4d5e-bb8e-20252905ebc6'');', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_pnc_service_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'72fb2bc9-7238-46bd-bf2d-55af353b89c0', 75398,  current_date , 75398,  current_date , 'helpdesk_update_pnc_service_date', 
'serviceDate,pncMasterId,loggedInUserId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_pnc_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_pnc_master where id=#pncMasterId#) lm;

insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.mother_id,''rch_pnc_mother_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,mother_id,service_date from rch_pnc_mother_master where pnc_master_id=#pncMasterId#) lm;

update rch_pnc_master set service_date   =#serviceDate#,modified_by=#loggedInUserId#,modified_on=now() where id=#pncMasterId#; -- and member_id = #memberId#;

update rch_pnc_mother_master set service_date =#serviceDate#,modified_by=#loggedInUserId#,modified_on=now() where pnc_master_id=#pncMasterId#; -- and mother_id = #memberId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_child_service_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e005605d-e905-41a7-9c1b-5155c04514c9', 75398,  current_date , 75398,  current_date , 'helpdesk_update_child_service_date', 
'serviceDate,rchChildServiceMasterId,loggedInUserId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select lm.member_id,''rch_child_service_master'',row_to_json(lm) as data, #loggedInUserId# as user_id,''service_date'',lm.id  from (select id,member_id,service_date from rch_child_service_master where id=#rchChildServiceMasterId#) lm;

update rch_child_service_master set service_date = #serviceDate#,modified_by=#loggedInUserId#,modified_on=now() where id=#rchChildServiceMasterId# and member_id = #memberId#;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_wpd_mother_delivery_place';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a77b2a4b-e432-42bf-8f9b-135c94b5e0ce', 75398,  current_date , 75398,  current_date , 'helpdesk_update_wpd_mother_delivery_place', 
'healthInfrastructureId,typeOfHospital,id,userId,deliveryPlace', 
'INSERT INTO member_audit_log (member_id , table_name,  created_on , user_id, data , column_name, ref_code)
Values ((select member_id from rch_wpd_mother_master where id=#id# ), ''rch_wpd_mother_master'' , now() , #userId# , json_build_object(''id'',#id# , ''health_infrastructure_id'' , (select health_infrastructure_id from rch_wpd_mother_master where id= #id#) , ''type_of_hospital'' , (select type_of_hospital from rch_wpd_mother_master where id= #id#) ,''delivery_place'', (select rch_wpd_mother_master.delivery_place from rch_wpd_mother_master where id= #id# )) , ''health_infrastructure_id'' , #id#);

INSERT INTO member_audit_log  (member_id , table_name,  created_on , user_id, data , column_name, ref_code)
select member_id,''imt_member'' , now() , #userId# , json_build_object(''id'',member_id , ''place_of_birth'' , (select place_of_birth from imt_member where id = member_id)),''place_of_birth'', member_id from rch_wpd_child_master where wpd_mother_id = #id#;

update rch_wpd_mother_master set delivery_place = #deliveryPlace# , health_infrastructure_id = #healthInfrastructureId# , type_of_hospital = #typeOfHospital# , modified_on = now() , modified_by = #userId# where id = #id#;

update imt_member set place_of_birth = #deliveryPlace#,modified_by = #userId# , modified_on = now() where id IN (select member_id from rch_wpd_child_master where wpd_mother_id = #id# );', 
'Update Delivery Place', 
false, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_member_gender';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'16ca4d1f-b4a5-4a9f-8217-2c8383ba32d1', 75398,  current_date , 75398,  current_date , 'helpdesk_update_member_gender', 
'gender,loggedInUserId,memberId', 
'insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
select #memberId#,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''gender'',lm.id
  from (select id,gender from imt_member where id=#memberId#) lm;
update imt_member set gender =#gender#, modified_by = #loggedInUserId#, modified_on = now() where id=#memberId#;

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