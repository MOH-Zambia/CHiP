ALTER TABLE IF EXISTS location_wise_analytics
add column if not exists lmp_count_by_location integer,
add column if not exists anc_count_by_location integer,
add column if not exists wpd_count_by_location integer,
add column if not exists pnc_count_by_location integer,
add column if not exists csv_count_by_location integer,
add column if not exists tb_count_by_location  integer,
add column if not exists malaria_count_by_location integer,
add column if not exists hiv_count_by_location integer,
add column if not exists total_family_count_by_location integer;

DELETE FROM QUERY_MASTER WHERE CODE='fhs_dashboard_data_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7dced090-bd73-4620-82a6-9694626ecfed', 97102,  current_date , 97102,  current_date , 'fhs_dashboard_data_update',
 null,
'begin;

WITH family_wise_details AS (
select fam.family_id,case when fam.area_id is null then fam.location_id else fam.area_id end as location_id1
				,count(mem.id) filter (where fam.created_by is null and mem.created_by is null)
				as imported_from_emamta_mem

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')) as total_member
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M'') as total_male
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F'') as total_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30) as total_member_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30 and mem.gender = ''M'') as total_male_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30 and mem.gender = ''F'') as total_female_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''629'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) >= 20 and date_part(''year'',age(mem.dob)) <= 40) as total_eligible_couple

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_unmarried_female
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_unmarried_male
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_male

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_unmarried_female
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_unmarried_male

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_male
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) between 0 and 18) as total_population_0_to_18

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) between 19 and 40) as total_population_19_to_40

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) > 40) as total_population_more_than_40
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.is_pregnant = true) as total_pregnant_woman

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.dob > CURRENT_DATE - INTERVAL ''5 year'') as child_less_then_5_year
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''IDSP'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''IDSP'')
					and mem.dob < CURRENT_DATE - INTERVAL ''60 year'') as member_60_plus_age


		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.mobile_number is not null) as member_with_mobile_num

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.dob > CURRENT_DATE - INTERVAL ''1 year'') as total_0to1_children

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''DEAD'')
					and dob > rch_member_death_deatil.dod - interval ''1 year'') as total_infant_deaths

		,count(distinct mem.family_id) filter (where fam.created_by is null) as imported

		,count(distinct mem.family_id) filter (where fam.basic_state in (''UNVERIFIED'',''ORPHAN'')) as toBeProcessed

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')) as Verified

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')
			and  fam.modified_on > CURRENT_DATE - INTERVAL ''3 day'' ) as verified_last_3days

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')
			and  fam.migratory_flag) as seasonal_migrant_family

				,count(distinct mem.family_id) filter (where fam.basic_state in (''ARCHIVED'')) as Archived

		,count(distinct mem.family_id) filter (where fam.basic_state in (''REVERIFICATION'')) as inReverification

		,count(distinct mem.family_id) filter (where fam.basic_state in (''NEW'')) as newFamily
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''FHW'') as chfc_member_verified_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''ASHA'') as chfc_member_verified_by_asha
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''MPHW'') as chfc_member_verified_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'') and um.code = ''FHW'') as chfc_family_verified_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'') and um.code = ''MPHW'') as chfc_family_verified_by_mphw
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''FHW'') as chfc_new_member_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''ASHA'') as chfc_new_member_by_asha
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''MPHW'') as chfc_new_member_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''FHW'') as chfc_new_family_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''ASHA'') as chfc_new_family_by_asha
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''MPHW'') as chfc_new_family_by_mphw
		,count(mem.id) filter (where mem.state in (''CFHC_MIR'') and um.code = ''FHW'') as chfc_member_in_reverification_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MIR'') and um.code = ''MPHW'') as chfc_member_in_reverification_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FIR'') and um.code = ''FHW'') as chfc_family_in_reverification_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FIR'') and um.code = ''MPHW'') as chfc_family_in_reverification_by_mphw
        ,case when count(mem.id) filter (where fam.basic_state  in (''UNVERIFIED'', ''NEW'', ''VERIFIED'') and
         mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) >= 1 then 1 else 0 end as chfc_remaining_family
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 1 then 1 else 0 end as chfc_single_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 1 then 1 else 0 end as chfc_single_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 2 then 1 else 0 end as chfc_two_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 2 then 1 else 0 end as chfc_two_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 3 then 1 else 0 end as chfc_three_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 3 then 1 else 0 end as chfc_three_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) > 3 then 1 else 0 end as chfc_more_then_three_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) > 3 then 1 else 0 end as chfc_more_then_three_member_newly_added_families

		from imt_family fam
		inner join imt_member mem on fam.family_id = mem.family_id
		left join rch_member_death_deatil on mem.death_detail_id = rch_member_death_deatil.id
		left join imt_family_cfhc_done_by_details chfc on chfc.family_id = fam.family_id
		left join um_role_master um on um.id = chfc.role_id
		group by fam.family_id,location_id1
),
location_wise_details as (
select location_id1 as location_id
,sum(imported) as imported
,sum(imported_from_emamta_mem) as imported_from_emamta_mem
,sum(toBeProcessed) as toBeProcessed
,sum(Verified) as Verified
,sum(Archived) as Archived
,sum(newFamily) as newFamily
,sum(total_member) as total_member
,sum(total_male) as total_male
,sum(total_female) as total_female
,sum(total_member_over_thirty) as total_member_over_thirty
,sum(total_male_over_thirty) as total_male_over_thirty
,sum(total_female_over_thirty) as total_female_over_thirty
,sum(inReverification ) as inReverification
,sum(verified_last_3days ) as verified_last_3days
,sum(seasonal_migrant_family) as seasonal_migrant_family
,sum(total_infant_deaths) as total_infant_deaths
,sum(total_eligible_couple ) as total_eligible_couple
,sum(total_pregnant_woman ) as total_pregnant_woman
,sum(child_less_then_5_year ) as child_less_then_5_year
,sum(member_60_plus_age ) as member_60_plus_age
,sum(member_with_mobile_num) as member_with_mobile_num
,sum(total_0to1_children) as total_0to1_children
,sum(total_10_to_14_unmarried_female) as total_10_to_14_unmarried_female
,sum(total_10_to_14_unmarried_male) as total_10_to_14_unmarried_male
,sum(total_15_to_18_unmarried_female) as total_15_to_18_unmarried_female
,sum(total_15_to_18_unmarried_male) as total_15_to_18_unmarried_male
,sum(total_10_to_14_male) as total_10_to_14_male
,sum(total_10_to_14_female) as total_10_to_14_female
,sum(total_15_to_18_male) as total_15_to_18_male
,sum(total_15_to_18_female) as total_15_to_18_female
,sum(total_population_0_to_18) as total_population_0_to_18
,sum(total_population_19_to_40) as total_population_19_to_40
,sum(total_population_more_than_40) as total_population_more_than_40
,sum(chfc_member_verified_by_fhw) as chfc_member_verified_by_fhw
,sum(chfc_member_verified_by_asha) as chfc_member_verified_by_asha
,sum(chfc_member_verified_by_mphw) as chfc_member_verified_by_mphw
,sum(chfc_family_verified_by_fhw) as chfc_family_verified_by_fhw
,sum(chfc_family_verified_by_mphw) as chfc_family_verified_by_mphw
,sum(chfc_new_member_by_fhw) as chfc_new_member_by_fhw
,sum(chfc_new_member_by_asha) as chfc_new_member_by_asha
,sum(chfc_new_member_by_mphw) as chfc_new_member_by_mphw
,sum(chfc_new_family_by_fhw) as chfc_new_family_by_fhw
,sum(chfc_new_family_by_asha) as chfc_new_family_by_asha
,sum(chfc_new_family_by_mphw) as chfc_new_family_by_mphw
,sum(chfc_member_in_reverification_by_fhw) as chfc_member_in_reverification_by_fhw
,sum(chfc_member_in_reverification_by_mphw) as chfc_member_in_reverification_by_mphw
,sum(chfc_family_in_reverification_by_fhw) as chfc_family_in_reverification_by_fhw
,sum(chfc_family_in_reverification_by_mphw) as chfc_family_in_reverification_by_mphw
,sum(case when chfc_remaining_family = 1 then total_member else 0 end) as chfc_remaining_family
,sum(chfc_single_member_existing_families) as chfc_single_member_existing_families
,sum(chfc_single_member_newly_added_families) as chfc_single_member_newly_added_families
,sum(chfc_two_member_existing_families) as chfc_two_member_existing_families
,sum(chfc_two_member_newly_added_families) as chfc_two_member_newly_added_families
,sum(chfc_three_member_existing_families) as chfc_three_member_existing_families
,sum(chfc_three_member_newly_added_families) as chfc_three_member_newly_added_families
,sum(chfc_more_then_three_member_existing_families) as chfc_more_then_three_member_existing_families
,sum(chfc_more_then_three_member_newly_added_families) as chfc_more_then_three_member_newly_added_families
from family_wise_details fwd
group by location_id
),lmp_count_by_location as(
    select count(*) as lmp_count,location_id  from rch_lmp_follow_up rlfu  group by location_id
),anc_count_by_location as(
	    select count(*) as anc_count,location_id  from rch_anc_master  group by location_id
),wpd_count_by_location as(
	    select count(*) as wpd_count,location_id from rch_wpd_mother_master  group by location_id
),pnc_count_by_location as (
	    select count(*) as pnc_count,location_id from rch_pnc_master rpm group by location_id
),csv_count_by_location as(
	    select count(*) as csv_count,location_id  from rch_child_service_master rcsm  group by location_id
),tb_count_by_location as (
	    select count(*) as tb_count,location_id  from tuberculosis_screening_details  group by location_id
),malaria_count_by_location as(
	    select count(*) as malaria_count,location_id  from malaria_details  group by location_id
),hiv_count_by_location as(
	    select count(*) as hiv_count,location_id from rch_hiv_screening_master group by location_id
)

