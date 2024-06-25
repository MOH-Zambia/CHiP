DELETE FROM QUERY_MASTER WHERE CODE='ncd_diabetes_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e710e3ca-a7e5-48e8-bdc0-67adab667fbe', 97080,  current_date , 97080,  current_date , 'ncd_diabetes_treatment_history',
'memberId',
'select * from (
select
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
union all
select
    cast(
        ncd_diabetes_confirmation_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_diabetes_confirmation_detail.done_by as "doneBy",
    CONCAT('''',ncd_diabetes_confirmation_detail.fasting_blood_sugar, '' mg/dl'')
	as readings,
''FBS'' as type,
    case
          when ncd_diabetes_confirmation_detail.fasting_blood_sugar>=126 then ''SUSPECTED''
          else ''NORMAL''
    end as "currentStatus",
	(select ncdd.earlier_diabetes_diagnosis from ncd_member_diabetes_detail ncdd
	 where ncdd.member_id=ncd_diabetes_confirmation_detail.member_id limit 1)
	as "diagnosedEarlier"
from
    ncd_diabetes_confirmation_detail
    inner join um_user on ncd_diabetes_confirmation_detail.created_by = um_user.id
where
	ncd_diabetes_confirmation_detail.fasting_blood_sugar is not null AND
    ncd_diabetes_confirmation_detail.member_id = #memberId#
group by
    ncd_diabetes_confirmation_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings,
	"diagnosedEarlier",
type
union all
select
    cast(
        ncd_diabetes_confirmation_detail.screening_date as date
    ) as "diagnosedOn",
    concat(
        um_user.first_name,
        '' '',
        um_user.middle_name,
        '' '',
        um_user.last_name
    ) as "diagnosedBy",
    ncd_diabetes_confirmation_detail.done_by as "doneBy",
    CONCAT('''',ncd_diabetes_confirmation_detail.post_prandial_blood_sugar, '' mg/dl'')
	as readings,
''PP2BS'' as type,
    case
          when ncd_diabetes_confirmation_detail.post_prandial_blood_sugar>=200 then ''SUSPECTED''
          else ''NORMAL''
    end as "currentStatus",
	(select ncdd.earlier_diabetes_diagnosis from ncd_member_diabetes_detail ncdd
	 where ncdd.member_id=ncd_diabetes_confirmation_detail.member_id limit 1)
	as "diagnosedEarlier"
from
    ncd_diabetes_confirmation_detail
    inner join um_user on ncd_diabetes_confirmation_detail.created_by = um_user.id
where
	ncd_diabetes_confirmation_detail.post_prandial_blood_sugar is not null AND
    ncd_diabetes_confirmation_detail.member_id = #memberId#
group by
    ncd_diabetes_confirmation_detail.screening_date,
    "diagnosedBy",
    "doneBy",
    "currentStatus",
    readings,
	"diagnosedEarlier",
type
) as confirm_table
order by
   "diagnosedOn" desc',
'To retrieve diabetes disease treatment history of patient.',
true, 'ACTIVE');