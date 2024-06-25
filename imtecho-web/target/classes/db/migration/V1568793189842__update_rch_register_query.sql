update query_master 
set query = 'with preg_member as (
    select * from rch_pregnancy_registration_det where id = #preg_reg_id#
)
,pre_preg_comli as (
    select string_agg( distinct previous_pregnancy_complication, '','') as previous_complication from rch_anc_master rch 
    left join rch_anc_previous_pregnancy_complication_rel on rch.id = anc_id
    where rch.pregnancy_reg_det_id = #preg_reg_id# and previous_pregnancy_complication is not null
    group by pregnancy_reg_det_id
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
	 else ''APL'' end as bpl_flag,
    case when pre_com.previous_complication is null then ''N/A'' else pre_com.previous_complication end as  previous_complication	
    from rch_pregnancy_analytics_details preg
    inner join imt_member mem on preg.member_id = mem.id
    inner join imt_family fam on mem.family_id = fam.family_id 
    left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
    left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
    left join pre_preg_comli pre_com on true = true
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
		case when cast(anc.hiv_test as text) is null then ''N/A'' else cast(anc.hiv_test as text) end as hiv_test,
		case when cast(anc.vdrl_test as text) is null then ''N/A'' else cast(anc.vdrl_test as text) end as vdrl_test,
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
		case when death_reas.value is null then ''N/A'' else death_reas.value end as death_reason,
		case when death_date is null then ''N/A'' else to_char(death_date,''dd-MM-yyyy'') end as death_date,
		case when place_of_death is null then ''N/A'' else place_of_death  end as death_place 
		from rch_anc_master anc
        left join rch_immunisation_master immun on anc.id = immun.visit_id		
		left join listvalue_field_value_detail ins_place on anc.anc_place = ins_place.id 
		left join listvalue_field_value_detail death_reas on death_reason = (cast(death_reas.id as varchar)) 		
		where anc.pregnancy_reg_det_id = #preg_reg_id#		
		order by service_date
	) t
)
, delivery_result as(
	select cast( json_agg(t) as text) as delivery_result_json from (
	select 
	child.member_id, case when mother.pregnancy_outcome in  (''SPONT_ABORTION'',''ABORTION'') then 
		case when infra.name is not null then concat(infra.name,'', '', hos.value)
			else case when hos.value is not null then hos.value else delivery_place end end end as  abortion_place,
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
 
	case when child.member_id is null then ''N/A'' 
		when max(case when immunisation_given = ''OPV_0'' then immun.given_on end) is not null 
		then concat(''Yes'','','',to_char(max(case when immunisation_given = ''OPV_0'' then immun.given_on end),''dd-MM-yyyy'')) 
		else ''No'' end as opv_given,
	case when child.member_id is null then ''N/A'' 
		when max(case when immunisation_given = ''HEPATITIS_B_0'' then immun.given_on end) is not null 
		then concat(''Yes'','','',to_char(max(case when immunisation_given = ''HEPATITIS_B_0'' then immun.given_on end),''dd-MM-yyyy'')) 
		else ''No'' end as hep_b_given,
	case when child.member_id is null then ''N/A'' 
		when max(case when immunisation_given = ''VITAMIN_K'' then immun.given_on end) is not null 
		then concat(''Yes'','','',to_char(max(case when immunisation_given = ''VITAMIN_K'' then immun.given_on end),''dd-MM-yyyy'')) 
		else ''No'' end as vit_k_given,
	case when child.member_id is null then ''N/A'' 
		when max(case when immunisation_given = ''BCG'' then immun.given_on end) is not null 
		then concat(''Yes'','','',to_char(max(case when immunisation_given = ''BCG'' then immun.given_on end),''dd-MM-yyyy'')) 
		else ''No'' end as bcg_given
	from rch_wpd_mother_master mother
	left join rch_wpd_child_master child on mother.id = child.wpd_mother_id
	left join rch_immunisation_master immun on child.id = immun.visit_id and visit_type = ''FHW_WPD'' and  member_type = ''C''
	left join health_infrastructure_details infra on mother.health_infrastructure_id = infra.id
	left join listvalue_field_value_detail hos on mother.type_of_hospital = ((hos.id ))

	where mother.pregnancy_reg_det_id = #preg_reg_id# 
	and mother.has_delivery_happened = true 
	and (mother.state is null or mother.state != ''MARK_AS_FALSE_DELIVERY'')
	group by wpd_mother_id, mother.date_of_delivery, delivery_place, delivery_person_name, mother.type_of_delivery, 
	discharge_date, was_premature, gender, baby_cried_at_birth, birth_weight, child.breast_feeding_in_one_hour,
	mother.pregnancy_outcome,infra.name,infra.address, hos.value, child.pregnancy_outcome, immun.visit_id, child.member_id,
	mother.other_danger_signs,child.referral_place
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
select * from basic_member_info,previous_pregnancy_details,pre_delivery_care,delivery_result,pnc_visit' 
where code = 'get_rch_register_mother_service_detailed_info';

update query_master 
set query = 'with vitamin_a_second_dose as (
	select given_on
		from rch_immunisation_master 
		where immunisation_given = ''VITAMIN_A'' 
		and member_id = #member_id# 
		order by given_on asc limit 1 offset 1
		
),
breast_feeding_info as (
	select case when complementary_feeding_start_period = ''BEFORE6'' then ''Yes'' else ''No'' end as is_breastfed_till_six_month,
	case when complementary_feeding_start_period is not null then complementary_feeding_start_period else ''N/A'' end as complementary_feeding_start_period
	from rch_child_service_master
	where complementary_feeding_start_period is not null
	and member_id = #member_id# order by id desc limit 1
)
,
basic_info as ( 
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
	case when last_child_service_date is null then ''N/A'' else to_char(last_child_service_date,''dd-MM-yyyy'') end as last_child_service_date,
	-- vaccinazation
	case when bcg is null then ''N/A'' else to_char(bcg,''dd-MM-yyyy'') end as bcg, 
	case when opv1 is null then ''N/A'' else to_char(opv1,''dd-MM-yyyy'') end as opv1, 
	case when penta1 is null then ''N/A'' else to_char(penta1,''dd-MM-yyyy'') end as penta1, 
	case when opv2 is null then ''N/A'' else to_char(opv2,''dd-MM-yyyy'') end as opv2, 
	case when penta2 is null then ''N/A'' else to_char(penta2,''dd-MM-yyyy'') end as penta2, 
	case when opv3 is null then ''N/A'' else to_char(opv3,''dd-MM-yyyy'') end as opv3, 
	case when penta3 is null then ''N/A'' else to_char(penta3,''dd-MM-yyyy'') end as penta3,
	case when measles is null then ''N/A'' else to_char(measles,''dd-MM-yyyy'') end as measles,
	case when fully_immunization_in_number_of_month is not null then 
	case when fully_immunization_in_number_of_month  > 12 then ''Yes'' else ''No'' end  else ''N/A'' end as fully_immunization_in_twelve_of_month ,
	case when opv_booster is null then ''N/A'' else to_char(opv_booster,''dd-MM-yyyy'') end as opv_booster,
	case when dpt_booster is null then ''N/A'' else to_char(dpt_booster,''dd-MM-yyyy'') end as dpt_booster,
	case when measles_2 is null then ''N/A'' else to_char(measles_2,''dd-MM-yyyy'') end as measles_2,
	case when complementary_feeding_start_period is null then ''N/A'' else complementary_feeding_start_period end as complementary_feeding_start_period,
	case when is_breastfed_till_six_month is null then ''N/A'' else is_breastfed_till_six_month end as is_breastfed_till_six_month,
	case when bcg is not null and 
		opv1 is not null and 
		penta1 is not null  and 
		opv2 is not null and 
		penta2 is not null   and 
		opv3 is not null   and  
		penta3 is not null   and  
		opv_booster is not null   and  
		measles is not null   and  
		measles_2 is not null   and  
		dpt_booster is not null and 
		vitamin_a_second_dose.given_on is not null
	
	then case when 
		EXTRACT(year FROM age(GREATEST( opv1, penta1, opv2, penta2, opv3, penta3, opv_booster, measles, measles_2, dpt_booster, vitamin_a_second_dose.given_on  ), child.dob))*12 
		+ EXTRACT(month FROM age(GREATEST( opv1, penta1, opv2, penta2, opv3, penta3, opv_booster, measles, measles_2, dpt_booster, vitamin_a_second_dose.given_on ),child.dob))
		< 24 then ''Yes'' else ''No'' end else ''No'' end as fully_immunization_in_two_year

		
	from rch_child_analytics_details child
	left join imt_member mem on child.member_id = mem.id
	left join imt_member mother on child.mother_id = mother.id
	left join imt_family fam on mem.family_id = fam.family_id
	left join location_master dob_location on child.loc_id = dob_location.id
	left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
	left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
	left join vitamin_a_second_dose on true = true
	left join breast_feeding_info on true = true
	where mem.id = #member_id#
)
,vitamin_a_dose as (
	select #member_id# as member_id, string_agg(given_date, '','') as vitamin_a_dose from ( select to_char(given_on,''dd-MM-yyyy'') as given_date
	from rch_immunisation_master 
	where immunisation_given = ''VITAMIN_A'' 
	and member_id = #member_id# order by given_on asc
	) t	
) 
,side_effect_vaccination_dpt_booster_2 as(
	select 
	#member_id# as member_id, 
	given_on as dpt_booster_2_given_on, 
	adverse_effect as dpt_booster_2_adverse_effect , concat(''Manufacturer:'', manufacturer, '', batch numbe:'' , batch_number)  as vaccination_details 
	from rch_immunisation_master imm 
	left join rch_vaccine_adverse_effect ser on imm.member_id = ser.member_id
	where imm.immunisation_given  = ''DPT_BOOSTER_2''  
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
,side_effect_vaccination_dpt_booster as(
	select 
	child_ser.member_id, 
        child_ser.service_date as dpt_booster_given_date,
        child_ser.weight as dpt_booster_child_weight,
	case when dis.value is not null then case when dis.id = 880 then ''Yes'' else ''No'' end else ''N/A'' end as is_diarrhea, 
	case when dis.value is not null then case when dis.id = 889 then ''Yes'' else ''No'' end else ''N/A'' end as is_pnuemonia 
	from rch_immunisation_master  imm 
	left join rch_child_service_master child_ser on imm.visit_id = child_ser.id
	left join rch_child_service_diseases_rel des on child_ser.id = des.child_service_id
	left join listvalue_field_value_detail dis on des.diseases = dis.id
	where imm.immunisation_given  = ''DPT_BOOSTER''  
	and child_ser.member_id = #member_id#
) 

select bas.*, vitamin_a_dose, 
--case when given_on is not null then to_char(given_on ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_2_given_on,
case when dpt_booster_2_given_on is not null then to_char(dpt_booster_2_given_on ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_2_given_on, 

case when dpt_booster_2_adverse_effect is not null then dpt_booster_2_adverse_effect else ''N/A'' end as dpt_booster_2_adverse_effect, 
case when vaccination_details is not null then vaccination_details else ''N/A'' end as vaccination_details, 

--case when child_ser.service_date is not null then to_char(child_ser.service_date ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_given_date,
case when dpt_booster_given_date is not null then to_char( dpt_booster_given_date ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_given_date, 

case when dpt_booster_child_weight is not null then cast(dpt_booster_child_weight as text ) else ''N/A'' end as dpt_booster_child_weight, 
case when is_diarrhea is null then ''N/A'' else is_diarrhea end as is_diarrhea, 
case when is_pnuemonia is null then ''N/A'' else is_pnuemonia end as is_pnuemonia 
from basic_info bas
left join vitamin_a_dose vit_a on bas.member_id = vit_a.member_id
left join side_effect_vaccination_dpt_booster_2 booster_2 on bas.member_id = booster_2.member_id
left join side_effect_vaccination_dpt_booster booster on bas.member_id = booster.member_id
limit 1' 
where code = 'get_rch_register_child_service_detailed_info';

update query_master 
set query = 'with dates as (
select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
),lmp_followup_det as (
select lfu.member_id
,cast(json_agg(json_build_object(''date'',cast(lfu.service_date as date),''contraception_method'',lfu.family_planning_method)) as text) as lmp_visit_info
from rch_lmp_follow_up lfu
inner join dates on lfu.created_on between dates.from_date and dates.to_date
where
lfu.member_status = ''AVAILABLE'' 
and lfu.member_id = #member_id#
group by lfu.member_id
),eligible_couple_det as (
select
m.id as member_id
,sum(case when fam_mem.mother_id = m.id then 1 else 0 end) as total_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''M''  then 1 else 0 end) as total_male_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''F''  then 1 else 0 end) as total_female_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''M''
 and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then 1 else 0 end) as total_live_male_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''F'' 
and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then 1 else 0 end) as total_live_female_child
,max(case when similarity(fam_mem.first_name,m.middle_name) > 0.8 then fam_mem.id else null end) as husband_id
,min(case when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then m.dob else null end) as last_child_dob
from lmp_followup_det as eligible_couple
inner join imt_member m on m.id = eligible_couple.member_id
left join imt_member fam_mem on fam_mem.family_id = m.family_id
group by m.id
)
select 
m.id as member_id,
m.unique_health_id as unique_health_id,
cast (m.created_on as date)  as registration_date,
concat_ws('' '',m.first_name,m.middle_name,m.last_name) as  member_name,
EXTRACT(YEAR FROM age(cast(m.dob as date))) as member_current_age,
case when m.year_of_wedding is null then null else m.year_of_wedding - date_part(''year'', m.dob)  end as  member_marriage_age,
m.middle_name as husband_name,
EXTRACT(YEAR FROM age(cast(husband.dob as date))) as husband_current_age,
case when m.year_of_wedding is null then null else m.year_of_wedding - date_part(''year'', husband.dob)  end as  husband_marriage_age,
concat_ws('','',f.address1,f.address2) as address,
religion.value as religion,
caste.value as cast,
case when f.bpl_flag then ''BPL'' end as bpl_apl,
ec.total_male_child as total_given_male_birth,
ec.total_female_child as total_given_female_birth,
ec.total_live_male_child as live_male_birth,
ec.total_live_female_child as live_female_birth,
EXTRACT(YEAR FROM age(cast(ec.last_child_dob as date))) as smallest_child_age,
cast(''Male'' as text) as smallest_child_gender,
lmp_followup_det.lmp_visit_info as lmp_visit_info
from lmp_followup_det
inner join imt_member m on m.id = lmp_followup_det.member_id
inner join eligible_couple_det ec on lmp_followup_det.member_id = ec.member_id
inner join imt_family f on f.family_id=m.family_id
left join imt_member husband on husband.id =ec.husband_id
left join listvalue_field_value_detail religion on religion.id = cast(f.religion as int)
left join listvalue_field_value_detail caste on caste.id = cast(f.caste as int);' 
where code = 'get_rch_register_eligible_couple_service_detailed_info';

