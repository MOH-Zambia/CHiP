alter table child_cmtc_nrc_discharge_detail
drop column if exists kmc_provided,
add column kmc_provided boolean,
drop column if exists no_of_times_kmc_done,
add column no_of_times_kmc_done integer;

delete from QUERY_MASTER where CODE='help_desk_nutrition_screening_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'183f9e41-b7a3-4855-96f3-fe811693b05b', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_screening_details_retrieve',
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
where member_id in (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_fsam_screening_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fc329dda-5edd-4f30-b988-9e4d8abd08ad', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_fsam_screening_details_retrieve',
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
where child_id = (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_fsam_admission_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5fb4edc7-4af8-4d51-84d5-955e28231bee', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_fsam_admission_details_retrieve',
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
where child_id = (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_fsam_weight_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8dab6b96-c099-4ae7-92ea-d7391d17d0aa', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_fsam_weight_details_retrieve',
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
where child_id = (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_fsam_discharge_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7d024d0c-8893-4497-98b4-b629db9f0fb8', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_fsam_discharge_details_retrieve',
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
where child_id = (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_fsam_follow_up_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ed8cc4bd-31aa-48b8-afc9-8da458020869', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_fsam_follow_up_details_retrieve',
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
where child_id in (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_cmam_admission_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3143010b-fbee-45c5-8570-790ccdb92f88', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_cmam_admission_details_retrieve',
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
where child_id in (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='help_desk_nutrition_cmam_follow_up_details_retrieve';

insert into public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'44ffea95-6179-4c5e-9f7c-663ddfdf475b', 60512,  current_date , 60512,  current_date , 'help_desk_nutrition_cmam_follow_up_details_retrieve',
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
where member_id in (select id from imt_member where unique_health_id = ''#healthid#'')',
null,
true, 'ACTIVE');