update location_wise_analytics
		set fhs_imported_from_emamta_family = fhs_det.imported
		,fhs_imported_from_emamta_member = fhs_det.imported_from_emamta_mem
		,fhs_to_be_processed_family = fhs_det.toBeProcessed
		,fhs_verified_family = fhs_det.Verified
		,fhs_archived_family = fhs_det.Archived
		,fhs_new_family = fhs_det.newFamily
		,fhs_total_member = fhs_det.total_member
		,total_male = fhs_det.total_male
		,total_female = fhs_det.total_female
		,total_member_over_thirty = fhs_det.total_member_over_thirty
		,total_male_over_thirty = fhs_det.total_male_over_thirty
		,total_female_over_thirty = fhs_det.total_female_over_thirty
				,fhs_inreverification_family = fhs_det.inReverification
		,family_varified_last_3_days = fhs_det.verified_last_3days
		,seasonal_migrant_families  = fhs_det.seasonal_migrant_family
		,eligible_couples_in_techo  = fhs_det.total_eligible_couple
		,pregnant_woman_techo  = fhs_det.total_pregnant_woman
		,child_under_5_year  = fhs_det.child_less_then_5_year
		,member_60_plus_age  = fhs_det.member_60_plus_age
		,member_with_mobile_number  = fhs_det.member_with_mobile_num
		,total_0to1_children = fhs_det.total_0to1_children
		,total_0to5_children = fhs_det.child_less_then_5_year
		,total_10_to_14_unmarried_female = fhs_det.total_10_to_14_unmarried_female
		,total_10_to_14_unmarried_male = fhs_det.total_10_to_14_unmarried_male
		,total_15_to_18_unmarried_female = fhs_det.total_15_to_18_unmarried_female
		,total_15_to_18_unmarried_male = fhs_det.total_15_to_18_unmarried_male
		,total_infant_deaths = fhs_det.total_infant_deaths
	,total_10_to_14_male = fhs_det.total_10_to_14_male
	,total_10_to_14_female = fhs_det.total_10_to_14_female
	,total_15_to_18_male = fhs_det.total_15_to_18_male
		,total_15_to_18_female = fhs_det.total_15_to_18_female
		,total_population_0_to_18 = fhs_det.total_population_0_to_18
		,total_population_19_to_40 = fhs_det.total_population_19_to_40
		,total_population_more_than_40 = fhs_det.total_population_more_than_40
		,chfc_member_verified_by_fhw = fhs_det.chfc_member_verified_by_fhw
		,chfc_member_verified_by_asha = fhs_det.chfc_member_verified_by_asha
