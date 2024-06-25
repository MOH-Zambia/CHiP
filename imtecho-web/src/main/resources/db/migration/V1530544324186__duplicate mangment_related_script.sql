INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'retrieve_duplicate_member_det','limit,offset',
'select member1_id,member1_family_id,member1_name,member1_dob,member1_gender
,member1_lmp_date,member1_location_id,member2_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member1_loc_name,member1_mobile_number,member2_mobile_number,
string_agg(mem2_location_master.name,'' > '' order by depth desc) member2_loc_name from (
select member1_id,member1_family_id,member1_name,member1_dob,member1_gender
,member1_lmp_date,member1_location_id,member1_mobile_number,member2_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date
,member2_location_id,member2_mobile_number,string_agg(mem1_location_master.name,'' > '' order by depth desc) member1_loc_name from (
select mem1.id member1_id,mem1.family_id as member1_family_id,concat(mem1.first_name,'' '',mem1.middle_name,'' '',mem1.last_name) as member1_name
,to_char(mem1.dob,''DD/MM/YYYY'') as member1_dob,mem1.gender as member1_gender , mem1.lmp as member1_lmp_date,mem1_family.location_id as member1_location_id,mem1.mobile_number as member1_mobile_number 
,mem2.id member2_id,mem2.family_id as member2_family_id,concat(mem2.first_name,'' '',mem2.middle_name,'' '',mem2.last_name) as member2_name
,to_char(mem2.dob,''DD/MM/YYYY'') as member2_dob,mem2.gender as member2_gender , mem2.lmp as member2_lmp_date,mem2_family.location_id as member2_location_id,mem2.mobile_number as member2_mobile_number 
 from (select * from imt_member_duplicate_member_detail where is_active = true limit #limit# offset #offset#) dup_det,imt_member mem1,imt_member mem2,imt_family mem1_family ,imt_family mem2_family
where dup_det.member1_id =  mem1.id and dup_det.member2_id = mem2.id and mem1.family_id = mem1_family.family_id and mem2.family_id = mem2_family.family_id) dup_det
,location_hierchy_closer_det mem1_loc_closer_det,location_master mem1_location_master 
where dup_det.member1_location_id = mem1_loc_closer_det.child_id and mem1_location_master.id = mem1_loc_closer_det.parent_id
group by member1_id,member1_family_id,member1_name,member1_dob,member1_gender
,member1_lmp_date,member1_location_id,member2_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member1_mobile_number,member2_mobile_number)dup_det
,location_hierchy_closer_det mem2_loc_closer_det,location_master mem2_location_master 
where dup_det.member2_location_id = mem2_loc_closer_det.child_id and mem2_location_master.id = mem2_loc_closer_det.parent_id
group by member1_id,member1_family_id,member1_name,member1_dob,member1_gender
,member1_lmp_date,member1_location_id,member2_id,member2_family_id,member2_name,member2_dob,member2_gender,member2_lmp_date,member2_location_id,member1_loc_name,member1_mobile_number,member2_mobile_number;'
,true,'ACTIVE','It will retrieve duplicate member detail');

INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'save_duplicate_member_det','id,is_member1_valid,is_member2_valid,action_by',
'update imt_member_duplicate_member_detail set 
is_member1_valid = #is_member1_valid# , is_member2_valid = #is_member2_valid# , is_active = false , modified_on = now(),modified_by = #action_by# 
where id = #id#;'
,true,'ACTIVE','It will call when duplicate member detail are save.');


INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'mark_member_as_duplicate','action_by,member_id',
'update techo_notification_master set state = ''MARK_AS_DUPLICATE'',modified_on = now(),modified_by = #action_by# where member_id = #member_id# 
and state in (''PENDING'',''RESCHEDULE'');

update event_mobile_notification_pending set is_completed =  true ,state = ''MARK_AS_DUPLICATE'',modified_by = #action_by#,modified_on = now()
from event_mobile_configuration where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id and member_id = #member_id# 
and state = ''PENDING'';

update imt_member set death_detail_id =rch_member_death_deatil.id,state = ''com.argusoft.imtecho.member.state.duplicate'',modified_on = now(),modified_by = #action_by# from  rch_member_death_deatil 
where imt_member.id = #member_id# and rch_member_death_deatil.member_id = imt_member.id;'
,true,'ACTIVE','It will call when any member is marked as duplicate.');



