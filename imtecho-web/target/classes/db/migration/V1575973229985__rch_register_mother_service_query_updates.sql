
---- get_rch_register_mother_service_detailed_info

update query_master
set query = '
with preg_member as (
    select * from rch_pregnancy_registration_det where id = #preg_reg_id#
)
,pre_preg_comli as (
    select
    string_agg( distinct previous_pregnancy_complication, '','') as previous_complication
    from rch_anc_master rch
    left join rch_anc_previous_pregnancy_complication_rel on rch.id = anc_id
    where rch.pregnancy_reg_det_id = #preg_reg_id#
    	and previous_pregnancy_complication is not null
    group by pregnancy_reg_det_id
)
,basic_member_info as (
    select
    preg.member_id,
    case
    	when date_of_delivery is null then ''N/A''
    	else to_char(date_of_delivery,''dd-MM-yyyy'')
	end as date_of_delivery,
    mem.unique_health_id,
    case
    	when preg.lmp_date is null then ''N/A''
    	else to_char(preg.lmp_date,''dd-MM-yyyy'')
	end as lmp_date,
    case
    	when preg.reg_service_date is null then ''N/A''
    	else to_char(preg.reg_service_date,''dd-MM-yyyy'')
	end as reg_service_date,
    case
    	when reg_service_date is not null and lmp_date is not null then cast(TRUNC(DATE_PART(''day'', cast(reg_service_date as timestamp) - cast(lmp_date as timestamp))/7) as text)
    	else null
	end as pregnancy_week_number,
    preg.member_name,
    case
    	when early_anc is true then ''Yes''
    	else ''No''
	end as twelve_pregnancy_week_number,
    case
    	when mem.middle_name is null then ''N/A''
    	else mem.middle_name
	end as husband_name,
    case
    	when to_char(preg.edd,''dd-MM-yyyy'') is null then ''N/A''
    	else to_char(preg.edd,''dd-MM-yyyy'')
	end as edd,
    case
    	when cast(preg.age_during_delivery as text) is null then ''N/A''
    	else cast(preg.age_during_delivery as text)
	end as age_during_delivery,
    case
    	when to_char(mem.dob,''dd-MM-yyyy'') is null then ''N/A''
    	else to_char(mem.dob,''dd-MM-yyyy'')
	end as dob,
    case
    	when preg.expected_delivery_place is null then ''N/A''
    	when preg.expected_delivery_place = ''CHIRANJEEVIHOSP'' then ''Private Hosptial (Chiranjeevi)''
    	when preg.expected_delivery_place = ''PRIVATEHOSP'' then ''Private Hosptial''
    	when preg.expected_delivery_place = ''DISTRICTHOSP'' then ''District Hospital''
    	when preg.expected_delivery_place = ''SUBDISTRICTHOSP'' then ''Sub-District Hospital''
    	when preg.expected_delivery_place = ''OTHER'' then ''Other''
    	when preg.expected_delivery_place = ''TRUSTHOSP'' then ''Trust Hospital''
    	when preg.expected_delivery_place = ''SUBCENTER'' then ''Subcenter''
    	else preg.expected_delivery_place
	end as expected_delivery_place,
    case
    	when cast(mem.weight as text) is null then ''N/A''
    	else cast(mem.weight as text)
	end as weight,
    case
    	when mem.blood_group is null then ''N/A''
    	else mem.blood_group
	end as blood_group,
    case
    	when (fam.address1 is null and fam.address2 is null) then ''N/A''
    	else
    	    case
    	        when fam.address1 is null then fam.address2
    	        when fam.address2 is null then fam.address1
    	        else concat(fam.address1, '','', fam.address2)
            end
	end as address,
    case
    	when mem.mobile_number is null then ''N/A''
    	else mem.mobile_number
	end as mobile_number,
    case
    	when rel.value is null then ''N/A''
    	else rel.value
	end as religion,
    case
    	when cas.value is null then ''N/A''
    	else cas.value
	end as cast,
    case
    	when del_week is null then ''N/A''
	 	when fam.bpl_flag then ''BPL''
	 	else ''APL''
 	end as bpl_flag,
    case
    	when pre_com.previous_complication is null then ''N/A''
    	else pre_com.previous_complication
	end as previous_complication,
	preg.total_out_come as total_child_out_come
    from rch_pregnancy_analytics_details preg
    inner join imt_member mem on preg.member_id = mem.id
    inner join imt_family fam on mem.family_id = fam.family_id
    left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
    left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
    left join pre_preg_comli pre_com on true = true
    where preg.pregnancy_reg_id = #preg_reg_id#
)
,preg_reg_id_for_pre_preg_detail as (
    select
    preg.id
    from rch_pregnancy_registration_det preg
    inner join preg_member mem on mem.member_id = preg.member_id
    where preg.reg_date < mem.reg_date
    	and preg.id != mem.id
    	and preg.member_id = mem.member_id
    	and preg.state = ''DELIVERY_DONE''
)
,gender_info as(
    select
    string_agg(case when gender = ''M'' then ''Male'' when gender = ''F'' then ''Female'' else ''N/A'' end, '','') as preg_gender,
    pregnancy_reg_det_id
    from rch_wpd_mother_master mother
    left join rch_wpd_child_master child on mother.id = child.wpd_mother_id
    where pregnancy_reg_det_id in (select * from  preg_reg_id_for_pre_preg_detail)
    group by pregnancy_reg_det_id
)
,previous_pregnancy_details as (
 	select
	cast( json_agg(t) as text) as previous_pregnancy_details_json from (
    	select reg_id.id,string_agg(value, '','') as preg_complication,preg_gender
    	from preg_reg_id_for_pre_preg_detail reg_id
    	left join gender_info on reg_id.id = gender_info.pregnancy_reg_det_id
    	left join rch_anc_master anc on reg_id.id = anc.pregnancy_reg_det_id
    	left join rch_anc_dangerous_sign_rel rel on rel.anc_id = anc.id
    	left join listvalue_field_value_detail list on rel.dangerous_sign_id = list.id
    	group by reg_id.id, preg_gender
  	) t
)
,previous_preg_complication as (
	select
	STRING_AGG(previous_pregnancy_complication, '', '') as previous_preg_complication,
	signs.anc_id
	from rch_anc_master anc
	inner join preg_member pm on anc.pregnancy_reg_det_id  = pm.id
	inner join rch_anc_previous_pregnancy_complication_rel signs on anc.id = signs.anc_id
	group by signs.anc_id
)
,anc_danger_signs as (
	select
	STRING_AGG(list.value, '', '') as anc_danger_signs,
	signs.anc_id
	from rch_anc_master anc
	inner join preg_member pm on anc.pregnancy_reg_det_id  = pm.id
	inner join rch_anc_dangerous_sign_rel signs on anc.id = signs.anc_id
	inner join listvalue_field_value_detail list on list.id = signs.dangerous_sign_id
	group by signs.anc_id
)
,pre_delivery_care as (
	select cast( json_agg(t) as text) as pre_delivery_care_json from (
		select
		case
			when service_date is null then ''N/A''
			else to_char(service_date,''dd-MM-yyyy'')
		end as inspection_date,
		case
			when ins_place.name is not null then ins_place.name
			else
			    case
			        when anc.delivery_place is null then ''N/A''
			        when anc.delivery_place = ''108_AMBULANCE'' then ''108 Abmbulance''
                    when anc.delivery_place = ''HOSP'' then ''Hospital''
                    when anc.delivery_place = ''HOME'' then ''Home''
                    when anc.delivery_place = ''ON_THE_WAY'' then ''On the way''
                    when anc.delivery_place = ''THISHOSP'' then ''This Hospital''
                    when anc.delivery_place = ''MAMTA_DAY'' then ''Mamta Day''
                    else anc.delivery_place
                end
		end as inspection_place,
		case
			when ins_place_type.value is not null then ins_place_type.value
			else null
		end as inspection_place_type,
		case
			when ((cast(anc.service_date as text) is null) or (cast(rprd.lmp_date as text) is null)) then ''0.0''
			else TRUNC(DATE_PART(''day'', cast(anc.service_date as timestamp) - cast(rprd.lmp_date as timestamp))/7)
		end as pregnancy_week,
		case
			when cast(anc.weight as text) is null then ''N/A''
			else cast(anc.weight as text)
		end as preg_women_weight,
		case
			when cast(anc.hiv_test as text) is null then ''N/A''
			when cast(anc.hiv_test as text) = ''POSITIVE'' then ''Positive''
			when cast(anc.hiv_test as text) = ''NOT_DONE'' then ''Not done''
			when cast(anc.hiv_test as text) = ''NEGATIVE'' then ''Negative''
			else cast(anc.hiv_test as text)
		end as hiv_test,
		case
			when cast(anc.vdrl_test as text) is null then ''N/A''
			when cast(anc.vdrl_test as text) = ''POSITIVE'' then ''Positive''
			when cast(anc.vdrl_test as text) = ''NOT_DONE'' then ''Not done''
			when cast(anc.vdrl_test as text) = ''NEGATIVE'' then ''Negative''
			else cast(anc.vdrl_test as text)
		end as vdrl_test,
		case
			when cast(systolic_bp as text) is null then ''N/A''
			else cast(systolic_bp as text)
		end as systolic_bp,
		case
			when cast(diastolic_bp as text) is null then ''N/A''
			else cast(diastolic_bp as text)
		end as diastolic_bp,
		case
			when cast(haemoglobin_count as text) is null then null
			else cast(ROUND(CAST(haemoglobin_count as numeric), 2) as text)
		end as haemoglobin_count,
		case
			when cast(fa_tablets_given as text) is null then ''N/A''
			else cast(fa_tablets_given as text)
		end as falic_acid_tablets,
		case
			when cast(ifa_tablets_given as text) is null then null
			else cast(ifa_tablets_given as text)
		end as ifa_tablet,
		case
			when urine_test_done is null then ''N/A''
			when urine_test_done then ''Yes''
			else ''No''
		end as urine_test_done,
		case
			when cast(urine_albumin as text) is null then ''N/A''
			else urine_albumin
		end as urine_albumin,
		case
			when cast(urine_sugar as text) is null then ''N/A''
			else cast(urine_sugar as text)
		end as urine_sugar,
		case
			when sugar_test_before_food_val is null then ''N/A''
			else cast(sugar_test_before_food_val as text)
		end as sugar_test_before_food_val,
		case
			when cast(sugar_test_after_food_val as text) is null then ''N/A''
			else cast(sugar_test_after_food_val as text)
		end as sugar_test_after_food_val,
		case
			when immun.immunisation_given is not null and immun.immunisation_given = ''TT1'' then to_char(immun.given_on,''dd-MM-yyyy'')
			else null
		end as tt1,
		case
			when immun.immunisation_given is not null and immun.immunisation_given = ''TT2'' then to_char(immun.given_on,''dd-MM-yyyy'')
			else null
		end as tt2,
		case
			when immun.immunisation_given is not null and immun.immunisation_given = ''TT_BOOSTER'' then to_char(immun.given_on,''dd-MM-yyyy'')
			else null
		end as ttb,
		case
			when cast(foetal_height as text) is null then ''N/A''
			else cast(foetal_height as text)
		end as foetal_height,
		case
			when foetal_heart_sound is null then ''N/A''
			when foetal_heart_sound is true then ''Yes''
			else ''No''
		end as foetal_heart_sound,
		case
			when cast(foetal_position as text) is null then ''N/A''
			when cast(foetal_position as text) = ''CBMO'' then ''Cannot be made out''
			else cast(foetal_position as text)
		end as foetal_position,
		case
			when cast(foetal_movement as text) is null then ''N/A''
			else cast(foetal_movement as text)
		end as foetal_movement,
		case
			when cast(anc.referral_done as text) is null then ''N/A''
			when cast(anc.referral_done as text) = ''false'' OR cast(anc.referral_done as text) = ''NOT_REQUIRED'' then ''NO''
			when cast(anc.referral_done as text) = ''true'' then ''YES''
			else cast(anc.referral_done as text)
		end as referral_done,
		case
			when anc.family_planning_method is null then ''N/A''
			when anc.family_planning_method = ''NONE'' then ''None''
            when anc.family_planning_method = ''ANTARA'' then ''Antara''
            when anc.family_planning_method = ''IUCD5'' then ''IUCD 5 Years''
            when anc.family_planning_method = ''IUCD10'' then ''IUCD 10 Years''
            when anc.family_planning_method = ''CONDOM'' then ''Condom''
            when anc.family_planning_method = ''ORALPILLS'' then ''Oral Pills''
            when anc.family_planning_method = ''CHHAYA'' then ''Chhaya''
            when anc.family_planning_method = ''ANTARA'' then ''Antara''
            when anc.family_planning_method = ''CONTRA'' then ''Emergency Contraceptive Pills''
            when anc.family_planning_method = ''FMLSTR'' then ''Female Sterilization''
            when anc.family_planning_method = ''MLSTR'' then ''Male Sterilization''
            when anc.family_planning_method = ''OTHER'' then ''Other''
            when anc.family_planning_method = ''CHHANT'' then ''Chhant''
			else anc.family_planning_method
		end as family_planning_method,
		case
			when cast(dead_flag as text) = ''true'' then ''NO''
			else ''YES''
		end as alive_flag,
		case
			when death_reas.value is null then ''N/A''
			else death_reas.value
		end as death_reason,
		case
			when anc.death_date is null then ''N/A''
			else to_char(cast(anc.death_date as date),''dd-MM-yyyy'')
		end as death_date,
		case
			when anc.place_of_death is null then ''N/A''
			else anc.place_of_death
		end as death_place,
		case
			when extract(day from (case when anc.service_date is not null then anc.service_date else anc.created_on end) - rprd.lmp_date) <= 92 then cast(1 as text)
			when extract(day from (case when anc.service_date is not null then anc.service_date else anc.created_on end) - rprd.lmp_date) <= 190 then cast(2 as text)
			when extract(day from (case when anc.service_date is not null then anc.service_date else anc.created_on end) - rprd.lmp_date) <= 246 then cast(3 as text)
			when extract(day from (case when anc.service_date is not null then anc.service_date else anc.created_on end) - rprd.lmp_date) > 246 then cast(4 as text)
			else ''Unscheduled''
		end as anc_visit_number,
		case
			when DATE_PART(''hour'', cast(service_date as timestamp) - cast(rwmm.date_of_delivery as timestamp)) <= 24 then ''Yes''
			else null
		end as is_cortico_steroid_given,
		ads.anc_danger_signs,
		ppc.previous_preg_complication
		from rch_anc_master anc
        left join rch_immunisation_master immun on anc.id = immun.visit_id
        	and immun.immunisation_given in ( ''TT1'',''TT2'',''TT_BOOSTER'')
    	left join rch_wpd_mother_master rwmm on anc.pregnancy_reg_det_id = rwmm.pregnancy_reg_det_id
    		and rwmm.has_delivery_happened is true and rwmm.state is null
		left join anc_danger_signs ads on ads.anc_id = anc.id
		left join previous_preg_complication ppc on ppc.anc_id = anc.id
		left join rch_pregnancy_registration_det rprd on rprd.id = anc.pregnancy_reg_det_id
		left join health_infrastructure_details ins_place on anc.health_infrastructure_id = ins_place.id
		left join listvalue_field_value_detail ins_place_type on anc.type_of_hospital = ins_place_type.id
		left join listvalue_field_value_detail death_reas on anc.death_reason = (cast(death_reas.id as varchar))
		where anc.pregnancy_reg_det_id = #preg_reg_id#
		order by service_date
	) t
)
,child_congential_deformity as (
	select
	STRING_AGG(list.value, '', '') as child_congential_deformity,
	deformity.wpd_id
	from preg_member
	inner join rch_wpd_mother_master wpd_mother on wpd_mother.pregnancy_reg_det_id = preg_member.id
	inner join rch_wpd_child_master wpd_child on wpd_child.wpd_mother_id = wpd_mother.id
	inner join rch_wpd_child_congential_deformity_rel deformity on deformity.wpd_id = wpd_child.id
	inner join listvalue_field_value_detail list on list.id = deformity.congential_deformity
	group by deformity.wpd_id
)
,delivery_result as(
	select cast(json_agg(t) as text) as delivery_result_json from (
		select
		child.member_id,
		case
			when mother.pregnancy_outcome in (''SPONT_ABORTION'',''ABORTION'') then
				case
					when infra.name is not null then concat(infra.name,'', '', hos.value)
					else
						case
							when hos.value is not null then hos.value
							else delivery_place
						end
                end
        end as abortion_place,
		case
			when mother.date_of_delivery is null then ''N/A''
			else to_char(mother.date_of_delivery,''dd-MM-yyyy HH:mm:ss'')
		end as date_of_delivery,
		case
		    when infra.name is not null then infra.name
			else
			    case
			        when delivery_place is null then ''N/A''
			        when delivery_place = ''108_AMBULANCE'' then ''108 Abmbulance''
                    when delivery_place = ''HOSP'' then ''Hospital''
                    when delivery_place = ''HOME'' then ''Home''
                    when delivery_place = ''ON_THE_WAY'' then ''On the way''
                    when delivery_place = ''THISHOSP'' then ''This Hospital''
                    when delivery_place = ''MAMTA_DAY'' then ''Mamta Day''
                    else delivery_place
                end
		end as delivery_place,
		case
		    when hos.value is not null then hos.value
			else null
		end as delivery_place_type,
		case
			when delivery_done_by is null then ''N/A''
			when delivery_done_by = ''NON-TBA'' then ''Non TBA''
			when delivery_done_by = ''DOCTOR'' then ''Doctor''
			when delivery_done_by = ''CY-Doctor'' then ''CY Doctor''
			when delivery_done_by = ''STAFF_NURSE'' then ''Staff Nurse''
			when delivery_done_by = ''NURSE'' then ''Nurse''
			when delivery_done_by = ''NON_TBA'' then ''Non TBA''
			else delivery_done_by
		end as delivery_done_by,
		case
			when mother.type_of_delivery is null then ''N/A''
			when mother.type_of_delivery = ''CAESAREAN'' then ''Caesarean''
			when mother.type_of_delivery = ''ASSIST'' then ''Assist''
			when mother.type_of_delivery = ''NORMAL'' then ''Normal''
			else mother.type_of_delivery
		end as type_of_delivery,
		case
			when mother.other_danger_signs is null then ''N/A''
			else mother.other_danger_signs
		end as other_danger_signs,
		case
			when discharge_date is null then ''N/A''
			else to_char( discharge_date,''dd-MM-yyyy HH:mm:ss'')
		end as discharge_date,
		case
			when child.pregnancy_outcome = ''LBIRTH'' then ''Alive''
			when child.pregnancy_outcome = ''SBIRTH'' then ''Dead''
			else ''N/A''
		end as is_alive_dead,
		case
	     	when was_premature then ''Yes''
			else ''No''
     	end as was_premature,
		case
			when gender is null then ''N/A''
	     	when gender = ''F'' then ''Female''
	     	else ''Male''
     	end as gender ,
		case
			when baby_cried_at_birth is null then ''N/A''
			when baby_cried_at_birth then ''Yes''
			else ''No''
		end as baby_cried_at_birth,
		case
			when birth_weight is null then null
			else cast(ROUND(CAST(birth_weight as numeric), 2) as text)
		end as birth_weight,
		case
			when child.breast_feeding_in_one_hour then ''Yes''
			else ''No''
		end as breast_feeding_in_one_hour,
		case
			when child.referral_place is null then ''N/A''
			else ''Yes''
		end as referral_perform,
		case
			when child.member_id is null then ''N/A''
			when max(case when immunisation_given = ''OPV_0'' then immun.given_on end) is not null then to_char(max(case when immunisation_given = ''OPV_0'' then immun.given_on end),''dd-MM-yyyy'')
			else ''No''
		end as opv_given,
		case
			when child.member_id is null then ''N/A''
			when max(case when immunisation_given = ''HEPATITIS_B_0'' then immun.given_on end) is not null then to_char(max(case when immunisation_given = ''HEPATITIS_B_0'' then immun.given_on end),''dd-MM-yyyy'')
			else ''No''
		end as hep_b_given,
		case
			when child.member_id is null then ''N/A''
			when max(case when immunisation_given = ''VITAMIN_K'' then immun.given_on end) is not null then to_char(max(case when immunisation_given = ''VITAMIN_K'' then immun.given_on end),''dd-MM-yyyy'')
			else ''No''
		end as vit_k_given,
		case
			when child.member_id is null then ''N/A''
			when max(case when immunisation_given = ''BCG'' then immun.given_on end) is not null then to_char(max(case when immunisation_given = ''BCG'' then immun.given_on end),''dd-MM-yyyy'')
			else ''No''
		end as bcg_given,
		case
			when child.referral_infra_id is not null then ''Yes''
			else ''No''
		end as is_referral_done,
		cd.child_congential_deformity
		from rch_wpd_mother_master mother
		left join rch_wpd_child_master child on mother.id = child.wpd_mother_id
		left join child_congential_deformity cd on cd.wpd_id = child.id
		left join rch_immunisation_master immun on child.id = immun.visit_id
			and visit_type = ''FHW_WPD''
			and  member_type = ''C''
		left join health_infrastructure_details infra on mother.health_infrastructure_id = infra.id
		left join listvalue_field_value_detail hos on mother.type_of_hospital = hos.id
		where mother.pregnancy_reg_det_id = #preg_reg_id#
			and mother.has_delivery_happened = true
			and (mother.state is null or mother.state != ''MARK_AS_FALSE_DELIVERY'')
		group by wpd_mother_id, mother.date_of_delivery, delivery_place, delivery_done_by, mother.type_of_delivery,
			discharge_date, was_premature, gender, baby_cried_at_birth, birth_weight, child.breast_feeding_in_one_hour,
			mother.pregnancy_outcome, infra.name, infra.address, hos.value, child.pregnancy_outcome, immun.visit_id, child.member_id,
			mother.other_danger_signs, child.referral_place, cd.child_congential_deformity, child.referral_infra_id
	) t
)
,pnc_visit as (
	select
	cast(json_agg(t) as text) as pnc_visit_json from (
		select
		to_char(mas.service_date,''dd-MM-yyyy'') as service_date,
		case
			when mother_pnc.ifa_tablets_given is null then ''N/A''
			else cast(mother_pnc.ifa_tablets_given as text)
		end as ifa_tablets_given,
		case
			when mother_pnc.other_danger_sign is null then ''No''
			else cast(mother_pnc.other_danger_sign as text)
		end as other_danger_sign,
		case
			when referral.value is null then ''N/A''
			else referral.value
		end as referral_place,
		case
			when mother_pnc.family_planning_method is null then ''N/A''
			when mother_pnc.family_planning_method = ''NONE'' OR mother_pnc.family_planning_method = ''none'' then ''None''
            when mother_pnc.family_planning_method = ''ANTARA'' then ''Antara''
            when mother_pnc.family_planning_method = ''IUCD5'' then ''IUCD 5 Years''
            when mother_pnc.family_planning_method = ''IUCD10'' then ''IUCD 10 Years''
            when mother_pnc.family_planning_method = ''CONDOM'' then ''Condom''
            when mother_pnc.family_planning_method = ''ORALPILLS'' then ''Oral Pills''
            when mother_pnc.family_planning_method = ''CHHAYA'' then ''Chhaya''
            when mother_pnc.family_planning_method = ''ANTARA'' then ''Antara''
            when mother_pnc.family_planning_method = ''CONTRA'' then ''Emergency Contraceptive Pills''
            when mother_pnc.family_planning_method = ''FMLSTR'' then ''Female Sterilization''
            when mother_pnc.family_planning_method = ''MLSTR'' then ''Male Sterilization''
            when mother_pnc.family_planning_method = ''OTHER'' then ''Other''
			when mother_pnc.family_planning_method = ''CHHANT'' then ''Chhant''
			else mother_pnc.family_planning_method
		end as family_planning_method,
		case
	    	when mother_pnc.is_alive is false then ''NO''
	    	else ''YES''
    	end as is_alive,
		case
			when mother_death_reason.value is null then ''N/A''
			else mother_death_reason.value
		end as death_reason,
		case
			when mother_pnc.death_date is null then ''N/A''
			else to_char(cast(mother_pnc.death_date as date),''dd-MM-yyyy'')
		end as death_date,
		case
			when mother_pnc.place_of_death is null then ''N/A''
			when mother_pnc.place_of_death = ''HOME'' then ''Home''
			when mother_pnc.place_of_death = ''HOSP'' then ''Hospital''
			when mother_pnc.place_of_death = ''ON_THE_WAY'' then ''On The Way''
			else mother_pnc.place_of_death
		end as place_of_death,
		concat(''['',
		    string_agg(
		    cast((
		        select
		        row_to_json(a)
		        from (
		            select
		            child_pnc.*,
		            child_death.value as child_death_reason,
		            case
		                when child_pnc.is_alive is false then ''NO''
		                else ''YES''
                    end as is_child_alive,
                    to_char(child_pnc.death_date,''dd-MM-yyyy'') as parsed_death_date,
		            case
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 1 then cast(1 as text)
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 3 then cast(2 as text)
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 7 then cast(3 as text)
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 14 then cast(4 as text)
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 21 then cast(5 as text)
                        when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 28 then cast(6 as text)
                        else ''Unscheduled''
                    end as pnc_visit_number,
                    to_char(mas.service_date,''dd-MM-yyyy'') as service_date
                ) a
            ) as text),
            '',''),
        '']'') as child_pnc_dto,
		case
			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 1 then cast(1 as text)
 			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 3 then cast(2 as text)
			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 7 then cast(3 as text)
 			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 14 then cast(4 as text)
 			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 21 then cast(5 as text)
			when extract(day from (case when mas.service_date is not null then mas.service_date else mas.created_on end) - im.dob) <= 28 then cast(6 as text)
 			else ''Unscheduled''
		end as pnc_visit_number
		from rch_pnc_master mas
		left join rch_pnc_mother_master mother_pnc on mas.id = mother_pnc.pnc_master_id
		left join rch_pnc_child_master child_pnc on mas.id = child_pnc.pnc_master_id
		left join imt_member im on child_pnc.child_id = im.id
		left join listvalue_field_value_detail referral on mother_pnc.referral_place = referral.id
		left join listvalue_field_value_detail mother_death_reason on mother_pnc.death_reason = cast(mother_death_reason.id as text)
		left join listvalue_field_value_detail child_death on cast(child_death.id as text) = child_pnc.death_reason
		where mas.pregnancy_reg_det_id = #preg_reg_id#
		group by mas.id,mother_pnc.ifa_tablets_given, mother_pnc.other_danger_sign, referral.value,
			mother_pnc.family_planning_method, mother_pnc.is_alive,
			mother_death_reason.value, mother_pnc.death_date, mother_pnc.place_of_death, im.dob
		order by mas.service_date
 	) t
)
select
*
from basic_member_info, previous_pregnancy_details, pre_delivery_care, delivery_result, pnc_visit
' where code = 'get_rch_register_mother_service_detailed_info';