,chfc_member_verified_by_mphw = fhs_det.chfc_member_verified_by_mphw
,chfc_family_verified_by_fhw = fhs_det.chfc_family_verified_by_fhw
,chfc_family_verified_by_mphw = fhs_det.chfc_family_verified_by_mphw
,chfc_new_member_by_fhw = fhs_det.chfc_new_member_by_fhw
,chfc_new_member_by_asha = fhs_det.chfc_new_member_by_asha
,chfc_new_member_by_mphw = fhs_det.chfc_new_member_by_mphw
,chfc_new_family_by_fhw = fhs_det.chfc_new_family_by_fhw
,chfc_new_family_by_asha = fhs_det.chfc_new_family_by_asha
,chfc_new_family_by_mphw = fhs_det.chfc_new_family_by_mphw
,chfc_member_in_reverification_by_fhw = fhs_det.chfc_member_in_reverification_by_fhw
,chfc_member_in_reverification_by_mphw = fhs_det.chfc_member_in_reverification_by_mphw
,chfc_family_in_reverification_by_fhw = fhs_det.chfc_family_in_reverification_by_fhw
,chfc_family_in_reverification_by_mphw = fhs_det.chfc_family_in_reverification_by_mphw
,chfc_remaining_family = fhs_det.chfc_remaining_family
,chfc_single_member_existing_families = fhs_det.chfc_single_member_existing_families
,chfc_single_member_newly_added_families = fhs_det.chfc_single_member_newly_added_families
,chfc_two_member_existing_families = fhs_det.chfc_two_member_existing_families
,chfc_two_member_newly_added_families = fhs_det.chfc_two_member_newly_added_families
,chfc_three_member_existing_families = fhs_det.chfc_three_member_existing_families
,chfc_three_member_newly_added_families = fhs_det.chfc_three_member_newly_added_families
,chfc_more_then_three_member_existing_families = fhs_det.chfc_more_then_three_member_existing_families
,chfc_more_then_three_member_newly_added_families = fhs_det.chfc_more_then_three_member_newly_added_families
,lmp_count_by_location = fhs_det.lmp_count
,anc_count_by_location = fhs_det.anc_count
,wpd_count_by_location = fhs_det.wpd_count
,pnc_count_by_location = fhs_det.pnc_count
,csv_count_by_location = fhs_det.csv_count
,tb_count_by_location = fhs_det.tb_count
,malaria_count_by_location = fhs_det.malaria_count
,hiv_count_by_location = fhs_det.hiv_count
,total_family_count_by_location = fhs_inreverification_family + fhs_verified_family + fhs_new_family
		from (
		select loc.id, mem_det.imported,mem_det.imported_from_emamta_mem
		,mem_det.toBeProcessed,mem_det.Verified ,mem_det.Archived ,mem_det.newFamily
		,mem_det.total_member ,mem_det.total_male, mem_det.total_female ,mem_det.total_member_over_thirty
		,mem_det.total_male_over_thirty, mem_det.total_female_over_thirty
		,mem_det.inReverification ,verified_last_3days ,seasonal_migrant_family
		,total_infant_deaths
		,total_eligible_couple ,total_pregnant_woman ,child_less_then_5_year
		,member_60_plus_age
		,member_with_mobile_num,total_0to1_children
		,total_10_to_14_unmarried_female,total_10_to_14_unmarried_male
		,total_15_to_18_unmarried_female,total_15_to_18_unmarried_male
	,total_10_to_14_male
	,total_10_to_14_female
	,total_15_to_18_male
		,total_15_to_18_female
		,total_population_0_to_18
		,total_population_19_to_40
		,total_population_more_than_40
		,chfc_member_verified_by_fhw
		,chfc_member_verified_by_asha
		,chfc_member_verified_by_mphw
,chfc_family_verified_by_fhw
,chfc_family_verified_by_mphw
,chfc_new_member_by_fhw
,chfc_new_member_by_asha
,chfc_new_member_by_mphw
,chfc_new_family_by_fhw
,chfc_new_family_by_asha
,chfc_new_family_by_mphw
,chfc_member_in_reverification_by_fhw
,chfc_member_in_reverification_by_mphw
,chfc_family_in_reverification_by_fhw
,chfc_family_in_reverification_by_mphw
,chfc_remaining_family
,chfc_single_member_existing_families
,chfc_single_member_newly_added_families
,chfc_two_member_existing_families
,chfc_two_member_newly_added_families
,chfc_three_member_existing_families
,chfc_three_member_newly_added_families
,chfc_more_then_three_member_existing_families
,chfc_more_then_three_member_newly_added_families
,lmp_count
,anc_count
,wpd_count
,pnc_count
,csv_count
,tb_count
,malaria_count
,hiv_count

		from location_master loc
			left join location_wise_details as mem_det
			on loc.id = mem_det.location_id
			left join lmp_count_by_location as lcbl
			on mem_det.location_id = lcbl.location_id
			left join anc_count_by_location as acbl
			on mem_det.location_id = acbl.location_id
			left join wpd_count_by_location as wcbl
			on mem_det.location_id = wcbl.location_id
			left join pnc_count_by_location as pcbl
			on mem_det.location_id = pcbl.location_id
			left join csv_count_by_location as ccbl
			on mem_det.location_id = ccbl.location_id
			left join tb_count_by_location as tcbl
			on mem_det.location_id = tcbl.location_id
			left join malaria_count_by_location as mcbl
			on mem_det.location_id = mcbl.location_id
			left join hiv_count_by_location as hcbl
			on mem_det.location_id = hcbl.location_id

		) as fhs_det
		where fhs_det.id = location_wise_analytics.loc_id;



update system_configuration  set key_value = cast(cast(EXTRACT(EPOCH FROM clock_timestamp()) * 1000 as bigint)as text) where system_key = ''FHS_LAST_UPDATE_TIME'';
update timer_event SET completed_on = clock_timestamp(),status = ''COMPLETED''
where event_config_id in (7,8) and status = ''PROCESSED'';
commit;',
'This will update fhs dashboard data',
false, 'ACTIVE');