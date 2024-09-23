
drop function if exists public.get_all_health_infra;

CREATE OR REPLACE FUNCTION get_all_health_infra()
RETURNS TABLE (
    facility_id INT,
    faciliy_name VARCHAR,
    district_name VARCHAR,
    provice_name VARCHAR,
    mfl_facility_id INT,
    dhis2_facility_id TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT hid.id as facility_id, hid.name as faciliy_name,
    (select name from location_master where id = (select parent_id from location_hierchy_closer_det
    where child_id = hid.location_id and parent_loc_type = 'D')) as district_name,
    (select name from location_master where id = (select parent_id from location_hierchy_closer_det
    where child_id = hid.location_id and parent_loc_type = 'P')) as province_name,
    hid.mfl_code AS mfl_facility_id,
    cast(hid.dhis2_uid as text) AS dhis2_facility_id
    FROM
health_infrastructure_details hid;
END;
$$ LANGUAGE plpgsql;


drop function if exists public.get_monthly_report;

CREATE OR REPLACE FUNCTION get_monthly_report(
    p_month_end_date DATE,
    p_facility_id INT
)
RETURNS TABLE (
    month_ending DATE,
    facility_id INT,
    facility_name text,
    indicator_id text,
    indicator_name text,
    indicator_value text,
    dhis2_indicator_id INT,
    dhis2_facility_id text
) AS $$

DECLARE
    v_user_id INT;
	hid_name text;
	dhis_id text;
BEGIN

	SELECT u.id, hid.name, hid.dhis2_uid  INTO v_user_id, hid_name, dhis_id
    FROM um_user u
	INNER JOIN um_user_location ul on u.id = ul.user_id
	INNER JOIN health_infrastructure_details hid on hid.location_id = ul.loc_id
    WHERE hid.id = p_facility_id;

    RETURN QUERY
    WITH hiv_indicators AS (
        SELECT
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhkm.member_id IS NULL) AS chw6_01,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.tested_for_hiv_in_12_months) AS chw6_02,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.hiv_test_result) AS chw6_03,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.referral_place IS NOT NULL AND rhsm.tested_for_hiv_in_12_months = FALSE) AS chw6_04,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.hiv_test_result AND rhsm.child_currently_on_art = FALSE) AS chw6_05,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.child_currently_on_art) AS chw6_06,
            COUNT(DISTINCT rhsm.*) FILTER (WHERE rhsm.referral_place IS NOT NULL AND rhsm.tested_for_hiv_in_12_months) AS chw6_07
        FROM rch_hiv_screening_master rhsm
        LEFT JOIN rch_hiv_known_master rhkm ON rhkm.member_id = rhsm.member_id
        WHERE DATE(rhsm.created_on) >= DATE(p_month_end_date)
		and rhsm.created_by = cast(v_user_id as integer)
    ), tb_indicators AS (
        SELECT
            COUNT(*) FILTER (WHERE is_tb_suspected) AS chw4_01,
            COUNT(*) FILTER (WHERE is_patient_taking_medicines) AS chw4_02,
            COUNT(*) FILTER (WHERE is_tb_suspected AND is_patient_taking_medicines = FALSE) AS chw4_03,
            COUNT(*) FILTER (WHERE is_tb_suspected AND form_type = 'TB_SCREENING') AS chw4_05
        FROM tuberculosis_screening_details
        WHERE DATE(created_on) >= DATE(p_month_end_date)
		and created_by = cast(v_user_id as integer)
    ), family_indicators AS (
        SELECT
            COUNT(*) AS chw1_01,
            COUNT(*) AS chw1_03,
            COUNT(*) FILTER (WHERE type_of_toilet IS NOT NULL OR other_toilet IS NOT NULL) AS chw8_01,
            COUNT(*) FILTER (WHERE drinking_water_source IS NOT NULL OR other_water_source IS NOT NULL) AS chw8_02,
            COUNT(*) FILTER (WHERE handwash_available) AS chw8_03,
            COUNT(*) FILTER (WHERE waste_disposal_method IS NOT NULL) AS chw8_04
        FROM imt_family
        WHERE DATE(created_on) >= DATE(p_month_end_date)
		and created_by = cast(v_user_id as integer)
    ), malaria_indicators AS (
		select
			count(*) as chw5_01,
			count(*) filter (where rdt_test_status = 'POSITIVE') as chw5_02,
			count(*) filter (where is_treatment_being_given) as chw5_03,
			count(*) filter (where referral_place is not null) as chw5_04,
			count(*) filter (where malaria_type = 'PASSIVE') as chw5_05,
			count(*) filter (where having_travel_history) as chw5_06
		from malaria_details
		where date(created_on) >= date(p_month_end_date)
		and created_by = cast(v_user_id as integer)
	),
	pregnancy_indicators AS (
		select
			count(*) filter (where date(reg_date) >= date(p_month_end_date)) as chw2_02,
			count(*) as chw2_04
		from rch_pregnancy_registration_det
		where created_by = cast(v_user_id as integer)
		and state != 'MARK_AS_WRONGLY_PREGNANT'
	), anc_indicators AS (
        with multiple_visits as (
			select
				count(ram.*) as anc_count
			from rch_anc_master ram
			where date(ram.service_date) >= date(p_month_end_date)
			and ram.created_by = cast(v_user_id as integer)
			group by ram.pregnancy_reg_det_id
			having count(*) > 2
		)
		select
			count(ram.*) filter (where date(ram.service_date) >= date(p_month_end_date) and (select count(*) from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
			(select count(*) from multiple_visits) as chw2_05,
			count(ram.*) filter (where date(ram.service_date) >= date(p_month_end_date)) as chw2_06,
			count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval '28 weeks' and date(ram.service_date) >= date(p_month_end_date)) as chw2_10,
			count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval '28 weeks' and ram.having_birth_plan and date(ram.service_date) >= date(p_month_end_date)) as chw2_11,
			count(ram.*) filter (where dangerous_sign_id is not null or other_dangerous_sign is not null and date(ram.service_date) >= date(p_month_end_date)) as chw2_13
		from rch_anc_master ram
		inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
    ), pnc_indicators AS (
        SELECT
            COUNT(DISTINCT rpm.*) FILTER (WHERE rpm.delivery_place = 'HOME') AS chw2_14,
            COUNT(DISTINCT rpm.*) FILTER (WHERE rpm.delivery_place = 'HOSP') AS chw2_15,
            COUNT(DISTINCT rpm.*) FILTER (WHERE rpm.delivery_place IS NOT NULL) AS chw2_16,
            COUNT(DISTINCT rpm.*) AS chw2_17,
            COUNT(DISTINCT rpmm.mother_id) AS chw2_18,
            COUNT(DISTINCT rpmm.mother_id) FILTER (WHERE rpmm.other_danger_sign IS NOT NULL) AS chw2_23
        FROM rch_pnc_master rpm
        LEFT JOIN rch_pnc_mother_master rpmm ON rpm.id = rpmm.pnc_master_id
        WHERE DATE(rpm.service_date) >= DATE(p_month_end_date)
		and rpm.created_by = cast(v_user_id as integer)
    ), child_service_indicators AS (
        SELECT
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = 'Diarrhea' AND rcsm.is_treatement_done = 'YES') AS chw3_03,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = 'Diarrhea' AND rcsm.referral_place IS NOT NULL AND lfvd.value = 'Danger signs') AS chw3_04,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = 'Pneumonia' AND rcsm.is_treatement_done = 'YES') AS chw3_05,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = 'Pneumonia' AND rcsm.referral_place IS NOT NULL AND lfvd.value = 'Danger signs') AS chw3_06,
            COUNT(DISTINCT rcsm.*) FILTER (WHERE rcsm.delay_in_developmental) AS chw3_08
        FROM rch_child_service_master rcsm
        LEFT JOIN listvalue_field_value_detail lfvd ON CAST(rcsm.referral_reason AS INTEGER) = lfvd.id
        LEFT JOIN rch_child_service_diseases_rel rcsdr ON rcsm.id = rcsdr.child_service_id
        LEFT JOIN listvalue_field_value_detail lfvd2 ON rcsdr.diseases = lfvd2.id
        WHERE DATE(rcsm.service_date) >= DATE(p_month_end_date)
		and rcsm.created_by = cast(v_user_id as integer)
    ), wpd_indicators AS (
		select
			count(rwcm.*) filter (where rwmm.delivery_place in ('HOME','ON_THE_WAY')) as chw2_21,
			count(distinct rwmm.*) filter (where (select count(*) from rch_anc_master where pregnancy_reg_det_id = rwmm.pregnancy_reg_det_id) >= 4) as chw2_22,
			count(distinct rwmm.*) filter (where rwmm.death_date is not null and rwmm.delivery_place in ('HOME','ON_THE_WAY')) as chw2_24,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = 'LBIRTH' and rwmm.delivery_place in ('HOME','ON_THE_WAY')) as chw2_25,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = 'LBIRTH' and rwmm.delivery_place = 'HOSP') as chw2_26,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = 'LBIRTH') as chw2_27,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = 'LBIRTH' and rwmm.is_preterm_birth) as chw2_28,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = 'SBIRTH' and rwmm.delivery_place in ('HOME','ON_THE_WAY')) as chw2_29,
			count(rwcm.*) filter (where rwcm.referral_done = 'YES' and rwcm.other_danger_sign is not null) as chw2_30
		from rch_wpd_mother_master rwmm
		left join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id
		where date(rwmm.date_of_delivery) >= date(p_month_end_date)
		and rwmm.created_by = cast(v_user_id as integer)
	), cross_join_cte as (
		select hiv_ind.*, tb_ind.*, malaria_ind.*, family_ind.*, preg_ind.*, anc_ind.*, pnc_ind.*, child_ind.*, wpd_ind.*
		from hiv_indicators hiv_ind
    	cross JOIN tb_indicators tb_ind
		cross JOIN malaria_indicators malaria_ind
	    cross JOIN family_indicators family_ind
		cross JOIN pregnancy_indicators preg_ind
		cross JOIN anc_indicators anc_ind
		cross JOIN pnc_indicators pnc_ind
		cross JOIN child_service_indicators child_ind
		cross JOIN wpd_indicators wpd_ind
	)
	SELECT p_month_end_date, p_facility_id, hid_name, 'chw1_01', 'First Household Visits', cast(chw1_01 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw1_02', 'Follow Up Household Visits', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw1_03', 'Total Household Visits', cast(chw1_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw1_04', 'Number of Client Contacts', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_01', 'Provided Modern FP', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_02', 'New Pregnancies', cast(chw2_02 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_03', 'Follow up this month', cast(chw2_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_04', 'Total Pregnant Women', cast(chw2_04 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_05', 'ANC met 2+ this month', cast(chw2_05 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_06', 'Total ANC contacts', cast(chw2_06 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_07', 'New - seen less than 3 mths GA', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_08', 'New Pregnancies - already visited facility', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_09', 'New Pregnancies at facility in 1st trimester', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_10', 'ANC women with 28+ weeks pregnancies', cast(chw2_10 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_11', 'ANC women with birth plan of from 28 weeks', cast(chw2_11 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_12', 'Up-to-date with ANC visits', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_13', 'ANC women with danger signs', cast(chw2_13 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_14', 'New home deliveries', cast(chw2_14 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_15', 'New facility deliveries', cast(chw2_15 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_16', 'New deliveries this month', cast(chw2_16 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_17', 'PNC follow-ups this month', cast(chw2_17 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_18', 'Total PNC women', cast(chw2_18 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_19', 'PNC met this month prior', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_20', 'Total PNC contacts', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_21', 'New home deliveries - visited within 48 hrs', cast(chw2_21 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_22', 'New deliveries - Visited at least 4 times in ANC', cast(chw2_22 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_23', 'PNC cases with danger', cast(chw2_23 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_24', 'Maternal(home) deaths', cast(chw2_24 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_25', 'Livebirth - Home', cast(chw2_25 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_26', 'Livebirth - Facility', cast(chw2_26 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_27', 'Total Livebirths', cast(chw2_27 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_28', 'Livebirth - Preterm', cast(chw2_28 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_29', 'Stillbirths(home)', cast(chw2_29 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_30', 'Referred with danger signs', cast(chw2_30 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_31', 'Neonatal deaths(home)', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw2_32', 'Neonatal infants visited', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_01', 'Up to date with vaccinations', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_02', 'Children 24 months and below', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_03', 'Treated for diarrhoea', cast(chw3_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_04', 'Referred for diarrhoea', cast(chw3_04 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_05', 'Treated for pneumonia', cast(chw3_05 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_06', 'Referred for pneumonia', cast(chw3_06 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_07', 'Under 5(home) death', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_08', 'Delayed development', cast(chw3_08 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_09', 'On EBF less than 6 months', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_10', 'Infant aged less than 6 months', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_11', 'Severely malnourished', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_12', 'Moderately malnourished', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_13', 'Not growing well', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw3_14', 'Number of under-five children visited', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw4_01', 'Suspected with TB', cast(chw4_01 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw4_02', 'On TB treatment', cast(chw4_02 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw4_03', 'Not active on TB care', cast(chw4_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw4_04', 'Contact traced', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw4_05', 'Newly confirmed TB cases', cast(chw4_05 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_01', 'Tested', cast(chw5_01 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_02', 'Positive test result', cast(chw5_02 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_03', 'Treated', cast(chw5_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_04', 'Referred', cast(chw5_04 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_05', 'Passive', cast(chw5_05 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_06', 'Travelled', cast(chw5_06 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw5_07', 'Provided with IPTp', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

    SELECT p_month_end_date, p_facility_id, hid_name,'chw6_01','Unknown HIV status',cast(chw6_01 as text), cast(null as integer), dhis_id from cross_join_cte

	union all

	SELECT p_month_end_date, p_facility_id, hid_name,'chw6_02','Tested',cast(0 as text), cast(null as integer), dhis_id from cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw6_03', 'Tested positive for HIV', cast(chw6_03 as text), cast(null as integer), dhis_id FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw6_04', 'Referred for testing', cast(chw6_04 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw6_05', 'Known+, not on ART', cast(chw6_05 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw6_06', 'Active on ART', cast(chw6_06 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw6_07', 'Referred for STI treatment', cast(chw6_07 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw7_01', 'At least one HPV dose', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw7_02', 'Suspected cases notified', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw7_03', 'Differently-abled', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw7_04', 'Individuals Referred (any reason)', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw7_05', 'Referred and returned the slip', cast(0 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw8_01', 'Improved toilet facilities', cast(chw8_01 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw8_02', 'Water sources', cast(chw8_02 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw8_03', 'Handwashing facilities', cast(chw8_03 as text), cast(null as integer), dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT p_month_end_date, p_facility_id, hid_name, 'chw8_04', 'Approved refuse disposal facilities', cast(chw8_04 as text), cast(null as integer), dhis_id
	FROM cross_join_cte;

END;
$$ LANGUAGE plpgsql;

