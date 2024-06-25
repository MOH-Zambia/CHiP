INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Member Service Register','manage',TRUE,'techo.manage.memberserviceregister','{}');

delete from query_master where code = 'get_rch_service_register_detail';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail','location_id, to_date, from_date,limit, offset','
with location_det as(
select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
),dates as(
select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
)
, record_detail as (
select * from rch_member_services,location_det,dates
where service_date between dates.from_date and dates.to_date
and location_id = location_det.loc_id
limit #limit# offset #offset#
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
rec.service_type as "Service Type",  to_char(rec.service_date, ''DD/MM/YYYY'') as "Service Date", rec.loc_id as "hiddenlocation", rec.visit_id as "hiddenVisitId", mem.family_id as "Family Id", 
loc.name as "Location"
,concat(usr.first_name,'' '',usr.middle_name,'' '',usr.last_name,'' ('',usr.contact_number,'')'') as "ASHA  /ANM Name"
from record_detail rec
inner join imt_member mem on mem.id = rec.member_id 
inner join location_master loc on loc_id = loc.id
inner join um_user usr on usr.id = rec.user_id
order by  service_date desc 
',true,'ACTIVE');

delete from query_master where code = 'get_rch_service_register_detail_anc';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_anc','visitId','
with dangsign as ( select rel.anc_id,string_agg(det.value ,'', '') as dangeroussign from rch_anc_dangerous_sign_rel rel
inner join listvalue_field_value_detail det on rel.dangerous_sign_id = det.id group by rel.anc_id )
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id",
to_char(anc.lmp, ''DD/MM/YYYY'') as "LMP Date" , anc.weight as "Weight",
anc.jsy_beneficiary as "JSY Beneficiary",anc.kpsy_beneficiary as "KPSY Beneficiary", anc.iay_beneficiary as "IAY Beneficiary", 
anc.chiranjeevi_yojna_beneficiary as "Chiranjeevi Yojna Beneficiary",anc.anc_place as "ANC Place",anc.systolic_bp as "Systolic BP",
anc.diastolic_bp as "Diastolic BP",anc.member_height as "Member Height",anc.foetal_height as "Foetal Height",
anc.foetal_heart_sound as "Foetal Heart Sound",
anc.ifa_tablets_given as "Ifa Tablets Given",anc.fa_tablets_given as "Fa Tablets Given",anc.calcium_tablets_given as "Calcium Tablets Given",
anc.hbsag_test as "HBSAG Test",anc.blood_sugar_test as "Blood Sugar Test",anc.urine_test_done as "Urine Test Done",
anc.albendazole_given as "Albendazole Given",anc.dead_flag as "Is the Member Dead",anc.other_dangerous_sign as "Other Dangerous Sign",
anc.member_status as "Member Satus",to_char(anc.death_date, ''DD/MM/YYYY'') as "Death Date",anc.vdrl_test as "VDRL Test",anc.hiv_test as "HIV Test",
anc.place_of_death as "Place Of Death",anc.haemoglobin_count as "Haemoglobin Count",
anc.death_reason as "Death Reason",anc.jsy_payment_done as "JSY Payment Done",anc.last_delivery_outcome as "Last Delivery Outcome",
anc.expected_delivery_place as "Expected Delivery Place",
anc.family_planning_method as "Family Planning Method",anc.foetal_position as "Foetal Position",
anc.other_previous_pregnancy_complication as "Other Previous Pregnancy Complication",anc.foetal_movement as "Foetal Movement",
anc.urine_albumin as "Urine Albumin",anc.urine_sugar as "Urine Sugar",anc.is_high_risk_case as "Is High Risk Case",
anc.blood_group as "Blood Group",anc.sugar_test_after_food_val as "Sugar Test After Food Val",
anc.sugar_test_before_food_val as "Sugar Test Before Food Val",
to_char(anc.service_date, ''DD/MM/YYYY'')  as "Service Date",anc.sickle_cell_test as "Sickle Cell Test", 
dan.dangeroussign as "Dangerous Sign", ancplace.value as "ANC place name", referralplace.value as "Referral place Name"
from rch_anc_master anc 
inner join imt_member mem on anc.member_id = mem.id
left join dangsign dan on anc.id = dan.anc_id
left join listvalue_field_value_detail ancplace on anc.anc_place = ancplace.id
left join listvalue_field_value_detail referralplace on anc.referral_place = referralplace.id
where anc.id = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_lmp';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_lmp','visitId','
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id",
lmp.is_pregnant as "Is Pregnant", lmp.pregnancy_test_done as "Is Pregnancy Test Done",
lmp.family_planning_method as "Family Planning Method", to_char(lmp.fp_insert_operate_date, ''DD/MM/YYYY'') as "Fp Insert Operate Date", 
lmp.place_of_death as "Place Of Death", lmp.member_status as "Member Satus",to_char(lmp.death_date, ''DD/MM/YYYY'') as "Death Date",
lmp.death_reason as "Death Reason", to_char(lmp.service_date, ''DD/MM/YYYY'')  as "Service Date"
from rch_lmp_follow_up lmp
inner join imt_member mem on lmp.member_id = mem.id
where lmp.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'get_rch_service_register_detail_cs';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_cs','visitId','
select  
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id",
csm.is_alive as "Is Alive", csm.weight as "Weight", csm.ifa_syrup_given as "Ifa Syrup Given", 
csm.complementary_feeding_started as "Is Complementary Feeding Started",csm.is_treatement_done as "Is Treatement Done",
to_char(csm.death_date, ''DD/MM/YYYY'') as "Death Date",csm.place_of_death as "Place Of Death",
csm.member_status as "Member Status", csm.death_reason as "Death Reason", csm.other_death_reason as "Other Death Reason",
csm.complementary_feeding_start_period as "Complementary Feeding Start Period",csm.other_diseases as "Other Diseases",
csm.mid_arm_circumference as "Mid Arm Circumference",csm.height as "Height", csm.have_pedal_edema as "Have Pedal Edema",
csm.exclusively_breastfeded as "Exclusively Breastfeded",csm.any_vaccination_pending as "Any Vaccination Pending",
to_char(csm.service_date, ''DD/MM/YYYY'') as "Service Date",
csm.sd_score as "SD Score"
from rch_child_service_master csm 
inner join imt_member mem on csm.member_id = mem.id
where csm.id = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_pnc_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_pnc_mother','visitId','
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Mother Name",
mem.family_id as "Family Id", to_char(pm.service_date, ''DD/MM/YYYY'')  as "Service Date", pm.delivery_place as "Delivery Place", 
hos_type.value as "Hostpital Type", helth_infra.value as "Health Infrastructure", 
pm.delivery_done_by as "Delivery Done By", pm.delivery_person as "Delivery Person", pm.delivery_person_name as "Delivery Person Name",

to_char(pmm.date_of_delivery, ''DD/MM/YYYY'') as "Delivery Date", pmm.is_alive as "Is Alive", pmm.ifa_tablets_given as "IFA Tablets Given", 
pmm.other_danger_sign as "Other Danger Sign", pmm.is_high_risk_case as "Is HighRisk Case", 
to_char(pmm.death_date, ''DD/MM/YYYY'') as "Death Date", pmm.death_reason as "Death Reason", pmm.place_of_death as "Place Of Death",pmm.other_death_reason as "Other Death Reason", 
to_char(pmm.fp_insert_operate_date, ''DD/MM/YYYY'') as "FP Insert Oprate Date", pmm.family_planning_method as "Family Planning Method", 
pmm.member_status as "Mother Status"
from rch_pnc_master pm
inner join rch_pnc_mother_master pmm on pm.id = pmm.pnc_master_id
inner join imt_member mem on pmm.mother_id = mem.id
left join listvalue_field_value_detail hos_type on pm.type_of_hospital = hos_type.id
left join listvalue_field_value_detail helth_infra on pm.health_infrastructure_id = helth_infra.id
where pm.id = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_pnc_child';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_pnc_child','visitId','
select 	
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",mem.family_id as "Family Id", 
pcm.is_alive as "Is Alive", pcm.other_danger_sign as "Other Danger Sign", pcm.child_weight as "Child Weight", 
pcm.member_status as "Child Status", pcm.death_date as "Death Date", pcm.death_reason as "Death Reason", 
pcm.place_of_death as "Place Of Death",pcm.other_death_reason as "Other Death Reason", pcm.is_high_risk_case as "Is HighRisk Case"
from rch_pnc_child_master pcm 
inner join imt_member mem on pcm.child_id = mem.id
where pnc_master_id  = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_wpd_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_wpd_mother','visitId','
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id", 
to_char(mother.date_of_delivery, ''DD/MM/YYYY'')  as "Date Of Delivery",
mother.member_status as "Mother Status",
mother.is_preterm_birth as "Is Preterm Birth",
mother.delivery_place as "Delivery Place",hos_type.value as "Hostpital Type",
mother.type_of_delivery as "Type Of Delivery", mother.delivery_done_by as "Delivery Done By",mother.mother_alive as "Mother Alive",
to_char(mother.discharge_date, ''DD/MM/YYYY'') as "Discharge Date",
to_char(mother.death_date, ''DD/MM/YYYY'') as "Death Date", mother.death_reason as "Death Reason", mother.place_of_death  as "Place Of Death", 
mother.cortico_steroid_given as "Cortico Steroid Given", mother.mtp_done_at as "Mtp Done At",mother.mtp_performed_by as "Mtp Performed By",
mother.has_delivery_happened as "Has Delivery Happened",  mother.is_high_risk_case as "Is High Risk Case", 
mother.pregnancy_outcome as "Pregnancy Outcome", mother.is_discharged as "Is Discharged", mother.misoprostol_given as "Misoprostol Given",
mother.free_drop_delivery as "Free Drop Delivery", helth_infra.value as "Health Infrastructure", mother.other_death_reason as "Other Death Reason",
mother.institutional_delivery_place as "Institutional Delivery Place", 
mother.delivery_person_name as "Delivery Person Name"

from rch_wpd_mother_master mother
inner join imt_member mem on mother.member_id = mem.id 
left join listvalue_field_value_detail hos_type on mother.type_of_hospital = hos_type.id
left join listvalue_field_value_detail helth_infra on mother.health_infrastructure_id = helth_infra.id
where mother.id = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_wpd_child';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_wpd_child','visitId','
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",mem.family_id as "Family Id",
pregnancy_outcome as "Pregnancy Outcome", child.gender as "Gender", child.birth_weight as "Birth Weight", 
child.member_status as "Child Status",
child.baby_cried_at_birth  as "Is Baby Cried At Birth", 
child.death_date as "Death Date", child.death_reason as "Death Reason", child.place_of_death  as "Place Of Death",
child.type_of_delivery as "Type Of Delivery", 
child.breast_feeding_in_one_hour as "Is Breast Feeding In One Hour" , child.other_congential_deformity as "Other Congential Deformity" ,
child.is_high_risk_case as "Is High Risk Case", child.was_premature as "Was Premature" , child.breast_crawl as "Breast Crawl" , 
child.kangaroo_care as "Kangaroo Care", child.other_danger_sign as "Other Danger Sign"
from rch_wpd_child_master child
inner join imt_member mem on child.member_id = mem.id 
where child.wpd_mother_id = #visitId#
',true,'ACTIVE');



