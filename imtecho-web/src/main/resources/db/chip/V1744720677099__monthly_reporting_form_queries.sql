DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_referral_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'106b1afe-0cca-4b3b-89ac-1e1df235f629', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_referral_details',
 null,
'-- retrieve_mrf_referral_details

with child_service_referrals as (
    select count(distinct rcsm.member_id)
    from rch_child_service_master rcsm
    where rcsm.created_by = cast(:userId as integer)
        and extract(month from rcsm.created_on) = extract(month from date(:month))
		and extract(year from rcsm.created_on) = extract(year from date(:month))
        and rcsm.referral_place is not null
),
malaria_referrals as (
    select count(distinct md.member_id)
    from malaria_details md
    where md.created_by = cast(:userId as integer)
        and extract(month from md.created_on) = extract(month from date(:month))
		and extract(year from md.created_on) = extract(year from date(:month))
        and md.referral_place is not null
),
hiv_referrals as (
    select count(distinct rhsm.member_id)
    from rch_hiv_screening_master rhsm
    where rhsm.created_by = cast(:userId as integer)
        and extract(month from rhsm.created_on) = extract(month from date(:month))
		and extract(year from rhsm.created_on) = extract(year from date(:month))
        and rhsm.referral_place is not null
),
child_wpd_referrals as (
    select count(distinct rwcm.member_id)
    from rch_wpd_child_master rwcm
    where rwcm.created_by = cast(:userId as integer)
        and extract(month from rwcm.created_on) = extract(month from date(:month))
		and extract(year from rwcm.created_on) = extract(year from date(:month))
        and rwcm.referral_place is not null
),
common_cte as (
    select count from child_service_referrals union all
    select count from malaria_referrals union all
    select count from hiv_referrals union all
    select count from child_wpd_referrals
)
select sum(count) as chw7_04, sum(count) as chw7_05
from common_cte',
'retrieve_mrf_referral_details',
true, 'ACTIVE');




DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_immunisation_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'956d5aea-69c4-46ec-b5bd-5d51b217b6cc', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_immunisation_details',
 null,
'with vaccine_list as (
    select unnest(array[
        ''BCG'',
        ''VITAMIN_A_50000'',
        ''VITAMIN_A_100000'',
        ''VITAMIN_A_200000_1'',
        ''VITAMIN_A_200000_2'',
        ''VITAMIN_A_200000_3'',
        ''VITAMIN_A_200000_4'',
        ''VITAMIN_A_200000_5'',
        ''VITAMIN_A_200000_6'',
        ''VITAMIN_A_200000_7'',
        ''VITAMIN_A_200000_8'',
        ''OPV_0'',
        ''OPV_1'',
        ''OPV_2'',
        ''OPV_3'',
        ''OPV_4'',
        ''PCV_1'',
        ''PCV_2'',
        ''PCV_3'',
        ''DPT-HEPB-HIB_1'',
        ''DPT-HEPB-HIB_2'',
        ''DPT-HEPB-HIB_3'',
        ''MEASLES_RUBELLA_1'',
        ''MEASLES_RUBELLA_2'',
        ''ROTA_VACCINE_1'',
        ''ROTA_VACCINE_2''
    ]) as vaccine
),
immunised_members as (
	select *
	from rch_immunisation_master rim
	where given_by = cast(:userId as integer)
		and extract(month from rim.given_on) = extract(month from date(:month))
		and extract(year from rim.given_on) = extract(year from date(:month))
),
member_vaccine_count as (
	select im.member_id, count(distinct im.immunisation_given) as vaccines_given
	from immunised_members im
	where im.immunisation_given in (select vaccine from vaccine_list)
	group by im.member_id
)
select count(*) as chw3_01
from member_vaccine_count
where vaccines_given = (
    select count(*) from vaccine_list
);',
'retrieve_mrf_immunisation_details',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_pnc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9c8f94db-bcd8-45da-8db1-ca754ca90ec8', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_pnc_details',
 null,
