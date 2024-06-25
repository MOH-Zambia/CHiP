delete from query_master where code = 'get_rch_service_register_detail';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail','location_id,to_date,from_date,limit,offset,serviceType','
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
and service_type = ''#serviceType#''
order by  service_date desc
limit #limit# offset #offset#
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
to_char(rec.service_date, ''DD/MM/YYYY'') as "Service Date", rec.loc_id as "hiddenlocation", rec.visit_id as "hiddenVisitId", mem.family_id as "Family Id", 
get_location_hierarchy(rec.loc_id) as "Location"
,concat(usr.first_name,'' '',usr.middle_name,'' '',usr.last_name,'' ('',usr.contact_number,'')'') as "ASHA/ANM Name"
from record_detail rec
inner join imt_member mem on mem.id = rec.member_id 
inner join location_master loc on loc_id = loc.id
inner join um_user usr on usr.id = rec.user_id
',true,'ACTIVE');

delete from query_master where code = 'get_rch_service_register_detail_anc';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_anc','visitId','
with dangsign as ( select rel.anc_id,string_agg(det.value ,'', '') as dangeroussign from rch_anc_dangerous_sign_rel rel
inner join listvalue_field_value_detail det on rel.dangerous_sign_id = det.id group by rel.anc_id )
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id",
case when anc.lmp is not null then to_char(anc.lmp, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "LMP Date", 
case when anc.weight is not null then anc.weight \:\:text  else ''Not Available'' end as "Weight",
case when anc.jsy_beneficiary is not null then case when anc.jsy_beneficiary = ''true'' then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "JSY Beneficiary",
case when anc.kpsy_beneficiary is not null then case when anc.kpsy_beneficiary then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "KPSY Beneficiary", 
case when anc.iay_beneficiary is not null then case when anc.iay_beneficiary then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "IAY Beneficiary", 
case when anc.chiranjeevi_yojna_beneficiary is not null then case when anc.chiranjeevi_yojna_beneficiary then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Chiranjeevi Yojna Beneficiary",
case when anc.anc_place is not null then anc.anc_place \:\:text  else ''Not Available'' end as "ANC Place",
case when anc.systolic_bp is not null then anc.systolic_bp \:\:text  else ''Not Available'' end as "Systolic BP",
case when anc.diastolic_bp is not null then anc.diastolic_bp \:\:text  else ''Not Available'' end as "Diastolic BP",
case when anc.member_height is not null then anc.member_height \:\:text  else ''Not Available'' end as "Member Height",
case when anc.foetal_height is not null then anc.foetal_height \:\:text  else ''Not Available'' end as "Foetal Height",
case when anc.foetal_heart_sound is not null then case when  anc.foetal_heart_sound  then ''Yes'' else ''No'' end  \:\:text  else ''Not Available'' end as "Foetal Heart Sound",
case when anc.ifa_tablets_given is not null then anc.ifa_tablets_given \:\:text  else ''Not Available'' end as "Ifa Tablets Given",
case when anc.fa_tablets_given is not null then anc.fa_tablets_given  \:\:text  else ''Not Available'' end as "Fa Tablets Given",
case when anc.calcium_tablets_given is not null then anc.calcium_tablets_given  \:\:text  else ''Not Available'' end as "Calcium Tablets Given",
case when anc.hbsag_test is not null then anc.hbsag_test \:\:text  else ''Not Available'' end as "HBSAG Test",
case when anc.blood_sugar_test is not null then anc.blood_sugar_test \:\:text  else ''Not Available'' end as "Blood Sugar Test",
case when anc.urine_test_done is not null then case when  anc.urine_test_done  then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Urine Test Done",
case when anc.albendazole_given is not null then case when  anc.albendazole_given  then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Albendazole Given",
case when anc.dead_flag is not null then case when  anc.dead_flag  then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Is the Member Dead",
case when anc.other_dangerous_sign is not null then anc.other_dangerous_sign \:\:text  else ''Not Available'' end as "Other Dangerous Sign",
case when anc.member_status is not null then anc.member_status \:\:text  else ''Not Available'' end as "Member Satus",
case when anc.death_date is not null then to_char(anc.death_date, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Death Date",
case when anc.vdrl_test is not null then anc.vdrl_test \:\:text  else ''Not Available'' end as "VDRL Test",
case when anc.hiv_test is not null then anc.hiv_test  \:\:text  else ''Not Available'' end as "HIV Test",
case when anc.place_of_death is not null then anc.place_of_death \:\:text  else ''Not Available'' end as "Place Of Death",
case when anc.haemoglobin_count is not null then anc.haemoglobin_count end as "Haemoglobin Count",
case when anc.death_reason is not null then anc.death_reason \:\:text  else ''Not Available'' end as "Death Reason",
case when anc.jsy_payment_done is not null then case when  anc.jsy_payment_done then ''Yes'' else ''No'' end  \:\:text  else ''Not Available'' end as "JSY Payment Done",
case when anc.last_delivery_outcome is not null then anc.last_delivery_outcome \:\:text  else ''Not Available'' end as "Last Delivery Outcome",
case when anc.expected_delivery_place is not null then anc.expected_delivery_place \:\:text  else ''Not Available'' end as "Expected Delivery Place",
case when anc.family_planning_method is not null then anc.family_planning_method \:\:text  else ''Not Available'' end as "Family Planning Method",
case when anc.foetal_position is not null then anc.foetal_position \:\:text  else ''Not Available'' end as "Foetal Position",
case when anc.other_previous_pregnancy_complication is not null then anc.other_previous_pregnancy_complication \:\:text  else ''Not Available'' end as "Other Previous Pregnancy Complication",
case when anc.foetal_movement is not null then anc.foetal_movement \:\:text  else ''Not Available'' end as "Foetal Movement",
case when anc.urine_albumin is not null then anc.urine_albumin \:\:text  else ''Not Available'' end as "Urine Albumin",
case when anc.urine_sugar is not null then anc.urine_sugar \:\:text  else ''Not Available'' end as "Urine Sugar",
case when anc.is_high_risk_case is not null then case when  anc.is_high_risk_case  then ''Yes'' else ''No'' end  \:\:text  else ''Not Available'' end as "Is High Risk Case",
case when anc.blood_group is not null then anc.blood_group \:\:text  else ''Not Available'' end as "Blood Group",
case when anc.sugar_test_after_food_val is not null then anc.sugar_test_after_food_val \:\:text  else ''Not Available'' end as "Sugar Test After Food Val",
case when anc.sugar_test_before_food_val is not null then anc.sugar_test_before_food_val \:\:text  else ''Not Available'' end as "Sugar Test Before Food Val",
case when anc.service_date is not null then to_char(anc.service_date, ''DD/MM/YYYY'')  \:\:text  else ''Not Available'' end as "Service Date",
case when anc.sickle_cell_test is not null then anc.sickle_cell_test \:\:text  else ''Not Available'' end as "Sickle Cell Test", 
case when dan.dangeroussign is not null then dan.dangeroussign \:\:text  else ''Not Available'' end as "Dangerous Sign", 
case when ancplace.value is not null then ancplace.value \:\:text  else ''Not Available'' end as "ANC place name", 
case when referralplace.value is not null then referralplace.value \:\:text  else ''Not Available'' end as "Referral place Name"
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
case when lmp.is_pregnant is not null then case when lmp.is_pregnant = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Is Pregnant", 
case when lmp.pregnancy_test_done is not null then case when lmp.pregnancy_test_done = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Is Pregnancy Test Done",
case when lmp.family_planning_method is not null then lmp.family_planning_method \:\:text else ''Not Available'' end as "Family Planning Method", 
case when lmp.fp_insert_operate_date is not null then to_char(lmp.fp_insert_operate_date, ''DD/MM/YYYY'') \:\:text else ''Not Available'' end as "Fp Insert Operate Date", 
case when lmp.place_of_death is not null then lmp.place_of_death \:\:text else ''Not Available'' end as "Place Of Death", 
case when lmp.member_status is not null then lmp.member_status \:\:text else ''Not Available'' end as "Member Satus",
case when lmp.death_date is not null then to_char(lmp.death_date, ''DD/MM/YYYY'') \:\:text else ''Not Available'' end as "Death Date",
case when lmp.death_reason is not null then lmp.death_reason \:\:text else ''Not Available'' end as "Death Reason", 
case when lmp.service_date is not null then to_char(lmp.service_date, ''DD/MM/YYYY'')  \:\:text else ''Not Available'' end as "Service Date"
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
case when csm.is_alive is not null then case when csm.is_alive = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as  "Is Alive", 
case when csm.weight is not null then csm.weight \:\:text else ''Not Available'' end as "Weight", 
case when csm.ifa_syrup_given is not null then case when csm.ifa_syrup_given = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Ifa Syrup Given", 
case when csm.complementary_feeding_started is not null then case when csm.complementary_feeding_started = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Is Complementary Feeding Started",
case when csm.is_treatement_done is not null then csm.is_treatement_done \:\:text else ''Not Available'' end as "Is Treatement Done",
case when csm.death_date is not null then to_char(csm.death_date, ''DD/MM/YYYY'') \:\:text else ''Not Available'' end as "Death Date",
case when csm.place_of_death is not null then csm.place_of_death \:\:text else ''Not Available'' end as "Place Of Death",
case when csm.member_status is not null then csm.member_status \:\:text else ''Not Available'' end as "Member Status", 
case when csm.death_reason is not null then csm.death_reason \:\:text else ''Not Available'' end as "Death Reason", 
case when csm.other_death_reason is not null then csm.other_death_reason \:\:text else ''Not Available'' end as "Other Death Reason",
case when csm.complementary_feeding_start_period is not null then csm.complementary_feeding_start_period \:\:text else ''Not Available'' end as "Complementary Feeding Start Period",
case when csm.other_diseases is not null then csm.other_diseases \:\:text else ''Not Available'' end as "Other Diseases",
case when csm.mid_arm_circumference is not null then csm.mid_arm_circumference \:\:text else ''Not Available'' end as "Mid Arm Circumference",
case when csm.height is not null then csm.height \:\:text else ''Not Available'' end as "Height", 
case when csm.have_pedal_edema is not null then case when csm.have_pedal_edema = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Have Pedal Edema",
case when csm.exclusively_breastfeded is not null then case when csm.exclusively_breastfeded = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Exclusively Breastfeded",
case when csm.any_vaccination_pending is not null then case when csm.any_vaccination_pending = ''true'' then ''Yes'' else ''No'' end \:\:text else ''Not Available'' end as "Any Vaccination Pending",
case when csm.service_date is not null then to_char(csm.service_date, ''DD/MM/YYYY'') \:\:text else ''Not Available'' end as "Service Date",
case when csm.sd_score is not null then csm.sd_score \:\:text else ''Not Available'' end as "SD Score"
from rch_child_service_master csm 
inner join imt_member mem on csm.member_id = mem.id
where csm.id = #visitId#
',true,'ACTIVE');


delete from query_master where code = 'get_rch_service_register_detail_pnc_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_pnc_mother','visitId','
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Mother Name",
mem.family_id as "Family Id", 
case when pm.service_date is not null then to_char(pm.service_date , ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Service Date", 
case when pm.delivery_place is not null then pm.delivery_place \:\:text  else ''Not Available'' end as "Delivery Place", 
case when hos_type.value is not null then hos_type.value \:\:text  else ''Not Available'' end as "Hostpital Type", 
case when helth_infra.value is not null then helth_infra.value \:\:text  else ''Not Available'' end as "Health Infrastructure", 
case when pm.delivery_done_by is not null then  pm.delivery_done_by \:\:text  else ''Not Available'' end as "Delivery Done By", 
case when pm.delivery_person is not null then  pm.delivery_person \:\:text  else ''Not Available'' end as "Delivery Person", 
case when pm.delivery_person_name is not null then  pm.delivery_person_name \:\:text  else ''Not Available'' end as "Delivery Person Name",

case when pmm.date_of_delivery is not null then  to_char(pmm.date_of_delivery, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Delivery Date", 
case when pmm.is_alive is not null then case when pmm.is_alive then ''Yes'' else ''No'' end  \:\:text  else ''Not Available'' end as "Is Alive", 
case when pmm.ifa_tablets_given is not null then pmm.ifa_tablets_given \:\:text  else ''Not Available'' end as "IFA Tablets Given", 
case when pmm.other_danger_sign is not null then pmm.other_danger_sign \:\:text  else ''Not Available'' end as "Other Danger Sign", 
case when pmm.is_high_risk_case is not null then case when pmm.is_high_risk_case then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Is HighRisk Case", 
case when pmm.death_date is not null then to_char(pmm.death_date, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Death Date", 
case when pmm.death_reason is not null then pmm.death_reason \:\:text  else ''Not Available'' end as "Death Reason", 
case when pmm.place_of_death is not null then pmm.place_of_death \:\:text  else ''Not Available'' end as "Place Of Death",
case when pmm.other_death_reason is not null then pmm.other_death_reason \:\:text  else ''Not Available'' end as "Other Death Reason", 
case when pmm.fp_insert_operate_date is not null then to_char( pmm.fp_insert_operate_date, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "FP Insert Oprate Date", 
case when pmm.family_planning_method is not null then pmm.family_planning_method \:\:text  else ''Not Available'' end as "Family Planning Method", 
case when pmm.member_status is not null then pmm.member_status \:\:text  else ''Not Available'' end as "Mother Status"
from rch_pnc_master pm
inner join rch_pnc_mother_master pmm on pm.id = pmm.pnc_master_id
inner join imt_member mem on pmm.mother_id = mem.id
left join listvalue_field_value_detail hos_type on pm.type_of_hospital = hos_type.id
left join listvalue_field_value_detail helth_infra on pm.health_infrastructure_id = helth_infra.id
where pm.id = #visitId#
',true,'ACTIVE');



delete from query_master where code = 'get_rch_service_register_detail_wpd_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail_wpd_mother','visitId','


select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
	mem.family_id as "Family Id", 
case when mother.date_of_delivery is not null then to_char(mother.date_of_delivery, ''DD/MM/YYYY'')  \:\:text  else ''Not Available'' end as "Date Of Delivery",
case when mother.member_status is not null then mother.member_status \:\:text  else ''Not Available'' end as "Mother Status",
case when mother.is_preterm_birth is not null then case when  mother.is_preterm_birth then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Is Preterm Birth",
case when mother.delivery_place is not null then mother.delivery_place \:\:text  else ''Not Available'' end as "Delivery Place",
case when hos_type.value is not null then hos_type.value \:\:text  else ''Not Available'' end as "Hostpital Type",
case when mother.type_of_delivery is not null then mother.type_of_delivery \:\:text  else ''Not Available'' end as "Type Of Delivery", 
case when mother.delivery_done_by is not null then mother.delivery_done_by \:\:text  else ''Not Available'' end as "Delivery Done By",
case when mother.mother_alive is not null then mother.mother_alive \:\:text  else ''Not Available'' end as "Mother Alive",
case when mother.discharge_date is not null then to_char(mother.discharge_date, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Discharge Date",
case when mother.death_date is not null then to_char(mother.death_date, ''DD/MM/YYYY'') \:\:text  else ''Not Available'' end as "Death Date", 
case when mother.death_reason is not null then mother.death_reason \:\:text  else ''Not Available'' end as "Death Reason", 
case when mother.place_of_death is not null then mother.place_of_death  \:\:text  else ''Not Available'' end as "Place Of Death", 
case when mother.cortico_steroid_given is not null then case when  mother.cortico_steroid_given then ''Yes'' else ''No'' end  \:\:text  else ''Not Available'' end as "Cortico Steroid Given", 
case when mother.mtp_done_at is not null then mother.mtp_done_at \:\:text  else ''Not Available'' end as "Mtp Done At",
case when mother.mtp_performed_by is not null then mother.mtp_performed_by \:\:text  else ''Not Available'' end as "Mtp Performed By",
case when mother.has_delivery_happened is not null then case when mother.has_delivery_happened then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Has Delivery Happened",  
case when mother.is_high_risk_case is not null then case when mother.is_high_risk_case then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Is High Risk Case", 
case when mother.pregnancy_outcome is not null then mother.pregnancy_outcome \:\:text  else ''Not Available'' end as "Pregnancy Outcome", 
case when mother.is_discharged is not null then case when mother.is_discharged then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Is Discharged", 
case when mother.misoprostol_given is not null then case when mother.misoprostol_given then ''Yes'' else ''No'' end \:\:text  else ''Not Available'' end as "Misoprostol Given",
case when mother.free_drop_delivery is not null then mother.free_drop_delivery \:\:text  else ''Not Available'' end as "Free Drop Delivery", 
case when helth_infra.value is not null then helth_infra.value \:\:text  else ''Not Available'' end as "Health Infrastructure", 
case when mother.other_death_reason is not null then mother.other_death_reason \:\:text  else ''Not Available'' end as "Other Death Reason",
case when mother.institutional_delivery_place is not null then mother.institutional_delivery_place \:\:text  else ''Not Available'' end as "Institutional Delivery Place", 
case when mother.delivery_person_name is not null then mother.delivery_person_name \:\:text  else ''Not Available'' end as "Delivery Person Name"

from rch_wpd_mother_master mother
inner join imt_member mem on mother.member_id = mem.id 
left join listvalue_field_value_detail hos_type on mother.type_of_hospital = hos_type.id
left join listvalue_field_value_detail helth_infra on mother.health_infrastructure_id = helth_infra.id
where mother.id = #visitId#
',true,'ACTIVE');

