delete from query_master where code = 'get_rch_register_child_service_detail_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_child_service_detail_info','member_id','

with basic_info as ( 
	select mem.id as member_id,
	mem.unique_health_id as child_unique_health_id,
	child.member_name,
	case when child.gender is not null then case when child.gender = ''F'' then ''Female'' else ''Male'' end else ''N/A'' end as gender , 
	case when mother.first_name is not null then mother.first_name else ''N/A'' end as mother_name,
	case when mother.unique_health_id is not null then mother.unique_health_id else ''N/A'' end as mother_unique_health_id, 
	concat_ws('','', fam.address1, fam.address2) as address, 
	case when child.dob is not null then to_char(child.dob ,''dd-MM-yyyy'') else ''N/A'' end as dob, 
	case when child.birth_weight is not null then cast( child.birth_weight as text) else ''N/A'' end as birth_weight, 
	case when child.loc_id is not null then dob_location.name else ''N/A'' end as birth_location, 
	rel.value as religion, cas.value as cast,
	-- vaccinazation
	case when bcg is null then ''N/A'' else to_char(bcg,''dd-MM-yyyy'') end as bcg, 
	case when opv1 is null then ''N/A'' else to_char(opv1,''dd-MM-yyyy'') end as opv1, 
	case when penta1 is null then ''N/A'' else to_char(penta1,''dd-MM-yyyy'') end as penta1, 
	case when opv2 is null then ''N/A'' else to_char(opv2,''dd-MM-yyyy'') end as opv2, 
	case when penta2 is null then ''N/A'' else to_char(penta2,''dd-MM-yyyy'') end as penta2, 
	case when opv3 is null then ''N/A'' else to_char(opv3,''dd-MM-yyyy'') end as opv3, 
	case when penta3 is null then ''N/A'' else to_char(penta3,''dd-MM-yyyy'') end as penta3,
	case when fully_immunization_in_number_of_month is not null then 
	case when fully_immunization_in_number_of_month  > 12 then ''Yes'' else ''No'' end  else ''N/A'' end as fully_immunization_in_twelve_of_month ,
	case when opv_booster is null then ''N/A'' else to_char(opv_booster,''dd-MM-yyyy'') end as opv_booster,
	case when dpt_booster is null then ''N/A'' else to_char(dpt_booster,''dd-MM-yyyy'') end as dpt_booster
	from rch_child_analytics_details child
	left join imt_member mem on child.member_id = mem.id
	left join imt_member mother on child.mother_id = mother.id
	left join imt_family fam on mem.family_id = fam.family_id
	left join location_master dob_location on child.loc_id = dob_location.id
	left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
	left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
	where mem.id = #member_id#
)
,vitamin_a_dose as (
	select #member_id# as member_id, string_agg(given_date, '','') as vitamin_a_dose from ( select to_char(given_on,''dd-MM-yyyy'') as given_date
	from rch_immunisation_master 
	where immunisation_given = ''VITAMIN_A'' 
	and member_id = #member_id# order by given_on asc
	) t	
) 
,side_effect_vaccination_booster_2 as(
	select 
	ser.member_id, 
	case when given_on is not null then to_char(given_on ,''dd-MM-yyyy'') else ''N/A'' end as given_on, 
	adverse_effect, concat(''Manufacturer:'', manufacturer, '', batch numbe:'' , batch_number)  as vaccination_details 
	from rch_immunisation_master imm 
	inner join rch_vaccine_adverse_effect ser on imm.member_id = ser.member_id
	where imm.immunisation_given  = ''DPT_BOOSTER''  
	and imm.member_id = #member_id#
)
,extra_info as (
	select 
	case when complementary_feeding_start_period is not null 
		then  case when complementary_feeding_start_period = ''AFTER6'' then ''Yes'' else ''No'' end 
		else ''N/A''
		end as breast_feeded_upto_six_month
	from rch_child_service_master where complementary_feeding_started = true 
	and member_id = #member_id# 
	order by service_date desc
	limit 1
)
,side_effect_vaccination_booster as(
	select child_ser.member_id, child_ser.service_date as booster_given_date, child_ser.weight as booster_child_weight from rch_immunisation_master  imm 
	left join rch_child_service_master child_ser on imm.visit_id = child_ser.id
	where imm.immunisation_given  = ''DPT_BOOSTER''  
	and child_ser.member_id = #member_id#
) 