'with child_pncs as (
	select rpcm.child_id
	from rch_pnc_master rpm
	left join rch_pnc_child_master rpcm on rpm.id = rpcm.pnc_master_id
	where extract(month from rpm.service_date) = extract(month from date(:month))
		and extract(year from rpm.service_date) = extract(year from date(:month))
		and rpm.created_by = cast(:userId as integer)
)
select
	count(distinct rpm.*) filter (where rpm.delivery_place = ''HOME'') as chw2_14,
	count(distinct rpm.*) filter (where rpm.delivery_place = ''HOSP'') as chw2_15,
	count(distinct rpm.*) filter (where rpm.delivery_place is not null) as chw2_16,
	count(distinct rpm.*) as chw2_17,
	count(distinct cp.child_id)  as chw2_20,
	count(distinct rpmm.mother_id) as chw2_18,
	count(distinct rpmm.mother_id) filter (where rpmm.other_danger_sign is not null) as chw2_23
from rch_pnc_master rpm
inner join child_pncs cp on true
left join rch_pnc_mother_master rpmm on rpm.id = rpmm.pnc_master_id
where extract(month from rpm.service_date) = extract(month from date(:month))
and extract(year from rpm.service_date) = extract(year from date(:month))
and rpm.created_by = cast(:userId as integer)',
'Used for Forms',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_member_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61d9d1e8-e546-46a0-8591-adb4728797a6', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_member_details',
 null,
'-- retrieve_mrf_member_details

