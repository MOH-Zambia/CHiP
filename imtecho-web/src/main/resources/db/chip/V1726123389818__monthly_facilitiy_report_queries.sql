DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_anc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'39fc2b6a-ab20-49ba-865b-b8a38c82ae63', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_anc_details',
 null,
'with multiple_visits as (
	select
		count(ram.*) as anc_count
	from rch_anc_master ram
	where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))
	and ram.created_by = cast(:userId as integer)
	group by ram.pregnancy_reg_det_id
	having count(*) > 2
)
select
	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))
	and (select count(*) from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
	(select count(*) from multiple_visits) as chw2_05,
	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_06,
	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_10,
	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and ram.having_birth_plan and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_11,
	count(ram.*) filter (where dangerous_sign_id is not null or other_dangerous_sign is not null and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_13
from rch_anc_master ram
inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
where ram.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_malaria_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b2683e70-01ed-42dc-b6ca-d1cd634d14e7', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_malaria_details',
 null,
'select
	count(*) as chw5_01,
	count(*) filter (where rdt_test_status = ''POSITIVE'') as chw5_02,
	count(*) filter (where is_treatment_being_given) as chw5_03,
	count(*) filter (where referral_place is not null) as chw5_04,
	count(*) filter (where malaria_type = ''PASSIVE'') as chw5_05,
	count(*) filter (where having_travel_history) as chw5_06
from malaria_details
where extract(month from created_on) = extract(month from date(:month))
and extract(year from created_on) = extract(year from date(:month))
and created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_pregnancy_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f1f66b3e-60f2-4c91-adfb-3f246cd5353b', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_pregnancy_details',
 null,
'select
	count(*) filter (where extract(month from reg_date) = extract(month from date(:month))
and extract(year from reg_date) = extract(year from date(:month)))	 as chw2_02,
        count(*) as chw2_04
from rch_pregnancy_registration_det
where created_by = cast(:userId as integer)
and state != ''MARK_AS_WRONGLY_PREGNANT'';',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_wpd_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'424a894e-c654-4a7a-b3a9-56b1b7265925', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_wpd_details',
 null,
'select
	count(rwcm.*) filter (where rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_21,
	count(distinct rwmm.*) filter (where (select count(*) from rch_anc_master where pregnancy_reg_det_id = rwmm.pregnancy_reg_det_id) >= 4) as chw2_22,
	count(distinct rwmm.*) filter (where rwmm.death_date is not null and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_24,
	count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_25,
	count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place = ''HOSP'') as chw2_26,
	count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'') as chw2_27,
	count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.is_preterm_birth) as chw2_28,
	count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''SBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_29,
	count(rwcm.*) filter (where rwcm.referral_done = ''YES'' and rwcm.other_danger_sign is not null) as chw2_30
from rch_wpd_mother_master rwmm
left join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id
where extract(month from rwmm.date_of_delivery) = extract(month from date(:month))
and extract(year from rwmm.date_of_delivery) = extract(year from date(:month))
and rwmm.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_member_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61d9d1e8-e546-46a0-8591-adb4728797a6', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_member_details',
 null,
'select
	count(distinct im.*) as chw1_04,
	count(distinct im.*) filter (where im.last_method_of_contraception is not null and im.not_using_fp_reason is null) as chw2_01,
	count(distinct im.*) filter (where im.basic_state = ''DEAD'' and age(rmdd.dod,im.dob) <= interval ''28 days'') as chw2_31,
	count(distinct im.*) filter (where age(im.created_on, im.dob) <= interval ''28 days'') as chw2_32,
	count(distinct im.*) filter (where age(im.created_on, im.dob) <= interval ''2 years'') as chw3_02,
	count(distinct im.*) filter (where im.basic_state = ''DEAD'' and age(rmdd.dod,im.dob) < interval ''5 years'') as chw3_07,
	count(distinct im.*) filter (where age(im.created_on, im.dob) <= interval ''6 months'') as chw3_10,
	count(distinct im.*) filter (where age(im.created_on, im.dob) <= interval ''5 years'') as chw3_14
from imt_member im
left join rch_member_death_deatil rmdd on rmdd.id = im.death_detail_id
where extract(month from im.created_on) = extract(month from date(:month))
and extract(year from im.created_on) = extract(year from date(:month))
and im.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_family_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0266ede1-e1c3-4ef1-a0a1-11c24f12de0c', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_family_details',
 null,
'select
	count(*) as chw1_01,
	count(*) as chw1_03,
	count(*) filter (where type_of_toilet is not null or other_toilet is not null) as chw8_01,
	count(*) filter (where drinking_water_source is not null or other_water_source is not null) as chw8_02,
	count(*) filter (where handwash_available) as chw8_03,
	count(*) filter (where waste_disposal_method is not null) as chw8_04
from imt_family
where extract(month from created_on) = extract(month from date(:month))
and extract(year from created_on) = extract(year from date(:month))
and created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_tb_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9eed98e0-f0d6-4f7f-9d5d-4944288afaa3', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_tb_details',
 null,
'select
	count(*) filter (where is_tb_suspected) as chw4_01,
	count(*) filter (where is_patient_taking_medicines) as chw4_02,
	count(*) filter (where is_tb_suspected and is_patient_taking_medicines = false) as chw4_03,
	count(*) filter (where is_tb_suspected and form_type = ''TB_SCREENING'') as chw4_05
from tuberculosis_screening_details
where extract(month from created_on) = extract(month from date(:month))
and extract(year from created_on) = extract(year from date(:month))
and created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_hiv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'62e1ac8c-8106-428a-b32e-2d67794a0663', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_hiv_details',
 null,
'select
	count(distinct rhsm.*) filter (where rhkm.member_id is null) as chw6_01,
	count(distinct rhsm.*) filter (where rhsm.tested_for_hiv_in_12_months) as chw6_02,
	count(distinct rhsm.*) filter (where rhsm.hiv_test_result) as chw6_03,
	count(distinct rhsm.*) filter (where rhsm.referral_place is not null and rhsm.tested_for_hiv_in_12_months = false) as chw6_04,
	count(distinct rhsm.*) filter (where rhsm.hiv_test_result and rhsm.child_currently_on_art = false) as chw6_05,
	count(distinct rhsm.*) filter (where rhsm.child_currently_on_art) as chw6_06,
	count(distinct rhsm.*) filter (where rhsm.referral_place is not null and rhsm.tested_for_hiv_in_12_months) as chw6_07
from rch_hiv_screening_master rhsm
left join rch_hiv_known_master rhkm on rhkm.member_id = rhsm.member_id
where extract(month from rhsm.created_on) = extract(month from date(:month))
and extract(year from rhsm.created_on) = extract(year from date(:month))
and rhsm.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_pnc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9c8f94db-bcd8-45da-8db1-ca754ca90ec8', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_pnc_details',
 null,
'select
	count(distinct rpm.*) filter (where rpm.delivery_place = ''HOME'') as chw2_14,
	count(distinct rpm.*) filter (where rpm.delivery_place = ''HOSP'') as chw2_15,
	count(distinct rpm.*) filter (where rpm.delivery_place is not null) as chw2_16,
	count(distinct rpm.*) as chw2_17,
	count(distinct rpmm.mother_id) as chw2_18,
	count(distinct rpmm.mother_id) filter (where rpmm.other_danger_sign is not null) as chw2_23
from rch_pnc_master rpm
left join rch_pnc_mother_master rpmm on rpm.id = rpmm.pnc_master_id
where extract(month from rpm.service_date) = extract(month from date(:month))
and extract(year from rpm.service_date) = extract(year from date(:month))
and rpm.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_csv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b7c0218-6a89-4c38-8bd8-f20339aa4702', 97182,  current_date , 97182,  current_date , 'retrieve_mrf_csv_details',
 null,
'select
	count(rcsm.*) filter (where lfvd2.value = ''Diarrhea'' and rcsm.is_treatement_done = ''YES'') as chw3_03,
	count(rcsm.*) filter (where lfvd2.value = ''Diarrhea'' and rcsm.referral_place is not null and lfvd.value = ''Danger signs'') as chw3_04,
	count(rcsm.*) filter (where lfvd2.value = ''Pneumonia'' and rcsm.is_treatement_done = ''YES'') as chw3_05,
	count(rcsm.*) filter (where lfvd2.value = ''Pneumonia'' and rcsm.referral_place is not null and lfvd.value = ''Danger signs'') as chw3_06,
	count(distinct rcsm.*) filter (where rcsm.delay_in_developmental) as chw3_08
from rch_child_service_master rcsm
left join listvalue_field_value_detail lfvd on cast(rcsm.referral_reason as integer) = lfvd.id
left join rch_child_service_diseases_rel rcsdr on rcsm.id = rcsdr.child_service_id
left join listvalue_field_value_detail lfvd2 on rcsdr.diseases = lfvd2.id
where extract(month from rcsm.service_date) = extract(month from date(:month))
and extract(year from rcsm.service_date) = extract(year from date(:month))
and rcsm.created_by = cast(:userId as integer);',
'Used for Forms',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_all_health_facilities';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd329c640-ce33-40a9-9927-edb6db959799', 97182,  current_date , 97182,  current_date , 'get_all_health_facilities',
'locationId',
'with location_detail as (
	select child_id
	from location_hierchy_closer_det
	where parent_id = #locationId#
)
SELECT
	hid.id as facility_id,
	hid.name as facility_name, hid.is_enabled,
	(
		select name
	 	from location_master
	 	where id = (
				select parent_id
				from location_hierchy_closer_det
				where child_id = hid.location_id and parent_loc_type = ''D''
		)
	) as district_name,
	(select name
	 from location_master
	 where id = (select parent_id
				 from location_hierchy_closer_det
				 where child_id = hid.location_id and parent_loc_type = ''P'')) as province_name,

	hid.mfl_code as mfl_facility_id,
    dhis2_uid as dhis2_facility_id


