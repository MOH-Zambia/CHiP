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
    case when ncd_member_mental_health_detail.talk is not null then CONCAT(
        '''',
        ncd_member_mental_health_detail.talk,
        ''/'',
        ncd_member_mental_health_detail.own_daily_work,
        ''/'',
        ncd_member_mental_health_detail.social_work,
        ''/'',
        ncd_member_mental_health_detail.understanding
    ) else ''N.A'' end as readings,
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