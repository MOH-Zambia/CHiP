DELETE FROM QUERY_MASTER WHERE CODE='ncd_moreview_patient_disease_summary_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'35e51d0d-72c1-4bad-b37c-33a776ff6f58', 97080,  current_date , 97080,  current_date , 'ncd_moreview_patient_disease_summary_data',
'memberId',
'with disease_type AS (
    SELECT
        imm.id as member_id,
        (CASE WHEN nmrm.disease_code != ''G'' THEN nmrm.disease_code END) AS disease,
        nmrm.type AS type,
		nm.status AS status
    FROM ncd_mo_review_members nmrm
    INNER JOIN imt_member imm ON nmrm.member_id = imm.id
	LEFT JOIN ncd_master nm ON nm.member_id = nmrm.member_id AND nm.disease_code = nmrm.disease_code
    WHERE imm.basic_state IN (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
		AND nmrm.member_id=#memberId#
),
treatment_status as (
	select
		member_id,
		disease,
		(CASE WHEN disease = ''HT''
		 	  THEN (select treatment_status
			  from ncd_member_hypertension_detail
			  where member_id=#memberId# order by id desc limit 1)
		  WHEN disease = ''MH''
		 	  THEN (select treatment_status
			  from ncd_member_mental_health_detail
			  where member_id=#memberId# order by id desc limit 1)
		  WHEN disease = ''B''
		 	  THEN (select treatment_status
			  from ncd_member_breast_detail
			  where member_id=#memberId# order by id desc limit 1)
		  WHEN disease = ''C''
		 	  THEN (select treatment_status
			  from ncd_member_cervical_detail
			  where member_id=#memberId# order by id desc limit 1)
		  WHEN disease = ''O''
		 	  THEN (select treatment_status
			  from ncd_member_oral_detail
			  where member_id=#memberId# order by id desc limit 1)
		 WHEN disease = ''D''
		 	  THEN (select treatment_status
			  from ncd_member_diabetes_detail
			  where member_id=#memberId# order by id desc limit 1)
		 WHEN disease = ''G''
		 	  THEN (select treatment_status
			  from ncd_member_general_detail
			  where member_id=#memberId# order by id desc limit 1)
		 END) AS treatment_status
	from
	disease_type
),
check_bpl as (
select ROW_NUMBER () OVER () as row_no,imf.bpl_flag as is_bpl from imt_member im
 inner join imt_family imf
	on imf.family_id=im.family_id
	where im.id=#memberId#
),
treatment_compliant_trial as(
select
	coalesce(patient_taking_medicine,false) as ptm,
	created_on
from ncd_member_home_visit_detail where member_id=#memberId#
union all
select
	coalesce(patient_taking_medicine,false) as ptm,
	created_on
from ncd_member_clinic_visit_detail where member_id=#memberId#
),
treatment_compliant as (
	select ROW_NUMBER () OVER () as row_no,ptm from treatment_compliant_trial
	ORDER BY created_on DESC limit 1
)
SELECT
	dt.disease as disease,
	dt.type as type,
	dt.status as status,
	ts.treatment_status,
	cb.is_bpl as is_bpl,
	tc.ptm as regular_medicine_intake
	from disease_type dt
	inner join treatment_status ts on ts.member_id=dt.member_id
		and ts.disease=dt.disease
	cross join check_bpl cb
	left join treatment_compliant tc on tc.row_no=cb.row_no',
'Get Data for Patient and his diseases Summary displayed On Mo Review Screen',
true, 'ACTIVE');