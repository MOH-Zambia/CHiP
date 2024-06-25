
---- update get_rch_register_child_service_detailed_info

update query_master
set query = '
with vitamin_a_second_dose as (
	select
	given_on
	from rch_immunisation_master
	where immunisation_given = ''VITAMIN_A''
		and member_id = #member_id#
	order by given_on asc
	limit 1
	offset 1
),
breast_feeding_info as (
	select
	case
		when complementary_feeding_start_period = ''BEFORE6'' then ''Yes''
		else ''No''
	end as is_breastfed_till_six_month,
	case
		when complementary_feeding_start_period is null then ''N/A''
		when complementary_feeding_start_period = ''ENDOF6'' then ''End of 6th month''
		when complementary_feeding_start_period = ''AFTER6'' then ''After 6th month''
		when complementary_feeding_start_period = ''BEFORE6'' then ''Before 6th month''
		else complementary_feeding_start_period
	end as complementary_feeding_start_period
	from rch_child_service_master
	where complementary_feeding_start_period is not null
		and member_id = #member_id#
	order by id desc
	limit 1
),
basic_info as (
	select
	mem.id as member_id,
	mem.unique_health_id as child_unique_health_id,
	child.member_name,
	case
		when mem.gender is not null then
			case
				when mem.gender = ''F'' then ''Female''
				else ''Male''
			end else ''N/A''
		end as gender ,
		case
			when mother.first_name is not null then mother.first_name
			else ''N/A''
		end as mother_name,
		case
			when mother.unique_health_id is not null then mother.unique_health_id
			else ''N/A''
		end as mother_unique_health_id,
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
			when child.dob is not null then to_char(child.dob ,''dd-MM-yyyy'')
			else ''N/A''
		end as dob,
		case
			when child.birth_weight is not null then cast(round(cast(child.birth_weight as numeric), 1) as text)
			else null
		end as birth_weight,
		case
			when child.loc_id is not null then dob_location.name
			else ''N/A''
		end as birth_location,
		case
			when rel.value = ''HINDU'' then ''Hindu''
			when rel.value = ''CHRISTIAN'' then ''Christian''
			when rel.value = ''MUSLIM'' then ''Muslim''
			when rel.value = ''OTHERS'' then ''Others''
			else rel.value
		end as religion,
		case
			when cas.value = ''GENERAL'' then ''General''
			else cas.value
		end as cast,
		case
			when last_child_service_date is null then ''N/A''
			else to_char(last_child_service_date,''dd-MM-yyyy'')
		end as last_child_service_date,
		-- vaccinazation
		case
			when bcg is null then ''N/A''
			else to_char(bcg,''dd-MM-yyyy'')
		end as bcg,
		case
			when opv1 is null then ''N/A''
			else to_char(opv1,''dd-MM-yyyy'')
		end as opv1,
		case
			when penta1 is null then ''N/A''
			else to_char(penta1,''dd-MM-yyyy'')
		end as penta1,
		case
			when opv2 is null then ''N/A''
			else to_char(opv2,''dd-MM-yyyy'')
		end as opv2,
		case
			when penta2 is null then ''N/A''
			else to_char(penta2,''dd-MM-yyyy'')
		end as penta2,
		case
			when opv3 is null then ''N/A''
			else to_char(opv3,''dd-MM-yyyy'')
		end as opv3,
		case
			when penta3 is null then ''N/A''
			else to_char(penta3,''dd-MM-yyyy'')
		end as penta3,
		case
			when measles is null then ''N/A''
			else to_char(measles,''dd-MM-yyyy'')
		end as measles,
		case
			when f_ipv1 is null then ''N/A''
			else to_char(f_ipv1,''dd-MM-yyyy'')
		end as f_ipv_1,
		case
			when f_ipv2 is null then ''N/A''
			else to_char(f_ipv2,''dd-MM-yyyy'')
		end as f_ipv_2,
		case
			when measles_rubella is null then ''N/A''
			else to_char(measles_rubella,''dd-MM-yyyy'')
		end as measles_rubella,
		case
			when measles_rubella_2 is null then ''N/A''
			else to_char(measles_rubella_2,''dd-MM-yyyy'')
		end as measles_rubella_2,
		case
			when fully_immunization_in_number_of_month is not null then
				case
					when fully_immunization_in_number_of_month  > 12 then ''Yes''
					else ''No''
				end
			else ''N/A''
		end as fully_immunization_in_twelve_of_month ,
		case
			when opv_booster is null then ''N/A''
			else to_char(opv_booster,''dd-MM-yyyy'')
		end as opv_booster,
		case
			when dpt_booster is null then ''N/A''
			else to_char(dpt_booster,''dd-MM-yyyy'')
		end as dpt_booster,
		case
			when measles_2 is null then ''N/A''
			else to_char(measles_2,''dd-MM-yyyy'')
		end as measles_2,
		case
			when rota_virus_1 is null then ''N/A''
			else to_char(rota_virus_1,''dd-MM-yyyy'')
		end as rota_virus_1,
		case
			when rota_virus_2 is null then ''N/A''
			else to_char(rota_virus_2,''dd-MM-yyyy'')
		end as rota_virus_2,
		case
			when rota_virus_3 is null then ''N/A''
			else to_char(rota_virus_3,''dd-MM-yyyy'')
		end as rota_virus_3,
		case
			when complementary_feeding_start_period is null then ''N/A''
			else complementary_feeding_start_period
		end as complementary_feeding_start_period,
		case
			when is_breastfed_till_six_month is null then ''No''
			else is_breastfed_till_six_month
		end as is_breastfed_till_six_month,
		case
			when bcg is not null
				and opv1 is not null
				and penta1 is not null
				and opv2 is not null
				and penta2 is not null
				and opv3 is not null
				and penta3 is not null
				and opv_booster is not null
				and measles is not null
				and measles_2 is not null
				and dpt_booster is not null
				and vitamin_a_second_dose.given_on is not null
				then
					case
						when EXTRACT(
							year FROM age(GREATEST(opv1, penta1, opv2, penta2, opv3, penta3, opv_booster, measles, measles_2, dpt_booster, vitamin_a_second_dose.given_on), child.dob))*12
							+ EXTRACT(
							month FROM age(GREATEST(opv1, penta1, opv2, penta2, opv3, penta3, opv_booster, measles, measles_2, dpt_booster, vitamin_a_second_dose.given_on), child.dob)) < 24
							then ''Yes''
						else ''No''
					end
			else ''No''
		end as fully_immunization_in_two_year
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
),
vitamin_a_dose as (
	select
	#member_id# as member_id,
	string_agg(given_date, '','') as vitamin_a_dose
	from (select to_char(given_on,''dd-MM-yyyy'') as given_date
	from rch_immunisation_master
	where immunisation_given = ''VITAMIN_A''
		and member_id = #member_id#
	order by given_on asc
	) t
)
,side_effect_vaccination_dpt_booster_2 as(
	select
	#member_id# as member_id,
	given_on as dpt_booster_2_given_on,
	adverse_effect as dpt_booster_2_adverse_effect,
	concat(''Manufacturer:'', manufacturer, '', batch numbe:'' , batch_number) as vaccination_details
	from rch_immunisation_master imm
	left join rch_vaccine_adverse_effect ser on imm.member_id = ser.member_id
	where imm.immunisation_given = ''DPT_BOOSTER_2''
		and imm.member_id = #member_id#
),
extra_info as (
	select
	case
		when complementary_feeding_start_period is not null then
			case
				when complementary_feeding_start_period = ''AFTER6'' then ''Yes''
				else ''No''
			end
		else ''N/A''
	end as breast_feeded_upto_six_month
	from rch_child_service_master
	where complementary_feeding_started = true
	and member_id = #member_id#
	order by service_date desc
	limit 1
),
side_effect_vaccination_dpt_booster as(
	select
	child_ser.member_id,
    child_ser.service_date as dpt_booster_given_date,
    case
        when child_ser.weight is not null then cast(round(cast(child_ser.weight as numeric), 1) as text)
        else null
    end as dpt_booster_child_weight,
	case
		when dis.value is not null then
			case
				when dis.id = 880 then ''Yes''
				else ''No''
			end
		else ''N/A''
	end as is_diarrhea,
	case
		when dis.value is not null then
			case
				when dis.id = 889 then ''Yes''
				else ''No''
			end
		else ''N/A''
	end as is_pnuemonia
	from rch_immunisation_master  imm
	left join rch_child_service_master child_ser on imm.visit_id = child_ser.id
	left join rch_child_service_diseases_rel des on child_ser.id = des.child_service_id
	left join listvalue_field_value_detail dis on des.diseases = dis.id
	where imm.immunisation_given  = ''DPT_BOOSTER''
	and child_ser.member_id = #member_id#
)
select
bas.*,
vitamin_a_dose,
--case when given_on is not null then to_char(given_on ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_2_given_on,
case
	when dpt_booster_2_given_on is not null then to_char(dpt_booster_2_given_on ,''dd-MM-yyyy'')
	else ''N/A''
end as dpt_booster_2_given_on,
case
	when dpt_booster_2_adverse_effect is not null then dpt_booster_2_adverse_effect
	else ''N/A''
end as dpt_booster_2_adverse_effect,
case
	when vaccination_details is not null then vaccination_details
	else ''N/A''
end as vaccination_details,
--case when child_ser.service_date is not null then to_char(child_ser.service_date ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_given_date,
case
	when dpt_booster_given_date is not null then to_char( dpt_booster_given_date ,''dd-MM-yyyy'')
	else ''N/A''
end as dpt_booster_given_date,
case
	when dpt_booster_child_weight is not null then cast(round(cast(dpt_booster_child_weight as numeric), 1) as text)
	else null
end as dpt_booster_child_weight,
case
	when is_diarrhea is null then ''N/A''
	else is_diarrhea
end as is_diarrhea,
case
	when is_pnuemonia is null then ''N/A''
	else is_pnuemonia
end as is_pnuemonia
from basic_info bas
left join vitamin_a_dose vit_a on bas.member_id = vit_a.member_id
left join side_effect_vaccination_dpt_booster_2 booster_2 on bas.member_id = booster_2.member_id
left join side_effect_vaccination_dpt_booster booster on bas.member_id = booster.member_id
limit 1
' where code = 'get_rch_register_child_service_detailed_info';
