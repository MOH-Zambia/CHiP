INSERT INTO public.menu_config
(id, feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, "uuid", group_name_uuid, sub_group_uuid, description)
VALUES(nextval('menu_config_id_seq'::regclass), NULL, NULL, true, NULL, 'Integrated Daily Activity Register Search', 'techo.manage.integrateddailyregistersearch', NULL, 'manage', NULL, NULL, NULL, NULL, NULL, NULL);

--retrieve_idar_user_details--

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_user_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f381270f-1f58-4acd-8e61-dcdc3c175841', 97074,  current_date , 97074,  current_date , 'retrieve_idar_user_details', 
 null, 
'select
    concat_ws('' '', uu.first_name, uu.middle_name, uu.last_name) as chw,
    lm.english_name as zone,
    urm."name" as area
from um_user uu
inner join um_role_master urm on uu.role_id = urm.id 
inner join um_user_location uul on uu.id = uul.user_id and uul.state = ''ACTIVE'' and uu.id = cast(:userId as integer)
inner join location_master lm on lm.id = uul.loc_id;', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_client_details--

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_client_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'255dbc6b-d2d2-4625-9945-c62dc3063bf8', 97074,  current_date , 97074,  current_date , 'retrieve_idar_client_details', 
 null, 
'select
    count(*) as chw1_01,
    count(*) as chw1_03,
    if.house_number as hin,
    im.gender as sex,
    EXTRACT(YEAR FROM AGE(current_date, im.dob)) AS age,
    concat_ws(im.first_name,'' '', im.middle_name,'' '',im.last_name) as noc, 
    ---first this month left---
    ---follow up left--
    count(*) filter (where if.type_of_toilet is not null or if.other_toilet is not null) as chw8_03,
    count(*) filter (where if.drinking_water_source is not null or if.other_water_source is not null) as chw8_01,
    count(*) filter (where if.handwash_available) as chw8_02,
    count(*) filter (where if.waste_disposal_method is not null) as chw8_04
from imt_family if
inner join imt_member im on im.id = if.contact_person_id
where date(if.created_on) >= date(:month)
and if.created_by = cast(:userId as integer)
group by 3,4,5,6;', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_member_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_member_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'51e1baa6-ec69-4404-8d3e-66ccecb618c0', 97074,  current_date , 97074,  current_date , 'retrieve_idar_member_details', 
 null, 
'select
    count(distinct im.*) filter (where im.last_method_of_contraception is not null and im.not_using_fp_reason is null) as chw2_01,
    count(distinct im.*) filter (where im.basic_state = ''DEAD'' and age(rmdd.dod,im.dob) <= interval ''28 days'') as chw2_31,
    count(distinct im.*) filter (where im.basic_state = ''DEAD'' and age(rmdd.dod,im.dob) < interval ''5 years'') as chw3_07
from imt_member im
left join rch_member_death_deatil rmdd on rmdd.id = im.death_detail_id
where date(im.created_on) >= date(:month)
and im.created_by = cast(:userId as integer);', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_anc_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_anc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4179f7d5-61ce-460e-9bcb-6a8ddf5b1c19', 97074,  current_date , 97074,  current_date , 'retrieve_idar_anc_details', 
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
    count(ram.) filter (where date(ram.service_date) >= date(:month) and (select count() from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
    (select count(*) from multiple_visits) as chw2_05,
    count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and date(ram.service_date) >= date(:month)) as chw2_10,
    count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and ram.having_birth_plan and date(ram.service_date) >= date(:month)) as chw2_11

from rch_anc_master ram
inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
where ram.created_by = cast(:userId as integer);', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_wpd_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_wpd_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e35c8a3f-3d1e-4d11-aae3-d20a4f1c0fd0', 97074,  current_date , 97074,  current_date , 'retrieve_idar_wpd_details', 
 null, 
'select
    count(rwcm.*) filter (where rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_21,
    count(distinct rwmm.) filter (where (select count() from rch_anc_master where pregnancy_reg_det_id = rwmm.pregnancy_reg_det_id) >= 4) as chw2_22,
    count(distinct rwmm.*) filter (where rwmm.death_date is not null and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_24,
    count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_25,
    count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.delivery_place = ''HOSP'') as chw2_26,
    count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''LBIRTH'' and rwmm.is_preterm_birth) as chw2_28,
    count(rwcm.*) filter (where rwcm.pregnancy_outcome = ''SBIRTH'' and rwmm.delivery_place in (''HOME'',''ON_THE_WAY'')) as chw2_29,
    count(rwcm.*) filter (where rwcm.referral_done = ''YES'' and rwcm.other_danger_sign is not null) as chw2_30
from rch_wpd_mother_master rwmm
left join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id
where date(rwmm.date_of_delivery) >= date(:month)
and rwmm.created_by = cast(:userId as integer);', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_pnc_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_pnc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ea710b66-c75b-4543-b913-2bbde1107f7a', 97074,  current_date , 97074,  current_date , 'retrieve_idar_pnc_details', 
 null, 
'select
    count(distinct rpm.*) filter (where rpm.delivery_place = ''HOME'') as chw2_14,
    count(distinct rpm.*) filter (where rpm.delivery_place = ''HOSP'') as chw2_15,
    count(distinct rpm.*) as chw2_17,
    count(distinct rpmm.mother_id) filter (where rpmm.other_danger_sign is not null) as chw2_23
from rch_pnc_master rpm
left join rch_pnc_mother_master rpmm on rpm.id = rpmm.pnc_master_id
where date(rpm.service_date) >= date(:month)
and rpm.created_by = cast(:userId as integer);', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_csv_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_csv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'674faf8d-1e14-46a1-a269-9eb20a1c1572', 97074,  current_date , 97074,  current_date , 'retrieve_idar_csv_details', 
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
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_tb_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_tb_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a867cbc9-5d43-4c44-bb90-8f6d460a201f', 97074,  current_date , 97074,  current_date , 'retrieve_idar_tb_details', 
 null, 
'select
    count(*) filter (where is_tb_suspected) as chw4_01,
    count(*) filter (where is_patient_taking_medicines) as chw4_02,
    count(*) filter (where is_tb_suspected and is_patient_taking_medicines = false) as chw4_03,
    count(*) filter (where is_tb_suspected and form_type = ''TB_SCREENING'') as chw4_05
from tuberculosis_screening_details
where date(created_on) >= date(:month)
and created_by = cast(:userId as integer);', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_malaria_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_malaria_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'26ce3205-802a-42f0-8527-0af2e8f997e1', 97074,  current_date , 97074,  current_date , 'retrieve_idar_malaria_details', 
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
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_hiv_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_hiv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'67fb8aed-6071-4ad1-9ed1-e54d76353f78', 97074,  current_date , 97074,  current_date , 'retrieve_idar_hiv_details', 
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
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');

--retrieve_idar_pregnancy_details--
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_idar_pregnancy_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f35d48eb-66ab-4998-8a13-f6bce368d2f2', 97074,  current_date , 97074,  current_date , 'retrieve_idar_pregnancy_details', 
'month', 
'select
    count(*) filter (where date(reg_date) >= date(#month#)) as chw2_02
from rch_pregnancy_registration_det
where created_by = cast(:userId as integer)
and state != ''MARK_AS_WRONGLY_PREGNANT'';', 
'Used for Integrated Daily Activity Register Form', 
true, 'ACTIVE');


