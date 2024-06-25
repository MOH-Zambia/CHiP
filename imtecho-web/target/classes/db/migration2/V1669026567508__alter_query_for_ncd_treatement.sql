DELETE FROM QUERY_MASTER WHERE CODE='ncd_initialAssessment_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c9b7b206-230d-494f-881a-468a392f56a8', 1,  current_date , 1,  current_date , 'ncd_initialAssessment_treatment_history',
'memberId',
'
select cast(ncd_member_initial_assessment_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_initial_assessment_detail
inner join ncd_member_referral on ncd_member_initial_assessment_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_initial_assessment_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_initial_assessment_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_initial_assessment_detail.member_id = #memberId#
group by ncd_member_initial_assessment_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_initial_assessment_detail.screening_date desc
',
'To retrieve initialAssessment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_mentalHealth_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c9b7b206-230d-494f-881a-468a392f56a0', 97070,  current_date , 97070,  current_date , 'ncd_mentalHealth_treatment_history',
'memberId',
'select cast(ncd_member_mental_health_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_mental_health_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_mental_health_detail
inner join ncd_master on ncd_member_mental_health_detail.master_id = ncd_master.id
inner join um_user on ncd_member_mental_health_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_mental_health_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_mental_health_detail.member_id = #memberId#
group by ncd_member_mental_health_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_mental_health_detail.status
order by ncd_member_mental_health_detail.screening_date desc',
'To retrieve mental health disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_hypertension_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6f2b3599-4c25-4eec-9df9-ddd899e7eb87', 97070,  current_date , 97070,  current_date , 'ncd_hypertension_treatment_history',
'memberId',
'select cast(ncd_member_hypertension_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_hypertension_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_hypertension_detail
inner join ncd_master on ncd_member_hypertension_detail.master_id = ncd_master.id
inner join um_user on ncd_member_hypertension_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_hypertension_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_hypertension_detail.member_id = #memberId#
group by ncd_member_hypertension_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_hypertension_detail.status
order by ncd_member_hypertension_detail.screening_date desc',
'To retrieve hypertension disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_general_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c9b7b206-230d-494f-881a-468a392f56a9', 1,  current_date , 1,  current_date , 'ncd_general_treatment_history',
'memberId',
'select cast(ncd_member_general_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''REFER_NO_VISIT'' then ''Referred No visit''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_general_detail
inner join ncd_member_referral on ncd_member_general_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_general_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_general_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_general_detail.member_id = #memberId#
group by ncd_member_general_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_general_detail.screening_date desc',
'To retrieve general detail history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_diabetes_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e710e3ca-a7e5-48e8-bdc0-67adab667fbe', 97070,  current_date , 97070,  current_date , 'ncd_diabetes_treatment_history',
'memberId',
'select cast(ncd_member_diabetes_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_diabetes_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_diabetes_detail
inner join ncd_master on ncd_member_diabetes_detail.master_id = ncd_master.id
inner join um_user on ncd_member_diabetes_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_diabetes_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_diabetes_detail.member_id = #memberId#
group by ncd_member_diabetes_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_diabetes_detail.status
order by ncd_member_diabetes_detail.screening_date desc',
'To retrieve diabetes disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_oral_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'79603a16-cdd4-4ff4-84e8-2a57aa318145', 97070,  current_date , 97070,  current_date , 'ncd_oral_treatment_history',
'memberId',
'select cast(ncd_member_oral_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_oral_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_oral_detail
inner join ncd_master on ncd_member_oral_detail.master_id = ncd_master.id
inner join um_user on ncd_member_oral_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_oral_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_oral_detail.member_id = #memberId#
group by ncd_member_oral_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_oral_detail.status
order by ncd_member_oral_detail.screening_date desc',
'To retrieve oral disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_cervical_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'797fe3f5-6c77-40ab-bc27-a95df3376f07', 97070,  current_date , 97070,  current_date , 'ncd_cervical_treatment_history',
'memberId',
'select cast(ncd_member_cervical_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_cervical_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_cervical_detail
inner join ncd_master on ncd_member_cervical_detail.master_id = ncd_master.id
inner join um_user on ncd_member_cervical_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_cervical_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_cervical_detail.member_id = #memberId#
group by ncd_member_cervical_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_cervical_detail.status
order by ncd_member_cervical_detail.screening_date desc',
'To retrieve cervical disease treatment history of patient.',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='ncd_breast_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9baf3293-0f79-48cb-932d-6559dade8b18', 97070,  current_date , 97070,  current_date , 'ncd_breast_treatment_history',
'memberId',
'select cast(ncd_member_breast_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
ncd_member_breast_detail.status as status,
string_agg(listvalue_field_value_detail.value,'', '') as "medicines"
from ncd_member_breast_detail
inner join ncd_master on ncd_member_breast_detail.master_id = ncd_master.id
inner join um_user on ncd_member_breast_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_breast_detail.id = ncd_member_disesase_medicine.reference_id
left join listvalue_field_value_detail on ncd_member_disesase_medicine.medicine_id = listvalue_field_value_detail.id
where ncd_member_breast_detail.member_id = #memberId#
group by ncd_member_breast_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_breast_detail.status
order by ncd_member_breast_detail.screening_date desc',
'To retrieve breast disease treatment history of patient.',
true, 'ACTIVE');