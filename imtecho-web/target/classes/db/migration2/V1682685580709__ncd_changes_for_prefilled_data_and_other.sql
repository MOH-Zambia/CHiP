Alter table if exists ncd_member_hypertension_detail
add column if not exists pedal_oedema boolean;

Alter table if exists ncd_member_diabetes_detail
add column if not exists weight integer,
add column if not exists height integer,
add column if not exists bmi integer;


DELETE FROM QUERY_MASTER WHERE CODE='ncd_diabetes_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e710e3ca-a7e5-48e8-bdc0-67adab667fbe', 97070,  current_date , 97070,  current_date , 'ncd_diabetes_treatment_history',
'memberId',
'select
    cast(
        ncd_member_diabetes_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_diabetes_detail.done_by as "doneBy",
    CONCAT('''', ncd_member_diabetes_detail.blood_sugar, '' mg/dl'') as readings,
ncd_member_diabetes_detail.measurement_type as type,
    case
        when ncd_member_diabetes_detail.status is null then case
            when ncd_member_diabetes_detail.is_suspected is true then ''SUSPECTED''
            else ''NORMAL''
        end
        else ncd_member_diabetes_detail.status
    end as "currentStatus",
	ncd_member_diabetes_detail.earlier_diabetes_diagnosis as "diagnosedEarlier"
from
    ncd_member_diabetes_detail
    inner join ncd_master on ncd_member_diabetes_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_diabetes_detail.created_by = um_user.id
where
    ncd_member_diabetes_detail.member_id = #memberId#
group by
    ncd_member_diabetes_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings,
	"diagnosedEarlier",
measurement_type
order by
    ncd_member_diabetes_detail.screening_date desc',
'To retrieve diabetes disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_fetch_confirmed_diseases';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a6688c27-8cf9-4a07-a3ec-a4b45d469b08', 97070,  current_date , 97070,  current_date , 'ncd_fetch_confirmed_diseases',
'memberId',
'select string_agg(distinct disease_code,'','') as diseases from ncd_master where member_id=#memberId#
and status not in (''NORMAL'',''SUSPECTED'') and disease_code not in (''IA'',''G'')',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_initial_assessment_prefilled_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'557f12cb-9e90-4cd2-a118-f4b51c204190', 97070,  current_date , 97070,  current_date , 'ncd_initial_assessment_prefilled_data',
'memberId',
'with ht_data as(select member_id,screening_date,weight,height,bmi,waist from ncd_member_hypertension_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null or waist is not null) order by created_on desc limit 1),
init_data as(select member_id,screening_date,weight,height,bmi,waist_circumference from ncd_member_initial_assessment_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null or waist_circumference is not null) order by created_on desc limit 1),
db_data as(select member_id,screening_date,weight,height,bmi,null from ncd_member_diabetes_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null) order by created_on desc limit 1)
select ht_data.member_id,
(case when ht_data.screening_date>init_data.screening_date and ht_data.screening_date>db_data.screening_date and ht_data.weight is not null then ht_data.weight
 when db_data.screening_date>init_data.screening_date and db_data.screening_date>ht_data.screening_date and db_data.weight is not null then db_data.weight
else init_data.weight end) as weight,
(case when ht_data.screening_date>init_data.screening_date and ht_data.screening_date>db_data.screening_date and ht_data.height is not null then ht_data.height
 when db_data.screening_date>init_data.screening_date and db_data.screening_date>ht_data.screening_date and db_data.height is not null then db_data.height
else init_data.height end) as height,
(case when ht_data.screening_date>init_data.screening_date and ht_data.screening_date>db_data.screening_date and ht_data.bmi is not null then ht_data.bmi
 when db_data.screening_date>init_data.screening_date and db_data.screening_date>ht_data.screening_date and db_data.bmi is not null then db_data.bmi
else init_data.bmi end) as bmi,
(case when ht_data.screening_date>init_data.screening_date and ht_data.waist is not null then ht_data.waist
else init_data.waist_circumference end) as waist
from init_data
left join ht_data on ht_data.member_id=init_data.member_id
left join db_data on ht_data.member_id=db_data.member_id',
null,
true, 'ACTIVE');