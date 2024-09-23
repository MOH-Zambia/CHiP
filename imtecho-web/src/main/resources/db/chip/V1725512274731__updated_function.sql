
drop function if exists public.get_monthly_report;

CREATE OR REPLACE FUNCTION get_monthly_report(
    p_month_end_date DATE,
    p_facility_id INT
)
RETURNS TABLE (
    period text,
    facility_id INT,
    facility_name text,
    indicator_id text,
    indicator_name text,
    indicator_value int,
    dhis2_indicator_id text,
    dhis2_facility_id text
) AS $$

DECLARE
    v_user_id INT;
	dhis_id text;
BEGIN

	SELECT u.id, hid.dhis2_uid  INTO v_user_id, dhis_id
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
		select hid.name as name, hiv_ind.*, tb_ind.*, malaria_ind.*, family_ind.*, preg_ind.*, anc_ind.*, pnc_ind.*, child_ind.*, wpd_ind.*
		from health_infrastructure_details hid
		cross join hiv_indicators hiv_ind
    	cross JOIN tb_indicators tb_ind
		cross JOIN malaria_indicators malaria_ind
	    cross JOIN family_indicators family_ind
		cross JOIN pregnancy_indicators preg_ind
		cross JOIN anc_indicators anc_ind
		cross JOIN pnc_indicators pnc_ind
		cross JOIN child_service_indicators child_ind
		cross JOIN wpd_indicators wpd_ind
		where hid.id = p_facility_id
	)
	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw1_01', 'First Household Visits', cast(chw1_01 as int), 'biy87aGQKIz', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw1_02', 'Follow Up Household Visits', cast(0 as int), 'U50o8t48Ums', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw1_03', 'Total Household Visits', cast(chw1_03 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw1_04', 'Number of Client Contacts', cast(0 as int), 'pR5LMPIB5b5', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_01', 'Provided Modern FP', cast(0 as int), 'G2xFY1SnjpL', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_02', 'New Pregnancies', cast(chw2_02 as int), 'QIhyfe5YPcn', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_03', 'Follow up this month', cast(chw2_03 as int), 'bxqgWLimgwG', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_04', 'Total Pregnant Women', cast(chw2_04 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_05', 'ANC met 2+ this month', cast(chw2_05 as int), 'mIvj4HkpBjn', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_06', 'Total ANC contacts', cast(chw2_06 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_07', 'New - seen less than 3 mths GA', cast(0 as int), 'PM8EeipoCY6', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_08', 'New Pregnancies - already visited facility', cast(0 as int), 'fN2cQ00CBcV', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_09', 'New Pregnancies at facility in 1st trimester', cast(0 as int), 'y2wwAb6kRtL', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_10', 'ANC women with 28+ weeks pregnancies', cast(chw2_10 as int), 'oZW31z6qUpF', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_11', 'ANC women with birth plan of from 28 weeks', cast(chw2_11 as int), 'k9DjSuqj5Vk', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_12', 'Up-to-date with ANC visits', cast(0 as int), 'ae2bi7noeus', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_13', 'ANC women with danger signs', cast(chw2_13 as int), 'KnumftGHMTT', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_14', 'New home deliveries', cast(chw2_14 as int), 'uGsJULOoS46', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_15', 'New facility deliveries', cast(chw2_15 as int), 'UFxMrIRHDsM', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_16', 'New deliveries this month', cast(chw2_16 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_17', 'PNC follow-ups this month', cast(chw2_17 as int), 'JDYdmXTfzAo', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_18', 'Total PNC women', cast(chw2_18 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_19', 'PNC met this month prior', cast(0 as int), 'e1Ldo837JSm', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_20', 'Total PNC contacts', cast(0 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_21', 'New home deliveries - visited within 48 hrs', cast(chw2_21 as int), 'ZCVXWwDuzFP', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_22', 'New deliveries - Visited at least 4 times in ANC', cast(chw2_22 as int), 'na9klYW47Wx', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_23', 'PNC cases with danger', cast(chw2_23 as int), 'hGpqydEvChW', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_24', 'Maternal(home) deaths', cast(chw2_24 as int), 'RMERU7cmIQl', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_25', 'Livebirth - Home', cast(chw2_25 as int), 'BxZLqoas0bd', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_26', 'Livebirth - Facility', cast(chw2_26 as int), 'Km2DluHqmiC', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_27', 'Total Livebirths', cast(chw2_27 as int), '', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_28', 'Livebirth - Preterm', cast(chw2_28 as int), 'qhik5V6jtO6', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_29', 'Stillbirths(home)', cast(chw2_29 as int), 'RD4c6zPlEDC', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_30', 'Referred with danger signs', cast(chw2_30 as int), 'uTWikOL7mcD', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_31', 'Neonatal deaths(home)', cast(0 as int), 'BiufclvM9fB', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw2_32', 'Neonatal infants visited', cast(0 as int), 'LHYSFRgo7Vo', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_01', 'Up to date with vaccinations', cast(0 as int), 'KvWzEHx1iEz', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_02', 'Children 24 months and below', cast(0 as int), 'TS9Dh1vFskJ', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_03', 'Treated for diarrhoea', cast(chw3_03 as int), 'V9fjp8CxjSr', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_04', 'Referred for diarrhoea', cast(chw3_04 as int), 'xeSZWRa2qBi', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_05', 'Treated for pneumonia', cast(chw3_05 as int), 'ibI1HKa1zru', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_06', 'Referred for pneumonia', cast(chw3_06 as int), 'B9Tq7pk3sQc', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_07', 'Under 5(home) death', cast(0 as int), 'Xj2vy6lTciE', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_08', 'Delayed development', cast(chw3_08 as int), 'iLyZtB09QQv', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_09', 'On EBF less than 6 months', cast(0 as int), 'zRMmRe1AcKN', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_10', 'Infant aged less than 6 months', cast(0 as int), 'a7VEgZgjPtX', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_11', 'Severely malnourished', cast(0 as int), 'MtQ38gwt5nG', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_12', 'Moderately malnourished', cast(0 as int), 'I5aoyVsZriW', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_13', 'Not growing well', cast(0 as int), 'RtQNwW0JE8s', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw3_14', 'Number of under-five children visited', cast(0 as int), 'BG037PfAd6p', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw4_01', 'Suspected with TB', cast(chw4_01 as int), 'u1hn3Fna0v5', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw4_02', 'On TB treatment', cast(chw4_02 as int), 'rb9KUHW7SPr', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw4_03', 'Not active on TB care', cast(chw4_03 as int), 'jxdr1C3IrLZ', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw4_04', 'Contact traced', cast(0 as int), 'StvBBNEE1Ay', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw4_05', 'Newly confirmed TB cases', cast(chw4_05 as int), 'ZGHIDkLrUw5', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_01', 'Tested', cast(chw5_01 as int), 'Uyg2Xg5lljG', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_02', 'Positive test result', cast(chw5_02 as int), 'uPkKUp1nUs9', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_03', 'Treated', cast(chw5_03 as int), 'Y10AT9uOEUQ', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_04', 'Referred', cast(chw5_04 as int), 'BBP13Ul2LZf', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_05', 'Passive', cast(chw5_05 as int), 'nV9ALtqPXIh', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_06', 'Travelled', cast(chw5_06 as int), 'CcUEFHJQlyO', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw5_07', 'Provided with IPTp', cast(0 as int), 'bVCD1fVPMMm', dhis_id
	FROM cross_join_cte

	UNION ALL

    SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text),'chw6_01','Unknown HIV status',cast(chw6_01 as int), 'POFv7ZXbB6H', dhis_id from cross_join_cte

	union all

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text),'chw6_02','Tested',cast(0 as int), 'wBVMybgxobK', dhis_id from cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw6_03', 'Tested positive for HIV', cast(chw6_03 as int), 'XJBcISnuhdC', dhis_id FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw6_04', 'Referred for testing', cast(chw6_04 as int), 'T4qcuyLK0Bq', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw6_05', 'Known+, not on ART', cast(chw6_05 as int), 'xSe3RyKtfXF', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw6_06', 'Active on ART', cast(chw6_06 as int), 'yzeyMUu0J0h', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw6_07', 'Referred for STI treatment', cast(chw6_07 as int), 'jlvrvcRhPlS', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw7_01', 'At least one HPV dose', cast(0 as int), 'yXCUldEjWUb', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw7_02', 'Suspected cases notified', cast(0 as int), 'e0qdgLrhZvW', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw7_03', 'Differently-abled', cast(0 as int), 'wLgYyG1nmH7', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw7_04', 'Individuals Referred (any reason)', cast(0 as int), 'IcFpDlAm6VV', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw7_05', 'Referred and returned the slip', cast(0 as int), 'tJG2tPHdOwB', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw8_01', 'Improved toilet facilities', cast(chw8_01 as int), 't8DrwSywdoV', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw8_02', 'Water sources', cast(chw8_02 as int), 'xBkpUim4yhk', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw8_03', 'Handwashing facilities', cast(chw8_03 as int), 'z2X89ewWtXn', dhis_id
	FROM cross_join_cte

	UNION ALL

	SELECT TO_CHAR(p_month_end_date, 'YYYYMM'), p_facility_id, cast(name as text), 'chw8_04', 'Approved refuse disposal facilities', cast(chw8_04 as int), 'NjKHTCI8HLr', dhis_id
	FROM cross_join_cte;

END;
$$ LANGUAGE plpgsql;