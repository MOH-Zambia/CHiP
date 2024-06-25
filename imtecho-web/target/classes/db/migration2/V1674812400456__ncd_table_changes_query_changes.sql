alter table if exists ncd_member_initial_assessment_detail
add column if not exists history_disease text;

alter table if exists ncd_member_initial_assessment_detail
add column if not exists other_disease text;

ALTER TABLE IF EXISTS ncd_member_hypertension_detail
DROP COLUMN IF EXISTS is_htn;

ALTER TABLE IF EXISTS ncd_member_diabetes_detail
DROP COLUMN IF EXISTS is_htn;

ALTER TABLE IF EXISTS ncd_member_mental_health_detail
DROP COLUMN IF EXISTS is_htn;

ALTER TABLE IF EXISTS ncd_member_oral_detail
DROP COLUMN IF EXISTS is_htn;

ALTER TABLE IF EXISTS ncd_member_breast_detail
DROP COLUMN IF EXISTS is_htn;

ALTER TABLE IF EXISTS ncd_member_cervical_detail
DROP COLUMN IF EXISTS is_htn;

DELETE FROM QUERY_MASTER WHERE CODE='ncd_mentalHealth_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c9b7b206-230d-494f-881a-468a392f56a0', 97070,  current_date , 97070,  current_date , 'ncd_mentalHealth_treatment_history',
'memberId',
'select
    cast(
        ncd_member_mental_health_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_mental_health_detail.done_by as "doneBy",
    CONCAT(
        '''',
        ncd_member_mental_health_detail.talk,
        ''/'',
        ncd_member_mental_health_detail.own_daily_work,
        ''/'',
        ncd_member_mental_health_detail.social_work,
        ''/'',
        ncd_member_mental_health_detail.understanding
    ) as readings,
    case
        when ncd_member_mental_health_detail.status is null then case
            when ncd_member_mental_health_detail.is_suffering is true then ''SUSPECTED''
            else ''NORMAL''
        end
        else replace(ncd_member_mental_health_detail.status, ''_'', '' '')
    end as "currentStatus",
	ncd_member_mental_health_detail.suffering_earlier as "diagnosedEarlier"
from
    ncd_member_mental_health_detail
    inner join ncd_master on ncd_member_mental_health_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_mental_health_detail.created_by = um_user.id
where
    ncd_member_mental_health_detail.member_id = #memberId#
group by
    ncd_member_mental_health_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings,
	"diagnosedEarlier"
order by
    ncd_member_mental_health_detail.screening_date desc',
'To retrieve mental health disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_hypertension_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6f2b3599-4c25-4eec-9df9-ddd899e7eb87', 97070,  current_date , 97070,  current_date , 'ncd_hypertension_treatment_history',
'memberId',
'select
    cast(
        ncd_member_hypertension_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_hypertension_detail.done_by as "doneBy",
    CONCAT(
        ncd_member_hypertension_detail.systolic_bp,
        ''/'',
        ncd_member_hypertension_detail.diastolic_bp
    ) as readings,
        case
        when ncd_member_hypertension_detail.status is null then case
            when ncd_member_hypertension_detail.is_suspected is true then ''SUSPECTED''
            else ''NORMAL''
        end
        else ncd_member_hypertension_detail.status
    end as "currentStatus",
	ncd_member_hypertension_detail.diagnosed_earlier as "diagnosedEarlier"
from
    ncd_member_hypertension_detail
    inner join ncd_master on ncd_member_hypertension_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_hypertension_detail.created_by = um_user.id
where
    ncd_member_hypertension_detail.member_id = #memberId#
group by
    ncd_member_hypertension_detail.screening_date,
  	"diagnosedBy",
  	"doneBy",
    "currentStatus",
    readings,
	"diagnosedEarlier"
order by
    ncd_member_hypertension_detail.screening_date desc',
'To retrieve hypertension disease treatment history of patient.',
true, 'ACTIVE');


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
	"diagnosedEarlier"
order by
    ncd_member_diabetes_detail.screening_date desc',
'To retrieve diabetes disease treatment history of patient.',
true, 'ACTIVE');