with weight_reference as (
    select * from (
        values
            (0, 2.0, 3.5, 4.5, 5.4),
            (1, 2.0, 4.5, 4.5, 5.4),
            (2, 2.9, 5.5, 6.0, 6.3),
            (3, 3.5, 6.0, 7.0, 7.5),
            (4, 4.1, 6.5, 7.8, 8.6),
            (5, 4.5, 7.1, 8.5, 9.5),
            (6, 5.0, 7.5, 9.0, 10.2),
            (7, 5.3, 7.8, 9.5, 10.8),
            (8, 5.5, 8.1, 9.9, 11.3),
            (9, 5.7, 8.3, 10.4, 11.6),
            (10, 5.9, 8.5, 10.7, 12.2),
            (11, 6.0, 8.8, 11.0, 12.5),
            (12, 6.2, 8.9, 11.3, 12.8),
            (13, 6.4, 9.0, 11.6, 13.3),
            (14, 6.5, 9.2, 12.0, 13.6),
            (15, 6.7, 9.5, 12.2, 13.8),
            (16, 6.9, 9.7, 12.6, 14.2),
            (17, 7.0, 10.0, 12.8, 14.6),
            (18, 7.1, 10.2, 13.0, 14.9),
            (19, 7.2, 10.5, 13.3, 15.3),
            (20, 7.5, 10.6, 13.5, 15.6),
            (21, 7.6, 10.8, 13.8, 15.9),
            (22, 7.8, 11.0, 14.1, 16.3),
            (23, 7.9, 11.2, 14.5, 16.5),
            (24, 8.0, 11.5, 14.7, 16.8),
            (25, 8.1, 11.7, 15.0, 17.2),
            (26, 8.3, 11.8, 15.3, 17.5),
            (27, 8.5, 12.0, 15.6, 17.8),
            (28, 8.6, 12.2, 15.8, 18.2),
            (29, 8.7, 12.5, 16.1, 18.5),
            (30, 8.9, 12.6, 16.4, 18.8),
            (31, 9.0, 12.8, 16.6, 19.1),
            (32, 9.1, 13.0, 17.0, 19.4),
            (33, 9.2, 13.2, 17.2, 19.8),
            (34, 9.3, 13.5, 17.5, 20.0),
            (35, 9.4, 13.6, 17.8, 20.4),
            (36, 9.5, 13.8, 18.0, 20.7),
            (37, 9.7, 14.0, 18.3, 21.0),
            (38, 9.8, 14.2, 18.5, 21.3),
            (39, 10.0, 14.4, 18.8, 21.6),
            (40, 10.1, 14.6, 19.1, 22.0),
            (41, 10.2, 14.8, 19.4, 22.4),
            (42, 10.2, 15.0, 19.6, 22.8),
            (43, 10.4, 15.1, 20.0, 23.1),
            (44, 10.5, 15.3, 20.3, 23.5),
            (45, 10.6, 15.5, 20.5, 23.8),
            (46, 10.7, 15.7, 20.8, 24.2),
            (47, 10.8, 15.9, 21.1, 24.6),
            (48, 10.9, 16.0, 21.5, 25.0),
            (49, 11.0, 16.1, 21.7, 25.3),
            (50, 11.0, 16.3, 22.0, 25.6),
            (51, 11.1, 16.5, 22.3, 26.0),
            (52, 11.2, 16.8, 22.5, 26.5),
            (53, 11.3, 17.0, 22.8, 26.8),
            (54, 11.5, 17.2, 23.1, 27.2),
            (55, 11.6, 17.4, 23.4, 27.5),
            (56, 11.7, 17.6, 23.7, 27.9),
            (57, 11.8, 17.8, 24.0, 28.3),
            (58, 11.9, 17.9, 24.2, 28.6),
            (59, 12.0, 18.0, 24.5, 29.0),
            (60, 12.0, 18.2, 24.8, 29.5)
    ) as ref(month, sm_thresh, mal_thresh, ideal_thresh, obese_thresh)
),
members_counts as (
	select
		count(im.id) as chw1_04,

		count(im.id) filter (
			where im.last_method_of_contraception is not null
			and im.not_using_fp_reason is null
		) as chw2_01,

		count(im.id) filter (where nullif(im.physical_disability, '''') is not null) as chw7_03
	from imt_member im
	where im.created_by = cast(:userId as integer)
		and extract(month from im.created_on) = extract(month from date(:month))
		and extract(year from im.created_on) = extract(year from date(:month))
),
death_det_count as (
	select
		count(rmdd.member_id) filter (where age(rmdd.dod,im.dob) <= interval ''28 days'' and place_of_death = ''HOME'' ) as chw2_31,
		count(rmdd.member_id) filter (where age(rmdd.dod,im.dob) <= interval ''5 years'' and place_of_death = ''HOME'' ) as chw3_07
	from rch_member_death_deatil rmdd
	inner join imt_member im on im.id = rmdd.member_id
		and extract(month from rmdd.created_on) = extract(month from date(:month))
		and extract(year from rmdd.created_on) = extract(year from date(:month))
		and rmdd.created_by = cast(:userId as integer)
),
child_service_counts as (
	select
		count(rcsm.member_id) filter (where age(im.dob, rcsm.service_date) <= interval ''28 days'') as chw2_32,
		count(rcsm.member_id) filter (where age(im.dob, rcsm.service_date) <= interval ''24 months'') as chw3_02,
		count(rcsm.member_id) filter (where age(im.dob, rcsm.service_date) <= interval ''6 months'') as chw3_10,
		count(rcsm.member_id) filter (where age(im.dob, rcsm.service_date) <= interval ''5 years'') as chw3_14
	from rch_child_service_master rcsm
	inner join imt_member im on im.id = rcsm.member_id
	where extract(month from rcsm.created_on) = extract(month from date(:month))
		and extract(year from rcsm.created_on) = extract(year from date(:month))
		and rcsm.created_by = cast(:userId as integer)
),
child_data as (
    select
        im.id,
        rcsm.weight,
        extract(year from age(im.dob, rcsm.service_date)) * 12 +
        extract(month from age(im.dob, rcsm.service_date)) as age_in_months
    from rch_child_service_master rcsm
    inner join imt_member im on rcsm.member_id = im.id
	where extract(month from rcsm.created_on) = extract(month from date(:month))
		and extract(year from rcsm.created_on) = extract(year from date(:month))
		and rcsm.created_by = cast(:userId as integer)
),
child_health_status as (
	select
		cd.id,
		cd.age_in_months,
		cd.weight,
		case
			when cd.weight < wr.sm_thresh then ''SEVERELY_MALNOURISHED''
			when cd.weight >= wr.sm_thresh and cd.weight < wr.mal_thresh then ''MALNOURISHED''
			when cd.weight >= wr.mal_thresh and cd.weight < wr.ideal_thresh then ''IDEAL''
			when cd.weight >= wr.ideal_thresh and cd.weight <= wr.obese_thresh then ''OBESE''
			when cd.weight > wr.obese_thresh then ''SEVERELY_OBESE''
			else null
		end as nutrition_status
	from child_data cd
	inner join weight_reference wr on cd.age_in_months = wr.month
),
child_health_status_count as (
	select
		count(*) filter (where nutrition_status = ''SEVERELY_MALNOURISHED'') as chw3_11,
		count(*) filter (where nutrition_status = ''MALNOURISHED'') as chw3_12,
		count(*) filter (where nutrition_status in (''SEVERELY_MALNOURISHED'', ''MALNOURISHED'')) as chw3_13
	from child_health_status
)
select *
from members_counts
inner join death_det_count on true
inner join child_service_counts on true
inner join child_health_status_count on true',
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



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_tb_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9eed98e0-f0d6-4f7f-9d5d-4944288afaa3', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_tb_details',
 null,
'select
	count(*) filter (where is_tb_suspected) as chw4_01,
	count(*) filter (where is_patient_taking_medicines) as chw4_02,
	count(*) filter (where is_tb_suspected and is_patient_taking_medicines = false) as chw4_03,
	count(*) filter (where is_tb_suspected and form_type = ''TB_SCREENING'') as chw4_05,
	coalesce(sum(contacts_collected), 0) as chw4_04
from tuberculosis_screening_details
where extract(month from created_on) = extract(month from date(:month))
and extract(year from created_on) = extract(year from date(:month))
and created_by = cast(:userId as integer);',
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


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_csv_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b7c0218-6a89-4c38-8bd8-f20339aa4702', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_csv_details',
 null,
'select
	count(rcsm.*) filter (where lfvd2.value = ''Diarrhea'' and rcsm.is_treatement_done = ''YES'') as chw3_03,
	count(rcsm.*) filter (where lfvd2.value = ''Diarrhea'' and rcsm.referral_place is not null and lfvd.value = ''Danger signs'') as chw3_04,
	count(rcsm.*) filter (where lfvd2.value = ''Pneumonia'' and rcsm.is_treatement_done = ''YES'') as chw3_05,
	count(rcsm.*) filter (where lfvd2.value = ''Pneumonia'' and rcsm.referral_place is not null and lfvd.value = ''Danger signs'') as chw3_06,
	count(distinct rcsm.*) filter (where rcsm.delay_in_developmental) as chw3_08,
	count(rcsm.*) filter (where rcsm.exclusively_breastfeded) as chw3_09
from rch_child_service_master rcsm
left join listvalue_field_value_detail lfvd on cast(rcsm.referral_reason as integer) = lfvd.id
left join rch_child_service_diseases_rel rcsdr on rcsm.id = rcsdr.child_service_id
left join listvalue_field_value_detail lfvd2 on rcsdr.diseases = lfvd2.id
where extract(month from rcsm.service_date) = extract(month from date(:month))
and extract(year from rcsm.service_date) = extract(year from date(:month))
and rcsm.created_by = cast(:userId as integer);',
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


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_anc_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'39fc2b6a-ab20-49ba-865b-b8a38c82ae63', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_anc_details',
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
),
members_ancs AS (
  SELECT
    member_id,
    ROUND(EXTRACT(DAY FROM age(current_date, ram.lmp)) / 7.0) AS gestational_age_weeks,
    (SELECT COUNT(*) FROM rch_anc_master ram2 WHERE ram2.member_id = ram.pregnancy_reg_det_id) AS anc_visits
  FROM rch_anc_master ram
  where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))
	and ram.created_by = cast(:userId as integer)
)
select
	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))
	and (select count(*) from rch_anc_master where pregnancy_reg_det_id = ram.id) = 1) as chw2_03,
	(select count(*) from multiple_visits) as chw2_05,
	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_06,

	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month))
		and ram.service_date - ram.lmp  < interval ''3 months'') as chw2_07,

	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month)) and referral_infra_id is not null) as chw2_08,

	count(ram.*) filter (where extract(month from ram.service_date) = extract(month from date(:month)) and service_date <= lmp + INTERVAL ''12 weeks'') as chw2_09,

	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_10,
	count(ram.*) filter (where age(date(ram.service_date),rprd.lmp_date) > interval ''28 weeks'' and ram.having_birth_plan and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_11,

	(
		select coalesce(sum(
			CASE
				WHEN gestational_age_weeks <= 12 AND anc_visits >= 1 THEN 1
				WHEN gestational_age_weeks > 12 AND gestational_age_weeks <= 28 AND anc_visits >= 2 THEN 1
				WHEN gestational_age_weeks > 28 AND gestational_age_weeks <= 32 AND anc_visits >= 3 THEN 1
				WHEN gestational_age_weeks > 32 AND gestational_age_weeks <= 40 AND anc_visits >= 4 THEN 1
				ELSE 0
			END
		), 0) from members_ancs
	) as chw2_12,

	count(ram.*) filter (where dangerous_sign_id is not null or other_dangerous_sign is not null and extract(month from ram.service_date) = extract(month from date(:month))
	and extract(year from ram.service_date) = extract(year from date(:month))) as chw2_13
from rch_anc_master ram
inner join rch_pregnancy_registration_det rprd on rprd.id = ram.pregnancy_reg_det_id
where ram.created_by = cast(:userId as integer);',
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



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_mrf_user_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b8608eff-0dad-41d8-9a05-fe5940a6251b', 97067,  current_date , 97067,  current_date , 'retrieve_mrf_user_details',
 null,
'with locations as (
    select child_id as loc_id
    from location_hierchy_closer_det lhcd
    where lhcd.parent_id = (select loc_id from um_user_location where user_id = cast(:userId as integer) and state = ''ACTIVE'')
    and depth in (0,1)
),
total_cha_chv as (
    select
        count(*) filter (where urm.name = ''CHA'') as "totalCHA",
        count(*) filter (where urm.name = ''CHV'') as "totalCHV"
    from locations l
    inner join location_hierchy_closer_det lhcd on lhcd.parent_id = l.loc_id
    inner join um_user_location uul on uul.loc_id = lhcd.child_id
    inner join um_user uu on uu.id = uul.user_id
    inner join um_role_master urm on urm.id = uu.role_id
        and urm.name in (''CHA'', ''CHV'')
)
select
    concat_ws('' '', uu.first_name, uu.middle_name, uu.last_name) as chw,
    lm.english_name as zone,
    (select count(*) from imt_family
    where area_id = lm.id
    and basic_state in (''NEW'',''TEMPORARY'',''VERIFIED'',''REVERIFICATION'')
    ) as "zonewiseHHCount",
    tcc."totalCHA",
    tcc."totalCHV"
from um_user uu
inner join um_user_location uul on uu.id = uul.user_id and uul.state = ''ACTIVE'' and uu.id = cast(:userId as integer)
inner join location_master lm on lm.id = uul.loc_id
inner join total_cha_chv tcc on true',
'Used for Monthly Reporting Form',
true, 'ACTIVE');
