insert into menu_config(active,menu_name,navigation_state,menu_type)
select true,'Monthly Reporting Form Search','techo.manage.monthlyreportingformsearch','manage'
where not exists(select 1 from menu_config where menu_name='Monthly Reporting Form Search');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_user_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b8608eff-0dad-41d8-9a05-fe5940a6251b', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_user_details',
 null,
'select
    concat_ws('' '', uu.first_name, uu.middle_name, uu.last_name) as chw,
    lm.english_name as zone,
    (select count(*) from imt_family
    where area_id = lm.id
    and basic_state in (''NEW'',''TEMPORARY'',''VERIFIED'',''REVERIFICATION'')
    ) as "zonewiseHHCount"
from um_user uu
inner join um_user_location uul on uu.id = uul.user_id and uul.state = ''ACTIVE'' and uu.id = cast(:userId as integer)
inner join location_master lm on lm.id = uul.loc_id;',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_family_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0266ede1-e1c3-4ef1-a0a1-11c24f12de0c', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_family_details',
 null,
'select
	count(*) as chw1_01,
	count(*) as chw1_03,
	count(*) filter (where type_of_toilet is not null or other_toilet is not null) as chw8_01,
	count(*) filter (where drinking_water_source is not null or other_water_source is not null) as chw8_02,
	count(*) filter (where handwash_available) as chw8_03,
	count(*) filter (where waste_disposal_method is not null) as chw8_04
from imt_family
where date(created_on) >= date(:month)
and created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_member_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61d9d1e8-e546-46a0-8591-adb4728797a6', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_member_details',
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
where date(im.created_on) >= date(:month)
and im.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_anc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'39fc2b6a-ab20-49ba-865b-b8a38c82ae63', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_anc_details',
 null,
'with multiple_visits as (
	select
		count(ram.*) as anc_count
	from rch_anc_master ram
	where date(ram.service_date) >= date(:month)
	and ram.created_by = cast(:userId as integer)
	group by ram.pregnancy_reg_det_id
	having count(*) > 2
)
select
	count(ram.*) filter (where date(ram.service_date) >= date(:month) and (select count(*) from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
	(select count(*) from multiple_visits) as chw2_05,
	count(ram.*) filter (where date(ram.service_date) >= date(:month)) as chw2_06,
	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and date(ram.service_date) >= date(:month)) as chw2_10,
	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and ram.having_birth_plan and date(ram.service_date) >= date(:month)) as chw2_11,
	count(ram.*) filter (where dangerous_sign_id is not null or other_dangerous_sign is not null and date(ram.service_date) >= date(:month)) as chw2_13
from rch_anc_master ram
inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
where ram.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_wpd_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'424a894e-c654-4a7a-b3a9-56b1b7265925', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_wpd_details',
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
where date(rwmm.date_of_delivery) >= date(:month)
and rwmm.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_pnc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9c8f94db-bcd8-45da-8db1-ca754ca90ec8', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_pnc_details',
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
where date(rpm.service_date) >= date(:month)
and rpm.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_csv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b7c0218-6a89-4c38-8bd8-f20339aa4702', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_csv_details',
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
where date(rcsm.service_date) >= date(:month)
and rcsm.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_tb_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9eed98e0-f0d6-4f7f-9d5d-4944288afaa3', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_tb_details',
 null,
'select
	count(*) filter (where is_tb_suspected) as chw4_01,
	count(*) filter (where is_patient_taking_medicines) as chw4_02,
	count(*) filter (where is_tb_suspected and is_patient_taking_medicines = false) as chw4_03,
	count(*) filter (where is_tb_suspected and form_type = ''TB_SCREENING'') as chw4_05
from tuberculosis_screening_details
where date(created_on) >= date(:month)
and created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_malaria_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b2683e70-01ed-42dc-b6ca-d1cd634d14e7', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_malaria_details',
 null,
'select
	count(*) as chw5_01,
	count(*) filter (where rdt_test_status = ''POSITIVE'') as chw5_02,
	count(*) filter (where is_treatment_being_given) as chw5_03,
	count(*) filter (where referral_place is not null) as chw5_04,
	count(*) filter (where malaria_type = ''PASSIVE'') as chw5_05,
	count(*) filter (where having_travel_history) as chw5_06
from malaria_details
where date(created_on) >= date(:month)
and created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_hiv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'62e1ac8c-8106-428a-b32e-2d67794a0663', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_hiv_details',
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
where date(rhsm.created_on) >= date(:month)
and rhsm.created_by = cast(:userId as integer);',
'Used for Monthly Reporting Form',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_pregnancy_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f1f66b3e-60f2-4c91-adfb-3f246cd5353b', 60512,  current_date , 60512,  current_date , 'retrieve_mrf_pregnancy_details',
 null,
'select
	count(*) filter (where date(reg_date) >= date(:month)) as chw2_02,
	count(*) as chw2_04
from rch_pregnancy_registration_det
where created_by = cast(:userId as integer)
and state != ''MARK_AS_WRONGLY_PREGNANT'';',
'Used for Monthly Reporting Form',
true, 'ACTIVE');