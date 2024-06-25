DELETE FROM QUERY_MASTER WHERE CODE='ncd_patient_visit_history_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c6b8bc7e-ba12-49bf-aa4c-e121e59f75d0', 97080,  current_date , 97080,  current_date , 'ncd_patient_visit_history_by_member_id',
'memberId',
'WITH
memberId AS (
select #memberId# as member_id
),
FirstMOVisitTest AS (
	SELECT member_id,
		visit_date,
		disease_code,
		status,
		reading,
		created_by,
		visit_by,
		ROW_NUMBER() OVER(
			PARTITION BY disease_code
			ORDER BY visit_date
		) AS rn
	FROM ncd_visit_history
	WHERE visit_by = ''MO''
		and member_id =  (select member_id from memberId)
),
latest3VisitTest AS (
	SELECT member_id,
		visit_date,
		disease_code,
		status,
		reading,
		created_by,
		visit_by,
		ROW_NUMBER() OVER(
			PARTITION BY disease_code
			ORDER BY visit_date DESC
		) AS rn
	FROM ncd_visit_history nvh
	WHERE NOT EXISTS (
			SELECT 1
			FROM FirstMOVisitTest fmvt
			WHERE nvh.member_id = fmvt.member_id
				AND nvh.visit_date = fmvt.visit_date
				AND nvh.status = fmvt.status
				AND nvh.reading = fmvt.reading
				AND nvh.visit_by = fmvt.visit_by
		)
		and member_id =  (select member_id from memberId)
	ORDER BY disease_code,
		visit_date desc
),
getBmi as (
	select member_id,
		weight,
		bmi,
		screening_date,
		''HT'' as disease_code
	from ncd_member_hypertension_detail
	where member_id =  (select member_id from memberId)
		and weight is not null
		and bmi is not null
	union all
	select member_id,
		weight,
		bmi,
		screening_date,
		''IA'' as disease_code
	from ncd_member_initial_assessment_detail
	where member_id =  (select member_id from memberId)
		and weight is not null
		and bmi is not null
	union all
	select member_id,
		weight,
		bmi,
		screening_date,
		''D'' as disease_code
	from ncd_member_diabetes_detail
	where member_id =  (select member_id from memberId)
		and weight is not null
		and bmi is not null
),
medicine_data as(
	select member_id,
		diagnosed_on,
		string_agg(
			concat(
				lfvd.value,
				'': '',
				nmdm.frequency,
				'' time(s) a day for '',
				nmdm.duration,
				'' day(s)''
			),
			''<br/>''
		) as medicines
	from ncd_member_disesase_medicine nmdm
		inner join listvalue_field_value_detail lfvd on nmdm.medicine_id = lfvd.id
	where member_id =  (select member_id from memberId)
	group by member_id,
		diagnosed_on
),
test_data AS (
	SELECT fmvt.member_id,
		fmvt.visit_date,
		fmvt.disease_code,
		fmvt.status,
		fmvt.reading,
		(
			select weight
			from getBmi
			where getBmi.member_id = fmvt.member_id
				and screening_date = fmvt.visit_date
				and disease_code = fmvt.disease_code
		),
		(
			select bmi
			from getBmi
			where getBmi.member_id = fmvt.member_id
				and screening_date = fmvt.visit_date
				and disease_code = fmvt.disease_code
		),
		concat(
			fmvt.visit_by,
			'': '',
			um_user.first_name,
			'' '',
			um_user.last_name
		) as "DiagnosedBy",
		case
			when md.medicines is not null then md.medicines
			else null
		end as medicines
	FROM FirstMOVisitTest fmvt
		inner join um_user on fmvt.created_by = um_user.id
		left join medicine_data md on md.member_id = fmvt.member_id
		and cast(md.diagnosed_on as date) = cast(fmvt.visit_date as date)
	WHERE fmvt.rn = 1
	UNION ALL
	SELECT lvt.member_id,
		lvt.visit_date,
		lvt.disease_code,
		lvt.status,
		lvt.reading,
		(
			select weight
			from getBmi
			where getBmi.member_id = lvt.member_id
				and screening_date = lvt.visit_date
				and disease_code = lvt.disease_code
		),
		(
			select bmi
			from getBmi
			where getBmi.member_id = lvt.member_id
				and screening_date = lvt.visit_date
				and disease_code = lvt.disease_code
		),
		case
			when visit_by is not null then concat(
				lvt.visit_by,
				'': '',
				um_user.first_name,
				'' '',
				um_user.last_name
			)
			else concat(um_user.first_name, '' '', um_user.last_name)
		end "DiagnosedBy",
		case
			when md.medicines is not null then md.medicines
			else null
		end as medicines
	FROM latest3VisitTest lvt
		inner join um_user on lvt.created_by = um_user.id
		left join medicine_data md on md.member_id = lvt.member_id
		and cast(md.diagnosed_on as date) = cast(lvt.visit_date as date)
	WHERE lvt.rn IN (1, 2, 3)
)
select *
from test_data',
null,
true, 'ACTIVE');