update query_master 
set query = 
'select dup_det.id,member1_id,mem1_unique_health_id,member1_family_id,member1_name,member1_dob,member1_gender,member1_lmp_date,member1_location_id,member1_loc_name,member1_mobile_number,
	member2_id,mem2_unique_health_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member2_mobile_number,
string_agg(mem2_location_master.name,'' > '' order by depth desc) member2_loc_name 
from (
	select dup_det.id,member1_id,mem1_unique_health_id,member1_family_id,member1_name,member1_dob,member1_gender,member1_lmp_date,member1_location_id,member1_mobile_number,
		member2_id,mem2_unique_health_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member2_mobile_number,
		string_agg(mem1_location_master.name,'' > '' order by depth desc) member1_loc_name 
	from (
		select dup_det.id,mem1.id member1_id,mem1.unique_health_id as mem1_unique_health_id, mem1.family_id as member1_family_id,concat(mem1.first_name,'' '',mem1.middle_name,'' '',mem1.last_name) as member1_name
			,to_char(mem1.dob,''DD/MM/YYYY'') as member1_dob,mem1.gender as member1_gender , mem1.lmp as member1_lmp_date,
			mem1_family.location_id as member1_location_id,mem1.mobile_number as member1_mobile_number, mem2.id member2_id,mem2.unique_health_id as mem2_unique_health_id,mem2.family_id as member2_family_id,
			concat(mem2.first_name,'' '',mem2.middle_name,'' '',mem2.last_name) as member2_name,to_char(mem2.dob,''DD/MM/YYYY'') as member2_dob,
			mem2.gender as member2_gender , mem2.lmp as member2_lmp_date,mem2_family.location_id as member2_location_id,mem2.mobile_number as member2_mobile_number 
		 from (
			select * from imt_member_duplicate_member_detail limit #limit# offset #offset#
			)dup_det
		,imt_member mem1,imt_member mem2,imt_family mem1_family ,imt_family mem2_family
		where dup_det.member1_id =  mem1.id and dup_det.member2_id = mem2.id and mem1.family_id = mem1_family.family_id and mem2.family_id = mem2_family.family_id
	)dup_det
	,location_hierchy_closer_det mem1_loc_closer_det,location_master mem1_location_master 
	where dup_det.member1_location_id = mem1_loc_closer_det.child_id and mem1_location_master.id = mem1_loc_closer_det.parent_id
	group by member1_id,mem1_unique_health_id,member1_family_id,member1_name,member1_dob,member1_gender,dup_det.id
	,member1_lmp_date,member1_location_id,member2_id,mem2_unique_health_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member1_mobile_number,member2_mobile_number
)dup_det
,location_hierchy_closer_det mem2_loc_closer_det,location_master mem2_location_master 
where dup_det.member2_location_id = mem2_loc_closer_det.child_id and mem2_location_master.id = mem2_loc_closer_det.parent_id
group by member1_id,mem1_unique_health_id,member1_family_id,member1_name,member1_dob,member1_gender,dup_det.id
,member1_lmp_date,member1_location_id,member2_id,mem2_unique_health_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member1_loc_name,member1_mobile_number,member2_mobile_number;'
where code = 'training_eligible_count';

update menu_config set menu_type = 'manage' where navigation_state = 'techo.manage.duplicateMemberVerification'