FROM health_infrastructure_details hid
INNER JOIN location_detail ld on ld.child_id = hid.location_id;',
'Gets list of all facilitiess details  including the mapped dhis2 org unit id',
true, 'ACTIVE');


alter table public.health_infrastructure_details
add column is_enabled boolean default true;


delete from system_function_master where name = 'syncDataForDhis2';
insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('syncDataForDhis2
','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());


DELETE FROM QUERY_MASTER WHERE CODE='update_health_infra';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7613fbd3-b5f1-449b-b4ac-08e6d41124e3', 97182,  current_date , 97182,  current_date , 'update_health_infra',
'isEnabled,id',
'update public.health_infrastructure_details
set is_enabled = #isEnabled#
where id = #id#;',
'update health infra',
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_monthly_facility_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'cf907854-6c72-4dba-95b0-06f52a28d7be', 97182,  current_date , 97182,  current_date , 'retrieve_monthly_facility_details',
'facilityId,month',
'with users as (
	SELECT u.id  as v_user_id
    FROM um_user u
	INNER JOIN um_user_location ul on u.id = ul.user_id and u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
	inner join location_hierchy_closer_det det on det.child_id = ul.loc_id
	INNER JOIN health_infrastructure_details hid on hid.location_id = det.parent_id
    WHERE hid.id = #facilityId#
	),
	hiv_indicators AS (
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
        inner join users on users.v_user_id = rhsm.created_by
        WHERE cast(TO_CHAR(rhsm.created_on, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)

    ), tb_indicators AS (
        SELECT
            COUNT(*) FILTER (WHERE is_tb_suspected) AS chw4_01,
            COUNT(*) FILTER (WHERE is_patient_taking_medicines) AS chw4_02,
            COUNT(*) FILTER (WHERE is_tb_suspected AND is_patient_taking_medicines = FALSE) AS chw4_03,
            COUNT(*) FILTER (WHERE is_tb_suspected AND form_type = ''TB_SCREENING'') AS chw4_05
        FROM tuberculosis_screening_details
        inner join users on users.v_user_id = tuberculosis_screening_details.created_by
        WHERE cast(TO_CHAR(created_on, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
    ), family_indicators AS (
        SELECT
            COUNT(*) AS chw1_01,
            COUNT(*) FILTER (WHERE type_of_toilet IS NOT NULL OR other_toilet IS NOT NULL) AS chw8_01,
            COUNT(*) FILTER (WHERE drinking_water_source IS NOT NULL OR other_water_source IS NOT NULL) AS chw8_02,
            COUNT(*) FILTER (WHERE handwash_available) AS chw8_03,
            COUNT(*) FILTER (WHERE waste_disposal_method IS NOT NULL) AS chw8_04
        FROM imt_family
        inner join users on users.v_user_id = imt_family.created_by
        WHERE cast(TO_CHAR(created_on, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
    ), malaria_indicators AS (
		select
			count(*) as chw5_01,
			count(*) filter (where rdt_test_status = ''POSITIVE'') as chw5_02,
			count(*) filter (where is_treatment_being_given) as chw5_03,
			count(*) filter (where referral_place is not null) as chw5_04,
			count(*) filter (where malaria_type = ''PASSIVE'') as chw5_05,
			count(*) filter (where having_travel_history) as chw5_06
		from malaria_details
		inner join users on users.v_user_id = malaria_details.created_by
		where cast(TO_CHAR(created_on, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
	),
	pregnancy_indicators AS (
		select
			count(*) filter (where cast(TO_CHAR(reg_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)) as chw2_02
		from rch_pregnancy_registration_det
		inner join users on users.v_user_id = rch_pregnancy_registration_det.created_by
		where
		 state != ''MARK_AS_WRONGLY_PREGNANT''
	), anc_indicators AS (
        with multiple_visits as (
			select
				count(ram.*) as anc_count
			from rch_anc_master ram
			inner join users on users.v_user_id = ram.created_by
			where cast(TO_CHAR(ram.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
			group by ram.pregnancy_reg_det_id
			having count(*) > 2
		)
		select
			count(ram.*) filter (where cast(TO_CHAR(ram.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int) and (select count(*) from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
			(select count(*) from multiple_visits) as chw2_05,
			count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and cast(TO_CHAR(ram.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)) as chw2_10,
			count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and ram.having_birth_plan and cast(TO_CHAR(ram.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)) as chw2_11,
			count(ram.*) filter (where dangerous_sign_id is not null or other_dangerous_sign is not null and cast(TO_CHAR(ram.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)) as chw2_13
		from rch_anc_master ram
		inner join users on users.v_user_id = ram.created_by
		inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
    ), pnc_indicators AS (
        SELECT
            COUNT(DISTINCT rpm.*) FILTER (WHERE rpm.delivery_place = ''HOME'') AS chw2_14,
            COUNT(DISTINCT rpm.*) FILTER (WHERE rpm.delivery_place = ''HOSP'') AS chw2_15,
            COUNT(DISTINCT rpm.*) AS chw2_17,
            COUNT(DISTINCT rpmm.mother_id) FILTER (WHERE rpmm.other_danger_sign IS NOT NULL) AS chw2_23
        FROM rch_pnc_master rpm
        LEFT JOIN rch_pnc_mother_master rpmm ON rpm.id = rpmm.pnc_master_id
        inner join users on users.v_user_id = rpm.created_by
        WHERE cast(TO_CHAR(rpm.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
    ), child_service_indicators AS (
        SELECT
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = ''Diarrhea'' AND rcsm.is_treatement_done = ''YES'') AS chw3_03,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = ''Diarrhea'' AND rcsm.referral_place IS NOT NULL AND lfvd.value = ''Danger signs'') AS chw3_04,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = ''Pneumonia'' AND rcsm.is_treatement_done = ''YES'') AS chw3_05,
            COUNT(rcsm.*) FILTER (WHERE lfvd2.value = ''Pneumonia'' AND rcsm.referral_place IS NOT NULL AND lfvd.value = ''Danger signs'') AS chw3_06,
            COUNT(DISTINCT rcsm.*) FILTER (WHERE rcsm.delay_in_developmental) AS chw3_08
        FROM rch_child_service_master rcsm
        LEFT JOIN listvalue_field_value_detail lfvd ON CAST(rcsm.referral_reason AS INTEGER) = lfvd.id
        LEFT JOIN rch_child_service_diseases_rel rcsdr ON rcsm.id = rcsdr.child_service_id
        LEFT JOIN listvalue_field_value_detail lfvd2 ON rcsdr.diseases = lfvd2.id
        inner join users on users.v_user_id = rcsm.created_by
        WHERE cast(TO_CHAR(rcsm.service_date, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
    ), wpd_indicators AS (
		select
			count(rwcm.*) filter (where rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_21,
			count(distinct rwmm.*) filter (where (select count(*) from rch_anc_master where pregnancy_reg_det_id = rwmm.pregnancy_reg_det_id) >= 4) as chw2_22,
			count(distinct rwmm.*) filter (where rwmm.death_date is not null and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_24,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_25,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place = ''HOSP'') as chw2_26,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.is_preterm_birth) as chw2_28,
			count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''SBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_29,
			count(rwcm.*) filter (where rwcm.referral_done = ''YES'' and rwcm.other_danger_sign is not null) as chw2_30
		from rch_wpd_mother_master rwmm
		left join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id
		  inner join users on users.v_user_id = rwmm.created_by
		where cast(TO_CHAR(rwmm.date_of_delivery, ''YYYYMM'') as int) = cast(TO_CHAR(TIMESTAMPTZ ''#month#'', ''YYYYMM'') as int)
	)

		select get_location_hierarchy(hid.location_id) as location, cast(hid.name as text) as name,cast(hid.dhis2_uid as text) as dhis_id, hiv_ind.*, tb_ind.*, malaria_ind.*, family_ind.*, preg_ind.*, anc_ind.*, pnc_ind.*, child_ind.*, wpd_ind.*
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
		where hid.id = #facilityId#',
'used for monthly facility reports',
true, 'ACTIVE');