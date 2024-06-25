DELETE FROM QUERY_MASTER WHERE CODE='ncd_treatment_history_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e2cbb249-6232-4156-b02c-f9e1dd0f3b6a', 97067,  current_date , 97067,  current_date , 'ncd_treatment_history_by_member_id',
'limit,doneBy,memberId',
'with hypertension as (
    select
        ht.created_by,
        ht.screening_date,
        case
            when ht.status is null then case
                when ht.is_suspected is true then ''SUSPECTED''
                else ''NORMAL''
            end
            else replace(ht.status, ''_'', '' '')
        end as status,
        ''HT'' as disease_code,
        CONCAT(ht.systolic_bp, ''/'', ht.diastolic_bp) as readings
    from
        ncd_member_hypertension_detail ht
    where
        ht.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), diabetes as (
    select
        dd.created_by,
        dd.screening_date,
        case
            when dd.status is null then case
                when dd.is_suspected is true then ''SUSPECTED''
                else ''NORMAL''
            end
            else replace(dd.status, ''_'', '' '')
        end as status,
        ''D'' as disease_code,
        CONCAT('''', dd.blood_sugar) as readings
    from
        ncd_member_diabetes_detail dd
    where
        dd.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), mental_health as (
    select
        mh.created_by,
        mh.screening_date,
        case
            when mh.status is null then case
                when mh.is_suffering is true then ''SUSPECTED''
                else ''NORMAL''
            end
            else replace(mh.status, ''_'', '' '')
        end as status,
        ''MH'' as disease_code,
        CONCAT(
            '''',
            mh.talk,
            ''/'',
            mh.own_daily_work,
            ''/'',
            mh.social_work,
            ''/'',
            mh.understanding
        ) as readings
    from
        ncd_member_mental_health_detail mh
    where
        mh.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), initial_assessment as (
    select
        ia.created_by,
        ia.screening_date,
        null as status,
        ''IA'' as disease_code,
        CONCAT(
            '''',
            ia.weight,
            '' cm /'',
            ia.weight,
            '' kg /'',
            ia.bmi
        ) as readings
    from
        ncd_member_initial_assessment_detail ia
    where
        ia.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), oral as (
    select
        od.created_by,
        od.screening_date,
        replace(od.status, ''_'', '' '') as status,
        ''O'' as disease_code,
        array_to_string(
            array [
        case
            when od.ulcer is not null then ''Ulcer''
            else null
        end,
         case
            when od.growth_of_recent_origins is not null then ''Growth''
            else null
        end,
          case
            when od.lichen_planus is not null then ''Lichen Planus''
            else null
        end,
          case
            when od.smokers_palate is not null then ''Smokers palate''
            else null
        end,
          case
            when od.submucous_fibrosis is not null then ''Submucous fibrosis''
            else null
        end,
          case
            when od.red_patches is not null then ''Red Patches (Erythroplakia)''
            else null
        end,
          case
            when od.white_patches is not null then ''White Patches (Leukoplakia)''
            else null
        end,
          case
            when od.restricted_mouth_opening is not null then ''Restricted Mouth Opening (Locked Jaw)''
            else null
        end
   ],
            '',''
        ) as readings
    from
        ncd_member_oral_detail od
    where
        od.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), breast as (
    select
        bd.created_by,
        bd.screening_date,
        replace(bd.status, ''_'', '' '') as status,
        ''B'' as disease_code,
        array_to_string(
            array [
        case
            when bd.visual_ulceration is not null then ''Ulcer''
            else null
        end,
         case
            when bd.visual_lump_in_breast is not null then ''Lump in breasts''
            else null
        end,
          case
            when bd.visual_discharge_from_nipple is not null then ''Nipple Discharge''
            else null
        end,
          case
            when bd.visual_skin_retraction is not null then ''Retraction of skin''
            else null
        end,
          case
            when bd.visual_nipple_retraction_distortion is not null then ''Retraction of nipple''
            else null
        end,
          case
            when bd.visual_skin_dimpling_retraction is not null then ''Skin Dimpling/Puckering''
            else null
        end
   ],
            '',''
        ) as readings
    from
        ncd_member_breast_detail bd
    where
        bd.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), cervical as (
    select
        cd.created_by,
        cd.screening_date,
        replace(cd.status, ''_'', '' '') as status,
        ''C'' as disease_code,
        CONCAT(
            ''Bimanual Examination:- '',
            cd.bimanual_examination
        ) as readings
    from
        ncd_member_cervical_detail cd
    where
        cd.member_id = #memberId# and (#doneBy# is null or done_by =#doneBy#)
    order by
        screening_date desc
    limit
        #limit#
), details as (
    select
        *
    from
        hypertension
    union
    select
        *
    from
        diabetes
    union
    select
        *
    from
        mental_health
    union
    select
        *
    from
        initial_assessment
    union
    select
        *
    from
        oral
    union
    select
        *
    from
        breast
    union
    select
        *
    from
        cervical
    order by
        screening_date
)
select
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    details.screening_date as "diagnosedOn",
    details.readings,
    details.disease_code as "diseaseCode",
    details.status as "diagnosis"
from
    details
    inner join um_user on details.created_by = um_user.id
order by
    "diagnosedOn" desc',
'To retrieve all disease treatment history',
true, 'ACTIVE');

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
'c9b7b206-230d-494f-881a-468a392f56a0', 97067,  current_date , 97067,  current_date , 'ncd_mentalHealth_treatment_history',
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
    end as "currentStatus"
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
    readings
order by
    ncd_member_mental_health_detail.screening_date desc',
'To retrieve mental health disease treatment history of patient.',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='ncd_hypertension_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6f2b3599-4c25-4eec-9df9-ddd899e7eb87', 97067,  current_date , 97067,  current_date , 'ncd_hypertension_treatment_history',
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
    end as "currentStatus"
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
    readings
order by
    ncd_member_hypertension_detail.screening_date desc',
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
'e710e3ca-a7e5-48e8-bdc0-67adab667fbe', 97067,  current_date , 97067,  current_date , 'ncd_diabetes_treatment_history',
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
    end as "currentStatus"
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
    readings
order by
    ncd_member_diabetes_detail.screening_date desc',
'To retrieve diabetes disease treatment history of patient.',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='ncd_oral_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'79603a16-cdd4-4ff4-84e8-2a57aa318145', 97067,  current_date , 97067,  current_date , 'ncd_oral_treatment_history',
'memberId',
'select
    cast(ncd_member_oral_detail.screening_date as date) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_oral_detail.done_by as "doneBy",
    array_to_string(
        array [
        case
            when ncd_member_oral_detail.ulcer is not null then ''Ulcer''
            else null
        end,
         case
            when ncd_member_oral_detail.growth_of_recent_origins is not null then ''Growth''
            else null
        end,
          case
            when ncd_member_oral_detail.lichen_planus is not null then ''Lichen Planus''
            else null
        end,
          case
            when ncd_member_oral_detail.smokers_palate is not null then ''Smokers palate''
            else null
        end,
          case
            when ncd_member_oral_detail.submucous_fibrosis is not null then ''Submucous fibrosis''
            else null
        end,
          case
            when ncd_member_oral_detail.red_patches is not null then ''Red Patches (Erythroplakia)''
            else null
        end,
          case
            when ncd_member_oral_detail.white_patches is not null then ''White Patches (Leukoplakia)''
            else null
        end,
          case
            when ncd_member_oral_detail.restricted_mouth_opening is not null then ''Restricted Mouth Opening (Locked Jaw)''
            else null
        end
   ],
        '',''
    ) as readings,
    replace(ncd_member_oral_detail.status, ''_'', '' '') as "currentStatus"
from
    ncd_member_oral_detail
    inner join ncd_master on ncd_member_oral_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_oral_detail.created_by = um_user.id
where
    ncd_member_oral_detail.member_id = #memberId#
group by
    ncd_member_oral_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings
order by
    ncd_member_oral_detail.screening_date desc',
'To retrieve oral disease treatment history of patient.',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='ncd_cervical_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'797fe3f5-6c77-40ab-bc27-a95df3376f07', 97067,  current_date , 97067,  current_date , 'ncd_cervical_treatment_history',
'memberId',
'select
    cast(
        ncd_member_cervical_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_cervical_detail.done_by as "doneBy",
    CONCAT(
        ''Bimanual Examination:- '',
        ncd_member_cervical_detail.bimanual_examination
    ) as readings,
    replace(ncd_member_cervical_detail.status, ''_'', '' '') as "currentStatus"
from
    ncd_member_cervical_detail
    inner join ncd_master on ncd_member_cervical_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_cervical_detail.created_by = um_user.id
where
    ncd_member_cervical_detail.member_id = #memberId#
group by
    ncd_member_cervical_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings
order by
    ncd_member_cervical_detail.screening_date desc',
'To retrieve cervical disease treatment history of patient.',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='ncd_breast_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9baf3293-0f79-48cb-932d-6559dade8b18', 97067,  current_date , 97067,  current_date , 'ncd_breast_treatment_history',
'memberId',
'select
    cast(ncd_member_breast_detail.screening_date as date) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_member_breast_detail.done_by as "doneBy",
    array_to_string(
        array [
        case
            when ncd_member_breast_detail.visual_ulceration is not null then ''Ulcer''
            else null
        end,
         case
            when ncd_member_breast_detail.visual_lump_in_breast is not null then ''Lump in breasts''
            else null
        end,
          case
            when ncd_member_breast_detail.visual_discharge_from_nipple is not null then ''Nipple Discharge''
            else null
        end,
          case
            when ncd_member_breast_detail.visual_skin_retraction is not null then ''Retraction of skin''
            else null
        end,
          case
            when ncd_member_breast_detail.visual_nipple_retraction_distortion is not null then ''Retraction of nipple''
            else null
        end,
          case
            when ncd_member_breast_detail.visual_skin_dimpling_retraction is not null then ''Skin Dimpling/Puckering''
            else null
        end
   ],
        '',''
    ) as readings,
    replace(ncd_member_breast_detail.status, ''_'', '' '') as "currentStatus"
from
    ncd_member_breast_detail
    inner join ncd_master on ncd_member_breast_detail.master_id = ncd_master.id
    inner join um_user on ncd_member_breast_detail.created_by = um_user.id
where
    ncd_member_breast_detail.member_id = #memberId#
group by
    ncd_member_breast_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings
order by
    ncd_member_breast_detail.screening_date desc',
'To retrieve breast disease treatment history of patient.',
true, 'ACTIVE');