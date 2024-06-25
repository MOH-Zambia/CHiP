delete from query_master where code = 'mob_lmp_services_provided';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_lmp_services_provided','memberId','
select to_char(rch.service_date, ''DD/MM/YYYY'') as "Service Date",
cast(''Home'' as text) as "Visit Place",
rch.id as "hiddenVisitId",
cast(''FHW_LMP'' as text) as "hiddenServiceType"
from rch_lmp_follow_up rch
inner join imt_member mem on rch.member_id = mem.id
where member_id = #memberId#
order by rch.service_date desc;
',true,'ACTIVE');

delete from query_master where code = 'mob_anc_services_provided';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_anc_services_provided','memberId','
select to_char(rch.service_date, ''DD/MM/YYYY'') as "Service Date",
case when ancplace.value is not null then ancplace.value when rch.delivery_place is not null then rch.delivery_place else null end as "ANC Place",
rch.id as "hiddenVisitId",
cast(''FHW_ANC'' as text) as "hiddenServiceType"
from rch_anc_master rch
inner join imt_member mem on rch.member_id = mem.id
left join listvalue_field_value_detail ancplace on ancplace.id = rch.anc_place
where member_id = #memberId#
order by rch.service_date desc;
',true,'ACTIVE');

delete from query_master where code = 'mob_wpd_services_provided';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_wpd_services_provided','memberId','
select to_char(rch.date_of_delivery, ''DD/MM/YYYY'') as "Service Date",
rch.delivery_place as "Delivery Place",
rch.id as "hiddenVisitId",
cast(''FHW_MOTHER_WPD'' as text) as "hiddenServiceType"
from rch_wpd_mother_master rch
inner join imt_member mem on rch.member_id = mem.id
where member_id = #memberId#
order by rch.date_of_delivery desc;
',true,'ACTIVE');

delete from query_master where code = 'mob_pnc_services_provided';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_pnc_services_provided','memberId','
select to_char(rch.service_date, ''DD/MM/YYYY'') as "Service Date",
rch.delivery_place as "PNC Visit Place",
rch.id as "hiddenVisitId",
cast(''FHW_PNC'' as text) as "hiddenServiceType"
from rch_pnc_master rch
inner join imt_member mem on rch.member_id = mem.id
where member_id = #memberId#
order by rch.service_date desc;

',true,'ACTIVE');