select bas.*, vitamin_a_dose, given_on, adverse_effect, vaccination_details, booster_given_date, booster_child_weight from basic_info bas
left join vitamin_a_dose vit_a on bas.member_id = vit_a.member_id
left join side_effect_vaccination_booster_2 booster_2 on bas.member_id = booster_2.member_id
left join side_effect_vaccination_booster booster on bas.member_id = booster.member_id
limit 1
',true,'ACTIVE');


delete from query_master where code = 'get_rch_register_eligible_couple_detailed_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_mother_service_detailed_info','preg_reg_id','

with preg_member as (
    select * from rch_pregnancy_registration_det where id = #preg_reg_id#
)
,basic_member_info as (
    select 
    preg.member_id, 
    case when date_of_delivery is null then ''N/A'' else to_char(date_of_delivery,''dd-MM-yyyy'') end as date_of_delivery, 
    mem.unique_health_id, 
    case when preg.lmp_date is null then ''N/A'' else to_char(preg.lmp_date,''dd-MM-yyyy'') end as lmp_date, 
    case when preg.reg_service_date is null then ''N/A'' else to_char(preg.reg_service_date,''dd-MM-yyyy'') end as reg_service_date, 
    case when cast(del_week as text) is null then ''N/A'' else cast(del_week as text) end as pregnancy_week_number, 
    preg.member_name,
    case when TRUNC(DATE_PART(''day'', cast(preg.date_of_delivery as timestamp)  - cast(preg.lmp_date as timestamp ))/7) > 11 then ''Yes'' else ''No'' end as twelve_pregnancy_week_number,
    case when mem.middle_name is null then ''N/A'' else mem.middle_name end as husband_name, 
    case when to_char(preg.edd,''dd-MM-yyyy'') is null then ''N/A'' else to_char(preg.edd,''dd-MM-yyyy'') end as edd, 
    case when cast(preg.age_during_delivery as text) is null then ''N/A'' else cast(preg.age_during_delivery as text) end as age_during_delivery, 
    case when to_char(mem.dob,''dd-MM-yyyy'') is null then ''N/A'' else to_char(mem.dob,''dd-MM-yyyy'') end as dob, 
    case when preg.expected_delivery_place is null then ''N/A'' else preg.expected_delivery_place end as expected_delivery_place, 
    case when cast(mem.weight as text) is null then ''N/A'' else cast(mem.weight as text) end as weight, 
    case when mem.blood_group is null then ''N/A'' else mem.blood_group end as blood_group, 
    case when (fam.address1 is null and fam.address2 is null) then ''N/A'' else concat(fam.address1, '','', fam.address2) end as address, 
    case when mem.mobile_number is null then ''N/A'' else mem.mobile_number end as mobile_number, 
    case when rel.value is null then ''N/A'' else rel.value end as religion, 
    case when cas.value is null then ''N/A'' else cas.value end as cast, 
    case when del_week is null then ''N/A'' 
	 when fam.bpl_flag then ''BPL''
	 else ''AVL'' end as bpl_flag
    from rch_pregnancy_analytics_details preg
    inner join imt_member mem on preg.member_id = mem.id
    inner join imt_family fam on mem.family_id = fam.family_id 
    left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
    left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
    where preg.pregnancy_reg_id  = #preg_reg_id#
)
,preg_reg_id_for_pre_preg_detail as (
    select preg.id from rch_pregnancy_registration_det preg
    inner join preg_member mem on mem.member_id = preg.member_id
    where preg.reg_date < mem.reg_date and preg.id != mem.id and preg.member_id = mem.member_id and preg.state = ''DELIVERY_DONE''
)
,gender_info as(
    select string_agg(case when gender = ''M'' then ''Male'' when gender = ''F'' then ''Female'' else ''N/A'' end, '','') as preg_gender, pregnancy_reg_det_id 
    from rch_wpd_mother_master mother 
    left join rch_wpd_child_master child on mother.id = child.wpd_mother_id
    where pregnancy_reg_det_id in (select * from  preg_reg_id_for_pre_preg_detail)
    group by pregnancy_reg_det_id
)
,previous_pregnancy_details as ( 
 select cast( json_agg(t) as text) as previous_pregnancy_details_json from (
    select reg_id.id,string_agg(value, '','') as preg_complication,preg_gender
    from preg_reg_id_for_pre_preg_detail reg_id
    left join gender_info on reg_id.id = gender_info.pregnancy_reg_det_id

    left join rch_anc_master anc on reg_id.id = anc.pregnancy_reg_det_id 
    left join rch_anc_dangerous_sign_rel rel on rel.anc_id = anc.id
    left join listvalue_field_value_detail list on rel.dangerous_sign_id  = list.id
    
    group by reg_id.id, preg_gender
  ) t

)
,pre_delivery_care as ( 
	select cast( json_agg(t) as text) as pre_delivery_care_json from (
		select 
		case when service_date is null then ''N/A'' else to_char(service_date,''dd-MM-yyyy'') end as inspection_date,
		case when ins_place.value is null then ''N/A'' else ins_place.value end as inspection_place,  
		case when ((cast(anc.service_date as text) is null) or (cast(anc.lmp as text) is null)) then ''0.0'' else TRUNC(DATE_PART(''day'', cast(anc.service_date as timestamp) - cast(anc.lmp as timestamp))/7) end as pregnancy_week,
		case when cast(anc.weight as text) is null then ''N/A'' else cast(anc.weight as text) end as preg_women_weight,
		case when cast(systolic_bp as text) is null then ''N/A'' else cast(systolic_bp as text) end as systolic_bp, 
		case when cast(diastolic_bp as text) is null then ''N/A'' else cast(diastolic_bp as text)  end as diastolic_bp, 
		case when cast(haemoglobin_count as text) is null then ''N/A'' else cast(haemoglobin_count as text) end as haemoglobin_count,
		case when cast(fa_tablets_given as text) is null then ''N/A'' else cast(fa_tablets_given as text) end as falic_acid_tablets,
		case when cast(ifa_tablets_given as text) is null then ''N/A'' else cast(ifa_tablets_given as text) end as ifa_tablet,
		case when urine_test_done is null then ''N/A'' 
			when urine_test_done then ''Yes'' else ''No'' end as urine_test_done, 
		case when cast(urine_albumin as text) is null then ''N/A''
			when urine_test_done then ''Yes'' else ''No'' end  as urine_albumin, 
		case when cast(urine_sugar as text) is null then ''N/A'' else cast(urine_sugar as text) end as  urine_sugar,
		case when sugar_test_before_food_val is null then ''N/A'' else cast(sugar_test_before_food_val as text) end as sugar_test_before_food_val, 
		case when cast(sugar_test_after_food_val as text) is null then ''N/A'' else cast(sugar_test_after_food_val as text) end as sugar_test_after_food_val,
		case when cast(immun.immunisation_given as text) is null then ''N/A'' else cast(immun.immunisation_given as text) end as immunisation_given,
		case when cast(foetal_height as text) is null then ''N/A'' else cast(foetal_height as text) end as foetal_height, 
		case when cast(foetal_heart_sound as text) is null then ''N/A'' else cast(foetal_heart_sound as text) end as foetal_heart_sound, 
		case when cast(foetal_position as text) is null then ''N/A'' else cast(foetal_position as text) end as foetal_position, 
		case when cast(foetal_movement as text) is null then ''N/A'' else cast(foetal_movement as text) end as foetal_movement,
		case when cast(referral_done as text) is null then ''N/A'' else cast(referral_done as text) end as referral_done, 
		case when family_planning_method is null then ''N/A'' else family_planning_method end as family_planning_method, 
		case when cast(dead_flag as text) is null then ''N/A'' else cast(dead_flag as text) end as dead_flag, 
		case when death_reason is null then ''N/A'' else death_reason end as death_reason,
		case when death_date is null then ''N/A'' else to_char(death_date,''dd-MM-yyyy'') end as death_date,
		case when place_of_death is null then ''N/A'' else place_of_death  end as death_place 
		from rch_anc_master anc
        left join rch_immunisation_master immun on anc.id = immun.visit_id		
		left join listvalue_field_value_detail ins_place on anc.anc_place = ins_place.id 		
		where anc.pregnancy_reg_det_id = #preg_reg_id#		
		order by service_date
	) t
)
, delivery_result as(
	select cast( json_agg(t) as text) as delivery_result_json from (
	select 
	child.member_id, 
	case when mother.date_of_delivery is null then ''N/A'' else to_char(mother.date_of_delivery,''dd-MM-yyyy HH:mm:ss'') end as date_of_delivery, 
	case when delivery_place is null then ''N/A'' else delivery_place end as delivery_place, 
	case when delivery_person_name is null then ''N/A'' else delivery_person_name end as delivery_person_name, 
	case when mother.type_of_delivery is null then ''N/A'' else mother.type_of_delivery end as type_of_delivery,
	case when mother.other_danger_signs  is null then ''N/A'' else mother.other_danger_signs  end as other_danger_signs,
	case when discharge_date is null then ''N/A'' else  to_char( discharge_date,''dd-MM-yyyy HH:mm:ss'') end as discharge_date,  
	case when child.pregnancy_outcome = ''LBIRTH'' then ''Alive'' 
		when child.pregnancy_outcome = ''SBIRTH'' then ''Dead''
		else ''N/A'' end as is_alive_dead,
	case when was_premature is null then ''N/A''
	     when was_premature then ''Yes'' else ''No'' end as was_premature, 
	case when gender is null then ''N/A'' 
	     when gender = ''F'' then ''Female'' else ''Male'' end as gender , 
	case when baby_cried_at_birth is null then ''N/A'' 
		when baby_cried_at_birth then ''Yes'' else ''No'' end as baby_cried_at_birth, 
	case when birth_weight is null then ''N/A'' else cast( birth_weight as text ) end as birth_weight, 
	case when child.breast_feeding_in_one_hour is null then ''N/A'' 
		when child.breast_feeding_in_one_hour then ''Yes'' else ''No'' end as breast_feeding_in_one_hour,
	case when child.referral_place is null then ''N/A'' else ''Yes'' end as referral_perform,
 
	case when immunisation_given = ''OPV_0'' then concat(''Yes'','','',to_char(immun.given_on,''dd-MM-yyyy'')) else ''No'' end as opv_given,
	case when immunisation_given = ''BCG'' then concat(''Yes'','','',to_char(immun.given_on,''dd-MM-yyyy'')) else ''No'' end as bcg_given,
	case when immunisation_given = ''HEPATITIS_B_0'' then concat(''Yes'','','',to_char(immun.given_on,''dd-MM-yyyy'')) else ''No'' end as hep_b_given,
	case when immunisation_given = ''VITAMIN_K'' then concat(''Yes'','','',to_char(immun.given_on,''dd-MM-yyyy'')) else ''No'' end as vit_k_given
	from rch_wpd_mother_master mother
	left join rch_wpd_child_master child on mother.id = child.wpd_mother_id
	left join rch_immunisation_master immun on mother.id = immun.visit_id
	where mother.pregnancy_reg_det_id = #preg_reg_id# and (mother.state is null or mother.state != ''MARK_AS_FALSE_DELIVERY'')
	group by wpd_mother_id, mother.date_of_delivery, delivery_place, delivery_person_name, mother.type_of_delivery, 
	discharge_date, was_premature, gender, baby_cried_at_birth, birth_weight, child.breast_feeding_in_one_hour,
	child.pregnancy_outcome, immunisation_given,immun.given_on, child.member_id,mother.other_danger_signs,child.referral_place
	)t
)
,pnc_visit as (
	select cast( json_agg(t) as text) as pnc_visit_json from ( 
	select
	to_char(mas.service_date,''dd-MM-yyyy'') as service_date,
	case when mother_pnc.ifa_tablets_given is null then ''N/A'' else cast(mother_pnc.ifa_tablets_given as text) end as ifa_tablets_given,
	     
	case when mother_pnc.other_danger_sign is null then ''N/A'' else cast(mother_pnc.other_danger_sign as text) end as other_danger_sign, 
	case when referral.value is null then ''N/A'' else referral.value end as referral_place, 
	case when mother_pnc.family_planning_method is null then ''N/A'' else mother_pnc.family_planning_method end as family_planning_method,
	case when mother_pnc.is_alive is null then ''N/A'' 
	     when mother_pnc.is_alive then ''Yes'' else ''No'' end as is_alive,  
	case when mother_pnc.death_reason is null then ''N/A'' else mother_pnc.death_reason end as death_reason, 
	case when mother_pnc.death_date is null then ''N/A'' else to_char(mother_pnc.death_date,''dd-MM-yyyy'') end as death_date, 
	case when mother_pnc.place_of_death is null then ''N/A'' else mother_pnc.place_of_death end as place_of_death,
	concat(''['',string_agg(cast(row_to_json(child_pnc.*) as text), '',''),'']'') as child_pnc_dto
	from rch_pnc_master mas
	left join rch_pnc_mother_master mother_pnc on mas.id = mother_pnc.pnc_master_id 
	left join rch_pnc_child_master child_pnc on mas.id = child_pnc.pnc_master_id
	left join listvalue_field_value_detail referral on mother_pnc.referral_place = referral.id 
	where mas.pregnancy_reg_det_id  =  #preg_reg_id#
	group by mas.id,mother_pnc.ifa_tablets_given, mother_pnc.other_danger_sign, referral.value, mother_pnc.family_planning_method, mother_pnc.is_alive, 
	mother_pnc.death_reason, mother_pnc.death_date, mother_pnc.place_of_death
	order by mas.service_date
 )t
)
select * from basic_member_info,previous_pregnancy_details,pre_delivery_care,delivery_result,pnc_visit
',true,'ACTIVE');

