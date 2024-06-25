DELETE FROM QUERY_MASTER WHERE CODE='ncd_last_scheduled_visit_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3a825b81-755a-42a5-b9ea-7c7557a72ff7', 97080,  current_date , 97080,  current_date , 'ncd_last_scheduled_visit_details',
'memberId',
'with get_visits as (
 select member_id,location_id,screening_date,done_by,
	does_required_ref,refferral_reason,refferal_place,
	followup_place,followup_date
	from ncd_member_general_detail where member_id=#memberId#
	order by screening_date desc limit 1
)
select * from get_visits',
'Get data for follow up or reffered visits from mp visits.',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='ncd_patient_visit_history_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c6b8bc7e-ba12-49bf-aa4c-e121e59f75d0', 97080,  current_date , 97080,  current_date , 'ncd_patient_visit_history_by_member_id',
'memberId',
'WITH FirstMOVisitTest AS (
    SELECT
        member_id,
		visit_date,
		disease_code,
		status,
		reading,
		created_by,
		visit_by,
        ROW_NUMBER() OVER(PARTITION BY disease_code ORDER BY visit_date) AS rn
    FROM ncd_visit_history
    WHERE visit_by = ''MO'' and member_id=#memberId#
),
latest3VisitTest AS (
    SELECT
        member_id,
		visit_date,
		disease_code,
		status,
		reading,
		created_by,
		visit_by,
        ROW_NUMBER() OVER(PARTITION BY disease_code ORDER BY visit_date DESC) AS rn
    FROM ncd_visit_history
    WHERE member_id=#memberId# ORDER BY disease_code,visit_date desc
),
getBmi as (
	select weight,bmi,screening_date from ncd_member_hypertension_detail
	where member_id=#memberId#
	union all
	select weight,bmi,screening_date from ncd_member_initial_assessment_detail
	where member_id=#memberId#
),
test_data AS (
SELECT
fmvt.member_id,
fmvt.visit_date,
fmvt.disease_code,
fmvt.status,
fmvt.reading,
(select weight from getBmi order by screening_date desc limit 1),
(select bmi from getBmi order by screening_date desc limit 1),
concat(fmvt.visit_by,'': '',um_user.first_name,'' '',um_user.last_name)
 as "DiagnosedBy"
FROM FirstMOVisitTest fmvt
inner join um_user on fmvt.created_by = um_user.id
WHERE fmvt.rn = 1

UNION ALL

SELECT
    lvt.member_id,
	lvt.visit_date,
	lvt.disease_code,
	lvt.status,
	lvt.reading,
	(select weight from getBmi order by screening_date desc limit 1),
	(select bmi from getBmi order by screening_date desc limit 1),
	case when visit_by is not null
		then concat(lvt.visit_by,'': '',um_user.first_name,'' '',um_user.last_name)
		else concat(um_user.first_name,'' '',um_user.last_name)
		end "DiagnosedBy"
FROM latest3VisitTest lvt
inner join um_user on lvt.created_by = um_user.id
WHERE lvt.rn in (1,2,3)
)
select * from test_data',
null,
true, 'ACTIVE');