delete from query_master where code = 'mob_child_services_provided';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_child_services_provided','memberId','
select to_char(rch.service_date, ''DD/MM/YYYY'') as "Service Date",
rch.delivery_place as "CS Visit Place",
rch.id as "hiddenVisitId",
cast(''FHW_CS'' as text) as "hiddenServiceType"
from rch_child_service_master rch
inner join imt_member mem on rch.member_id = mem.id
where member_id = #memberId#
order by rch.service_date desc;
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail','from_date,to_date,location_id,limit,offset','
with loc as (
	select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
), dates as (
	select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'') + interval ''1 day'' - interval ''1 millisecond'' as to_date
), service_type as (
	select ''FHW_LMP'' as type, ''LMP Follow Up'' as name
	union
	select ''FHW_ANC'', ''ANC''
	union
	select ''FHW_MOTHER_WPD'', ''WPD''
	union
	select ''FHW_PNC'', ''PNC''
	union
	select ''FHW_CS'', ''Child Services''
	union
	select ''NCD_HYPERTENSION'', ''Hypertension''
	union
	select ''NCD_DIABETES'', ''Diabetes''
	union
	select ''NCD_ORAL'', ''Oral Cancer''
	union
	select ''NCD_BREAST'', ''Breast Cancer''
	union
	select ''NCD_CERVICAL'', ''Cervical Cancer''
), det as (
	select * from rch_member_services
	inner join loc on rch_member_services.location_id = loc.loc_id
	inner join dates on rch_member_services.service_date between dates.from_date and dates.to_date
	order by service_date desc
	limit #limit# offset #offset#
)
select 
to_char(det.service_date, ''DD/MM/YYYY'') as "Service Date",
service_type.name as "Service Provided",
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name) as "Member Name",
m.unique_health_id as "Health Id",
m.family_id as "Family Id",
det.service_type as "hiddenServiceType",
det.visit_id as "hiddenVisitId"
from det
inner join imt_member m on m.id = det.member_id
inner join service_type on det.service_type = service_type.type
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_lmp';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_lmp','visitId','
with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On The Way'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''FMLSTR'' as text) as const, cast(''FEMALE STERILIZATION'' as text) as name
	union
	select cast(''MLSTR'' as text) as const, cast(''MALE STERILIZATION'' as text) as name
	union
	select cast(''IUCD5'' as text) as const, cast(''IUCD- 5 YEARS'' as text) as name
	union
	select cast(''IUCD10'' as text) as const, cast(''IUCD- 10 YEARS'' as text) as name
	union
	select cast(''CONDOM'' as text) as const, cast(''CONDOM'' as text) as name
	union
	select cast(''ORALPILLS'' as text) as const, cast(''ORAL PILLS'' as text) as name
	union
	select cast(''CHHAYA'' as text) as const, cast(''CHHAYA'' as text) as name
	union
	select cast(''ANTARA'' as text) as const, cast(''ANTARA'' as text) as name
	union
	select cast(''CONTRA'' as text) as const, cast(''EMERGENCY CONTRACEPTIVE PILLS'' as text) as name
	union
	select cast(''PPIUCD'' as text) as const, cast(''PPIUCD'' as text) as name
	union
	select cast(''PAIUCD'' as text) as const, cast(''PAIUCD'' as text) as name
	union
	select cast(''NONE'' as text) as const, cast(''NONE'' as text) as name	
)
select 
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name) as "Member name",
m.unique_health_id as "Health Id",
m.family_id as "Family Id",
cast(age(m.dob) as text) as "Age",
cast(l.year as text) as "Marriage Year",
to_char(l.service_date, ''DD/MM/YYYY'') as "Service date",
to_char(l.lmp, ''DD/MM/YYYY'') as "LMP date",
case when l.is_pregnant = true then ''Yes'' when l.is_pregnant = false then ''No'' else null end as "Is pregnant",
case when l.pregnancy_test_done = true then ''Yes'' when l.pregnancy_test_done = false then ''No'' else l.pregnancy_test_done end as "Pregnancy test done",
fp.name as "Family planning method",
case when l.fp_insert_operate_date != null then to_char(l.fp_insert_operate_date, ''DD/MM/YYYY'') else null end as "Family planing method insert/operate date",
to_char(l.death_date, ''DD/MM/YYYY'') as "Death date",
dp.name as "Death Place",
l.death_reason as "Death Reason"
from rch_lmp_follow_up l
inner join imt_member m on l.member_id = m.id
left join const fp on fp.const = l.family_planning_method
left join const dp on dp.const = l.place_of_death
where l.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_anc';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_anc','visitId','
with const as (
	select cast(''APH'' as text) as const, cast(''APH'' as text) as name
	union
	select cast(''PPH'' as text) as const, cast(''PPH'' as text) as name
	union
	select cast(''PLPRE'' as text) as const, cast(''Placenta previa'' as text) as name
	union
	select cast(''PRETRM'' as text) as const, cast(''Pre term'' as text) as name
	union
	select cast(''PIH'' as text) as const, cast(''PIH'' as text) as name
	union
	select cast(''CONVLS'' as text) as const, cast(''Convulsion'' as text) as name
	union
	select cast(''MLPRST'' as text) as const, cast(''Malpresentation'' as text) as name
	union
	select cast(''PRELS'' as text) as const, cast(''Previous LSCS'' as text) as name
	union
	select cast(''TWINS'' as text) as const, cast(''Twins'' as text) as name
	union
	select cast(''SBRTH'' as text) as const, cast(''Still birth'' as text) as name
	union
	select cast(''P2ABO'' as text) as const, cast(''Previous 2 abortions'' as text) as name
	union
	select cast(''KCOSCD'' as text) as const, cast(''Known case of sickle cell disease'' as text) as name
	union
	select cast(''CONGDEF'' as text) as const, cast(''Congenital Defects'' as text) as name
	union
	select cast(''SEVANM'' as text) as const, cast(''Severe Anemia'' as text) as name
	union
	select cast(''OBSLBR'' as text) as const, cast(''Obstructed Labour'' as text) as name
	union
	select cast(''CAESARIAN'' as text) as const, cast(''Caesarian Section'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
	union
	select cast(''NK'' as text) as const, cast(''Not known'' as text) as name
	union
	select cast(''LBIRTH'' as text) as const, cast(''Live Birth'' as text) as name
	union
	select cast(''SBIRTH'' as text) as const, cast(''Still Birth'' as text) as name
	union
	select cast(''MTP'' as text) as const, cast(''MTP'' as text) as name
	union
	select cast(''ABORTION'' as text) as const, cast(''Abortion'' as text) as name
	union
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''MAMTA_DAY'' as text) as const, cast(''Mamta Day'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Institution'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On The Way'' as text) as name
	union
	select cast(''NOT_DONE'' as text) as const, cast(''Not done'' as text) as name
	union
	select cast(''REACTIVE'' as text) as const, cast(''Reactive'' as text) as name
	union
	select cast(''NON_REACTIVE'' as text) as const, cast(''Non-reactive'' as text) as name
	union
	select cast(''EMPTY'' as text) as const, cast(''Done on empty stomach'' as text) as name
	union
	select cast(''NON_EMPTY'' as text) as const, cast(''Done on non-empty stomach'' as text) as name
	union
	select cast(''POSITIVE'' as text) as const, cast(''Positive'' as text) as name
	union
	select cast(''NEGATIVE'' as text) as const, cast(''Negative'' as text) as name
	union
	select cast(''SOCIAL_CELL_TRAIT'' as text) as const, cast(''Social Cell Trait'' as text) as name
	union
	select cast(''SICKLE_CELL'' as text) as const, cast(''Sickle Cell'' as text) as name
	union
	select cast(''FMLSTR'' as text) as const, cast(''FEMALE STERILIZATION'' as text) as name
	union
	select cast(''MLSTR'' as text) as const, cast(''MALE STERILIZATION'' as text) as name
	union
	select cast(''IUCD5'' as text) as const, cast(''IUCD- 5 YEARS'' as text) as name
	union
	select cast(''IUCD10'' as text) as const, cast(''IUCD- 10 YEARS'' as text) as name
	union
	select cast(''CONDOM'' as text) as const, cast(''CONDOM'' as text) as name
	union
	select cast(''ORALPILLS'' as text) as const, cast(''ORAL PILLS'' as text) as name
	union
	select cast(''CHHAYA'' as text) as const, cast(''CHHAYA'' as text) as name
	union
	select cast(''ANTARA'' as text) as const, cast(''ANTARA'' as text) as name
	union
	select cast(''CONTRA'' as text) as const, cast(''EMERGENCY CONTRACEPTIVE PILLS'' as text) as name
	union
	select cast(''PPIUCD'' as text) as const, cast(''PPIUCD'' as text) as name
	union
	select cast(''PAIUCD'' as text) as const, cast(''PAIUCD'' as text) as name
	union
	select cast(''NONE'' as text) as const, cast(''NONE'' as text) as name
	union
	select cast(''SUBCENTER'' as text) as const, cast(''Subcenter'' as text) as name
	union
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''UPHC'' as text) as const, cast(''UPHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''SUBDISTRICTHOSP'' as text) as const, cast(''Sub-District Hospital'' as text) as name
	union
	select cast(''DISTRICTHOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''TRUSTHOSP'' as text) as const, cast(''Trust Hospital'' as text) as name
	union
	select cast(''CHIRANJEEVIHOSP'' as text) as const, cast(''Private (Chiranjeevi)'' as text) as name
	union
	select cast(''PRIVATEHOSP'' as text) as const, cast(''Private Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
), dangsign as (
	select rel.anc_id, string_agg(det.value ,'', '') as dangeroussign 
	from rch_anc_dangerous_sign_rel rel
	inner join listvalue_field_value_detail det on rel.dangerous_sign_id = det.id
	where rel.anc_id = #visitId# group by rel.anc_id 
), prev_preg_comp as (
	select rel.anc_id, 
	string_agg(case when const.name is null then rel.previous_pregnancy_complication else const.name end,'', '') as prev_preg_comp 
	from rch_anc_previous_pregnancy_complication_rel rel
	left join const on const.const = rel.previous_pregnancy_complication
	where rel.anc_id = #visitId# group by rel.anc_id 
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
mem.family_id as "Family Id",
cast(age(mem.dob) as text) as "Age",
mem.mobile_number as "Mobile Number",
mem.account_number as "Bank Account Number",
mem.ifsc as "IFSC Code",
fam.address1 || '' '' || fam.address2 as "Address",
religion.value as "Religion",
caste.value as "Caste",
case when fam.bpl_flag = true then ''Yes'' when fam.bpl_flag = false then ''No'' else null end as "Is BPL",
to_char(reg.reg_date, ''DD/MM/YYYY'') as "Prgenancy Registration Date",
to_char(anc.service_date, ''DD/MM/YYYY'') as "Service Date",
case when ancplace.value is not null then ancplace.value when anc.delivery_place is not null then anc.delivery_place else null end as "ANC Place",
case when anc.lmp is not null then to_char(anc.lmp, ''DD/MM/YYYY'') else null end as "LMP Date",
anc.blood_group as "Blood Group",
case when anc.member_height is not null then cast(anc.member_height as text) else null end as "Height",
case when anc.weight is not null then cast(anc.weight as text) else null end as "Weight",
case when anc.haemoglobin_count is not null then cast(anc.haemoglobin_count as text) else null end as "Haemoglobin Count",
case when anc.systolic_bp is not null then cast(anc.systolic_bp as text) else null end as "Systolic BP",
case when anc.diastolic_bp is not null then cast(anc.diastolic_bp as text) else null end as "Diastolic BP",
case when anc.foetal_height is not null then cast(anc.foetal_height as text) else null end as "Foetal Height",
case when anc.foetal_heart_sound = true then ''Yes'' when anc.foetal_heart_sound = false then ''No'' else null end as "Foetal Heart Sound",
foetal_position.name as "Foetal Position",
foetal_movement.name as "Foetal Movement",
case when anc.ifa_tablets_given is not null then cast(anc.ifa_tablets_given as text) else null end as "Ifa Tablets Given",
case when anc.fa_tablets_given is not null then cast(anc.fa_tablets_given as text) else null end as "Fa Tablets Given",
case when anc.calcium_tablets_given is not null then cast(anc.calcium_tablets_given as text) else null end as "Calcium Tablets Given",
prev_del_out.name as "Previous Delivery Outcome",
prev_preg_comp.prev_preg_comp as "Previous Pregnancy Complication",
anc.other_previous_pregnancy_complication as "Other Previous Pregnancy Complication",
case when anc.jsy_beneficiary = true then ''Yes'' when anc.jsy_beneficiary = false then ''No'' else null end as "JSY Beneficiary",
case when anc.jsy_payment_done = true then ''Yes'' when anc.jsy_payment_done = false then ''No'' else null end as "JSY Payment Done",
case when anc.kpsy_beneficiary = true then ''Yes'' when anc.kpsy_beneficiary = false then ''No'' else null end as "KPSY Beneficiary", 
case when anc.iay_beneficiary = true then ''Yes'' when anc.iay_beneficiary = false then ''No'' else null end as "IAY Beneficiary", 
case when anc.chiranjeevi_yojna_beneficiary = true then ''Yes'' when anc.chiranjeevi_yojna_beneficiary = false then ''No'' else null end as "Chiranjeevi Yojna Beneficiary",
case when anc.urine_test_done = true then ''Yes'' when anc.urine_test_done = false then ''No'' else null end as "Urine Test Done",
anc.urine_albumin as "Urine Albumin",
anc.urine_sugar as "Urine Sugar",
blood_sugar_test.name as "Blood Sugar Test",
case when anc.sugar_test_before_food_val is not null then cast(anc.sugar_test_before_food_val as text) else null end as "Sugar Test Before Food Val",
case when anc.sugar_test_after_food_val is not null then cast(anc.sugar_test_after_food_val as text) else null end as "Sugar Test After Food Val",
hbsag_test.name as "HBsAg Test",
vdrl_test.name as "VDRL Test",
hiv_test.name as "HIV Test",
sickle_cell_test.name as "Sickle Cell Test",
case when anc.albendazole_given = true then ''Yes'' when anc.albendazole_given = false then ''No'' else null end as "Albendazole Given",
dan.dangeroussign as "Dangerous Sign",
anc.other_dangerous_sign as "Other Dangerous Sign",
case when anc.dead_flag = true then ''Yes'' when anc.dead_flag = false then ''No'' else null end as "Is the Member Dead",
case when anc.death_date is not null then to_char(anc.death_date, ''DD/MM/YYYY'') else null end as "Death Date",
place_of_death.name as "Place Of Death",
death_reason.value as "Death Reason",
expected_delivery_place.name as "Expected Delivery Place",
family_planning_method.name as "Family Planning Method",
case when anc.is_high_risk_case = true then ''Yes'' when anc.is_high_risk_case = false then ''No'' else null end as "Is High Risk Case",
referralplace.value as "Referral place Name"
from rch_anc_master anc 
inner join imt_member mem on anc.member_id = mem.id
inner join imt_family fam on fam.family_id = mem.family_id
left join rch_pregnancy_registration_det reg on anc.pregnancy_reg_det_id = reg.id 
left join listvalue_field_value_detail caste on cast(fam.caste as bigint) = caste.id
left join listvalue_field_value_detail religion on cast(fam.religion as bigint) = religion.id
left join listvalue_field_value_detail ancplace on anc.anc_place = ancplace.id
left join listvalue_field_value_detail referralplace on anc.referral_place = referralplace.id
left join listvalue_field_value_detail death_reason on cast(anc.death_reason as bigint) = death_reason.id
left join const prev_del_out on prev_del_out.const = anc.last_delivery_outcome
left join const foetal_movement on foetal_movement.const = anc.foetal_movement
left join const foetal_position on foetal_position.const = anc.foetal_position
left join const blood_sugar_test on blood_sugar_test.const = anc.blood_sugar_test
left join const hbsag_test on hbsag_test.const = anc.hbsag_test
left join const vdrl_test on vdrl_test.const = anc.vdrl_test
left join const hiv_test on hiv_test.const = anc.hiv_test
left join const sickle_cell_test on sickle_cell_test.const = anc.sickle_cell_test
left join const expected_delivery_place on expected_delivery_place.const = anc.expected_delivery_place
left join const family_planning_method on family_planning_method.const = anc.family_planning_method
left join const place_of_death on place_of_death.const = anc.place_of_death
left join dangsign dan on anc.id = dan.anc_id
left join prev_preg_comp on anc.id = prev_preg_comp.anc_id
where anc.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_wpd_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_wpd_mother','visitId','
with const as (
	select cast(''MTP'' as text) as const, cast(''MTP'' as text) as name
	union
	select cast(''ABORTION'' as text) as const, cast(''Abortion'' as text) as name
	union
	select cast(''SPONT_ABORTION'' as text) as const, cast(''Spontaneous Abortion'' as text) as name
	union
	select cast(''LBIRTH'' as text) as const, cast(''Live Birth'' as text) as name
	union
	select cast(''SBIRTH'' as text) as const, cast(''Still Birth'' as text) as name
	union
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On the way'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''108_AMBULANCE'' as text) as const, cast(''108 Ambulance'' as text) as name
	union
	select cast(''DOCTOR'' as text) as const, cast(''Doctor'' as text) as name
	union
	select cast(''ANM'' as text) as const, cast(''ANM'' as text) as name
	union
	select cast(''STAFF_NURSE'' as text) as const, cast(''Staff Nurse'' as text) as name
	union
	select cast(''TBA'' as text) as const, cast(''TBA'' as text) as name
	union
	select cast(''NON_TBA'' as text) as const, cast(''Non-TBA'' as text) as name
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
mem.family_id as "Family Id", 
case when mother.has_delivery_happened = true then ''Yes'' when mother.has_delivery_happened = false then ''No'' else null end as "Has Delivery Happened",
case when mother.date_of_delivery is not null then to_char(mother.date_of_delivery, ''DD/MM/YYYY'') else null end as "Date Of Delivery",
mother.type_of_delivery as "Type Of Delivery",
delivery_place.name as "Delivery Place",
delivery_done_by.name as "Delivery Done By",
mother.delivery_person_name as "Delivery Person Name",
health_infra."name" as "Health Infrastructure", 
pregnancy_outcome.name as "Pregnancy Outcome",
case when mother.mother_alive = true then ''Yes'' when mother.mother_alive = false then ''No'' else null end as "Is Mother Alive",
case when mother.death_date is not null then to_char(mother.death_date, ''DD/MM/YYYY'') else null end as "Death Date", 
place_of_death.name as "Place Of Death",
death_reason.value as "Death Reason", 
mother.other_death_reason as "Other Death Reason",
case when mother.is_preterm_birth = true then ''Yes'' when mother.is_preterm_birth = false then ''No'' else null end as "Is Preterm Birth",
case when mother.cortico_steroid_given = true then ''Yes'' when  mother.cortico_steroid_given = false then ''No'' else null end as "Cortico Steroid Given",
case when mother.misoprostol_given = true then ''Yes'' when mother.misoprostol_given = false then ''No'' else null end as "Misoprostol Given",
case when mother.is_discharged = true then ''Yes'' when mother.is_discharged = false then ''No'' else null end as "Is Discharged",
case when mother.discharge_date is not null then to_char(mother.discharge_date, ''DD/MM/YYYY'') else null end as "Discharge Date",
case when mother.is_high_risk_case = true then ''Yes'' when mother.is_high_risk_case = false then ''No'' else null end as "Is High Risk Case", 
mother.mtp_done_at as "Mtp Done At",
mother.mtp_performed_by as "Mtp Performed By"
from rch_wpd_mother_master mother
inner join imt_member mem on mother.member_id = mem.id
left join health_infrastructure_details health_infra on mother.health_infrastructure_id = health_infra.id
left join const delivery_place on delivery_place.const = mother.delivery_place
left join const delivery_done_by on delivery_done_by.const = mother.delivery_done_by
left join const pregnancy_outcome on pregnancy_outcome.const = mother.pregnancy_outcome
left join const place_of_death on place_of_death.const = mother.place_of_death
left join listvalue_field_value_detail death_reason on cast(mother.death_reason as bigint) = death_reason.id
where mother.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_wpd_child';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_wpd_child','visitId','
with cong_def as (
	select rel.wpd_id, string_agg(det.value ,'', '') as cong_def 
	from rch_wpd_child_congential_deformity_rel rel
	inner join listvalue_field_value_detail det on rel.congential_deformity = det.id
	where rel.wpd_id in (select id from rch_wpd_child_master where wpd_mother_id = #visitId#) group by rel.wpd_id 
), immu as (
	select imm.visit_id, string_agg(imm.immunisation_given, '', '') as immu_given
	from rch_immunisation_master imm
	where visit_id in (select id from rch_wpd_child_master where wpd_mother_id = #visitId#)
	group by visit_id
)
select 
concat(mem.first_name, '' '', mem.middle_name, '' '', mem.last_name, '' ('', mem.unique_health_id, '')'') as "Member Name",
child.gender as "Gender",
child.birth_weight as "Birth Weight",
child.baby_cried_at_birth  as "Is Baby Cried At Birth",
mother.breast_feeding_in_one_hour as "Is Breast Feeding In One Hour",
child.other_congential_deformity as "Other Congential Deformity",
child.is_high_risk_case as "Is High Risk Case",
immu.immu_given as "Vaccinaation Given"
from rch_wpd_child_master child
inner join rch_wpd_mother_master mother on child.wpd_mother_id = mother.id
inner join imt_member mem on child.member_id = mem.id 
left join cong_def on cong_def.wpd_id = child.id
left join immu on immu.visit_id = child.id
where child.wpd_mother_id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_pnc_mother';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_pnc_mother','visitId','
with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On the way'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''MAMTA_DAY'' as text) as const, cast(''Mamta Day'' as text) as name
	union
	select cast(''FMLSTR'' as text) as const, cast(''FEMALE STERILIZATION'' as text) as name
	union
	select cast(''MLSTR'' as text) as const, cast(''MALE STERILIZATION'' as text) as name
	union
	select cast(''IUCD5'' as text) as const, cast(''IUCD- 5 YEARS'' as text) as name
	union
	select cast(''IUCD10'' as text) as const, cast(''IUCD- 10 YEARS'' as text) as name
	union
	select cast(''CONDOM'' as text) as const, cast(''CONDOM'' as text) as name
	union
	select cast(''ORALPILLS'' as text) as const, cast(''ORAL PILLS'' as text) as name
	union
	select cast(''CHHAYA'' as text) as const, cast(''CHHAYA'' as text) as name
	union
	select cast(''ANTARA'' as text) as const, cast(''ANTARA'' as text) as name
	union
	select cast(''CONTRA'' as text) as const, cast(''EMERGENCY CONTRACEPTIVE PILLS'' as text) as name
	union
	select cast(''PPIUCD'' as text) as const, cast(''PPIUCD'' as text) as name
	union
	select cast(''PAIUCD'' as text) as const, cast(''PAIUCD'' as text) as name
	union
	select cast(''NONE'' as text) as const, cast(''NONE'' as text) as name
), dang_sign as (
	select rel.mother_pnc_id, string_agg(det.value ,'', '') as dang_sign 
	from rch_pnc_mother_danger_signs_rel rel
	inner join listvalue_field_value_detail det on rel.mother_danger_signs = det.id
	where rel.mother_pnc_id in (select id from rch_pnc_mother_master where pnc_master_id = #visitId#) 
	group by rel.mother_pnc_id 
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Mother Name",
mem.family_id as "Family Id",
case when pm.service_date is not null then to_char(pm.service_date , ''DD/MM/YYYY'') else null end as "Service Date", 
delivery_place.name as "PNC Visit Place",
health_infra.name as "Health Infrastructure",
case when pmm.ifa_tablets_given is not null then cast(pmm.ifa_tablets_given as text) else null end as "IFA Tablets Given", 
dang_sign.dang_sign as "Dangerous Signs",
pmm.other_danger_sign as "Other Dangerous Sign", 
family_planning_method.name as "Contraceptive method used after delivery",
case when pmm.fp_insert_operate_date is not null then to_char( pmm.fp_insert_operate_date, ''DD/MM/YYYY'') else null end as "FP Insert Operate Date",
case when pmm.death_date is not null then to_char(pmm.death_date, ''DD/MM/YYYY'') else null end as "Death Date", 
death_reason.value as "Death Reason", 
place_of_death.name as "Place Of Death",
pmm.other_death_reason as "Other Death Reason"
from rch_pnc_master pm
inner join rch_pnc_mother_master pmm on pm.id = pmm.pnc_master_id
inner join imt_member mem on pmm.mother_id = mem.id
left join health_infrastructure_details health_infra on pm.health_infrastructure_id = health_infra.id
left join const delivery_place on delivery_place.const = pm.delivery_place
left join const family_planning_method on family_planning_method.const = pmm.family_planning_method
left join dang_sign on dang_sign.mother_pnc_id = pmm.id
left join listvalue_field_value_detail death_reason on cast(pmm.death_reason as bigint) = death_reason.id
left join const place_of_death on place_of_death.const = pmm.place_of_death
where pm.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_pnc_child';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_pnc_child','visitId','
with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On the way'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
), dang_sign as (
	select rel.child_pnc_id, string_agg(det.value ,'', '') as dang_sign 
	from rch_pnc_child_danger_signs_rel rel
	inner join listvalue_field_value_detail det on rel.child_danger_signs = det.id
	where rel.child_pnc_id in (select id from rch_pnc_child_master where pnc_master_id = #visitId#)
	group by rel.child_pnc_id 
)
select 	
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
pcm.child_weight as "Child Weight", 
dang_sign.dang_sign as "Dangerous Signs",
pcm.other_danger_sign as "Other Danger Sign",  
case when pcm.death_date is not null then to_char(pcm.death_date, ''DD/MM/YYYY'') else null end as "Death Date",
death_reason.value as "Death Reason", 
place_of_death.name as "Place Of Death",
pcm.other_death_reason as "Other Death Reason"
from rch_pnc_child_master pcm 
inner join imt_member mem on pcm.child_id = mem.id
left join dang_sign on dang_sign.child_pnc_id = pcm.id
left join listvalue_field_value_detail death_reason on cast(pcm.death_reason as bigint) = death_reason.id
left join const place_of_death on place_of_death.const = pcm.place_of_death
where pnc_master_id  = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_cs';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_cs','visitId','
with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''MAMTA_DAY'' as text) as const, cast(''Mamta Day'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''BEFORE6'' as text) as const, cast(''Before 6 months'' as text) as name
	union
	select cast(''ENDOF6'' as text) as const, cast(''End of 6 months'' as text) as name
	union
	select cast(''AFTER6'' as text) as const, cast(''After 6 months'' as text) as name
), diseases as (
	select rel.child_service_id, string_agg(det.value ,'', '') as diseases 
	from rch_child_service_diseases_rel rel
	inner join listvalue_field_value_detail det on rel.diseases = det.id
	where rel.child_service_id = 6407998
	group by rel.child_service_id 
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
mem.family_id as "Family Id",
case when csm.service_date is not null then to_char(csm.service_date, ''DD/MM/YYYY'') else null end as "Service Date",
case when csm.weight is not null then cast(csm.weight as text) else null end as "Weight", 
case when csm.ifa_syrup_given = true then ''Yes'' when csm.ifa_syrup_given = false then ''No'' else null end as "Ifa Syrup Given", 
case when csm.complementary_feeding_started = true then ''Yes'' when csm.complementary_feeding_started = false then ''No'' else null end as "Is Complementary Feeding Started", 
comp_feeding_start_period.name as "Complementary Feeding Start Period",
case when csm.mid_arm_circumference is not null then cast(csm.mid_arm_circumference as text) else null end as "Mid Arm Circumference",
case when csm.height is not null then cast(csm.height as text) else null end as "Height",
case when csm.have_pedal_edema = true then ''Yes'' when csm.have_pedal_edema = false then ''No'' else null end as "Have Pedal Edema",
case when csm.exclusively_breastfeded = true then ''Yes'' when csm.exclusively_breastfeded = false then ''No'' else null end as "Exclusively Breastfeded",
diseases.diseases as "Diseases",
csm.other_diseases as "Other Diseases",
case when csm.death_date is not null then to_char(csm.death_date, ''DD/MM/YYYY'') else null end as "Death Date",
place_of_death.name as "Place Of Death",
death_reason.value as "Death Reason", 
csm.other_death_reason as "Other Death Reason"
from rch_child_service_master csm 
inner join imt_member mem on csm.member_id = mem.id
left join const comp_feeding_start_period on comp_feeding_start_period.const = csm.complementary_feeding_start_period
left join diseases on diseases.child_service_id = csm.id
left join listvalue_field_value_detail death_reason on cast(csm.death_reason as bigint) = death_reason.id
left join const place_of_death on place_of_death.const = csm.place_of_death
where csm.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_hypertension';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_hypertension','visitId','
with const as (
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''DIST_HOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
)
select
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name, '' ('', m.unique_health_id, '')'') as "Member Name",
m.family_id as "Family Id",
to_char(hyp.screening_date, ''DD/MM/YYYY'') as "Screening Date",
case when hyp.systolic_bp is not null then cast(hyp.systolic_bp as text) else null end as "Systolic BP",
case when hyp.diastolic_bp is not null then cast(hyp.diastolic_bp as text) else null end as "Diastolic BP",
case when hyp.pulse_rate is not null then cast(hyp.pulse_rate as text) else null end as "Pulse Rate",
case when hyp.diagnosed_earlier = true then ''Yes'' when hyp.diagnosed_earlier = false then ''No'' else null end as "Diagoned for Hypertension earlier",
case when hyp.currently_under_treatement = true then ''Yes'' when hyp.currently_under_treatement = false then ''No'' else null end as "Currently under treatement",
case when hyp.refferal_done = true then ''Yes'' when hyp.refferal_done = false then ''No'' else null end as "Referral done",
const.name as "Referral Place",
hyp.remarks as "Remarks"
from ncd_member_hypertension_detail hyp
inner join imt_member m on hyp.member_id = m.id
left join const on const.const = hyp.refferal_place
where hyp.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_diabetes';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_diabetes','visitId','
with const as (
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''DIST_HOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
)
select
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name, '' ('', m.unique_health_id, '')'') as "Member Name",
m.family_id as "Family Id",
to_char(ncd.screening_date, ''DD/MM/YYYY'') as "Screening Date",
case when ncd.blood_sugar is not null then cast(ncd.blood_sugar as text) else null end as "Blood Sugar",
case when ncd.earlier_diabetes_diagnosis = true then ''Yes'' when ncd.earlier_diabetes_diagnosis = false then ''No'' else null end as "Diagoned for Diabetes earlier",
case when ncd.currently_under_treatment = true then ''Yes'' when ncd.currently_under_treatment = false then ''No'' else null end as "Currently under treatement",
case when ncd.refferal_done = true then ''Yes'' when ncd.refferal_done = false then ''No'' else null end as "Referral done",
const.name as "Referral Place",
ncd.remarks as "Remarks"
from ncd_member_diabetes_detail ncd
inner join imt_member m on ncd.member_id = m.id
left join const on const.const = ncd.refferal_place
where ncd.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_oral';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_oral','visitId','
with const as (
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''DIST_HOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
)
select
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name, '' ('', m.unique_health_id, '')'') as "Member Name",
m.family_id as "Family Id",
to_char(ncd.screening_date, ''DD/MM/YYYY'') as "Screening Date",
case when ncd.any_issues_in_mouth = true then ''Yes'' when ncd.any_issues_in_mouth = false then ''No'' else null end as "Any issues in mouth",
case when ncd.white_red_patch_oral_cavity = true then ''Yes'' when ncd.white_red_patch_oral_cavity = false then ''No'' else null end as "White/Red patch in oral cavity",
case when ncd.three_weeks_mouth_ulcer = true then ''Yes'' when ncd.three_weeks_mouth_ulcer = false then ''No'' else null end as "Ulceration/Roughend areas in mouth for more than 3 weeks",
case when ncd.voice_change = true then ''Yes'' when ncd.voice_change = false then ''No'' else null end as "Change in voice/hoarseness?",
case when ncd.difficulty_in_spicy_food = true then ''Yes'' when ncd.difficulty_in_spicy_food = false then ''No'' else null end as "Difficulty in tolerating spicy food",
case when ncd.difficulty_in_opening_mouth = true then ''Yes'' when ncd.difficulty_in_opening_mouth = false then ''No'' else null end as "Difficulty in opening mouth",
case when ncd.refferal_done = true then ''Yes'' when ncd.refferal_done = false then ''No'' else null end as "Referral done",
const.name as "Referral Place",
ncd.remarks as "Remarks"
from ncd_member_oral_detail ncd
inner join imt_member m on ncd.member_id = m.id
left join const on const.const = ncd.refferal_place
where ncd.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_breast';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_breast','visitId','
with const as (
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''DIST_HOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
)
select
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name, '' ('', m.unique_health_id, '')'') as "Member Name",
m.family_id as "Family Id",
to_char(ncd.screening_date, ''DD/MM/YYYY'') as "Screening Date",
case when ncd.any_breast_related_symptoms = true then ''Yes'' when ncd.any_breast_related_symptoms = false then ''No'' else null end as "Any breast related symptoms",
case when ncd.lump_in_breast = true then ''Yes'' when ncd.lump_in_breast = false then ''No'' else null end as "Lump / Thickness in breast",
case when ncd.size_change = true then ''Yes'' when ncd.size_change = false then ''No'' else null end as "Change in size",
case when ncd.nipple_shape_and_position_change = true then ''Yes'' when ncd.nipple_shape_and_position_change = false then ''No'' else null end as "Change in shape and position of Nipple",
case when ncd.any_retraction_of_nipple = true then ''Yes'' when ncd.any_retraction_of_nipple = false then ''No'' else null end as "Any Retraction of Nipple",
case when ncd.discharge_from_nipple = true then ''Yes'' when ncd.discharge_from_nipple = false then ''No'' else null end as "Discharge from one / both Nipple",
case when ncd.redness_of_skin_over_nipple = true then ''Yes'' when ncd.redness_of_skin_over_nipple = false then ''No'' else null end as "Redness of skin over breast / any ulcer",
case when ncd.erosions_of_nipple = true then ''Yes'' when ncd.erosions_of_nipple = false then ''No'' else null end as "Erosions of Nipple",
case when ncd.agreed_for_self_breast_exam = true then ''Yes'' when ncd.agreed_for_self_breast_exam = false then ''No'' else null end as "Patient agreed for Clinical Breast Examination",
ncd.visual_swelling_in_armpit as "Swelling in armpit (Left/Right)",
case when ncd.visual_discharge_from_nipple = true then ''Yes'' when ncd.visual_discharge_from_nipple = false then ''No'' else null end as "Discharge from Nipple in Examination",
case when ncd.refferal_done = true then ''Yes'' when ncd.refferal_done = false then ''No'' else null end as "Referral done",
const.name as "Referral Place",
ncd.remarks as "Remarks"
from ncd_member_breast_detail ncd
inner join imt_member m on ncd.member_id = m.id
left join const on const.const = ncd.refferal_place
where ncd.id = #visitId#
',true,'ACTIVE');

delete from query_master where code = 'mob_work_register_detail_cervical';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mob_work_register_detail_cervical','visitId','
with const as (
	select cast(''PHC'' as text) as const, cast(''PHC'' as text) as name
	union
	select cast(''CHC'' as text) as const, cast(''CHC'' as text) as name
	union
	select cast(''DIST_HOSP'' as text) as const, cast(''District Hospital'' as text) as name
	union
	select cast(''OTHER'' as text) as const, cast(''Other'' as text) as name
)
select
concat(m.first_name, '' '', m.middle_name, '' '', m.last_name, '' ('', m.unique_health_id, '')'') as "Member Name",
m.family_id as "Family Id",
to_char(ncd.screening_date, ''DD/MM/YYYY'') as "Screening Date",
case when ncd.cervical_related_symptoms = true then ''Yes'' when ncd.cervical_related_symptoms = false then ''No'' else null end as "Any cervical related symptoms",
case when ncd.excessive_bleeding_during_periods = true then ''Yes'' when ncd.excessive_bleeding_during_periods = false then ''No'' else null end as "Excessive bleeding during periods",
case when ncd.bleeding_between_periods = true then ''Yes'' when ncd.bleeding_between_periods = false then ''No'' else null end as "Bleeding between periods",
case when ncd.bleeding_after_intercourse = true then ''Yes'' when ncd.bleeding_after_intercourse = false then ''No'' else null end as "Bleeding after intercourse",
case when ncd.excessive_smelling_vaginal_discharge = true then ''Yes'' when ncd.excessive_smelling_vaginal_discharge = false then ''No'' else null end as "Excessive foul smelling vaginal discharge",
case when ncd.postmenopausal_bleeding = true then ''Yes'' when ncd.postmenopausal_bleeding = false then ''No'' else null end as "Postmenopausal bleeding",
case when ncd.refferal_done = true then ''Yes'' when ncd.refferal_done = false then ''No'' else null end as "Referral done",
const.name as "Referral Place",
ncd.remarks as "Remarks"
from ncd_member_cervical_detail ncd
inner join imt_member m on ncd.member_id = m.id
left join const on const.const = ncd.refferal_place
where ncd.id = #visitId#
',true,'ACTIVE');
