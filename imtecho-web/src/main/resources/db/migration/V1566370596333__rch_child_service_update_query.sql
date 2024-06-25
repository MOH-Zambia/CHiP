--get_rch_register_mother_service_basic_info
--get_rch_register_child_service_basic_info


delete from query_master where code = 'get_rch_register_member_details';
delete from query_master where code = 'get_rch_register_mother_service_basic_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_mother_service_basic_info','location_id,to_date,from_date,limit,offset,serviceType','
with location_det as(
	select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
),dates as(
	select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
)
,member_det as (
	(select pregnancy_reg_id as ref_id, member_id
	from rch_pregnancy_analytics_details,dates,location_det
	where ''#serviceType#'' in (''rch_mother_service'') 
	and reg_service_date between dates.from_date and dates.to_date
	and member_current_location_id = location_det.loc_id
	order by pregnancy_reg_id
	limit #limit# offset #offset#)
)
select member_det.ref_id,mem.id as member_id, concat(mem.first_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as member_name,
mem.middle_name as husband_name, concat(fam.address1, '','', fam.address2) as address, date_part(''years'',age(localtimestamp, dob)) as age,
rel.value as religion, cas.value as cast
from imt_member mem
inner join member_det on mem.id = member_det.member_id
inner join imt_family fam on mem.family_id = fam.family_id
left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
',true,'ACTIVE');

delete from query_master where code = 'get_rch_register_child_service_basic_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_child_service_basic_info','location_id,to_date,from_date,limit,offset,serviceType','
with location_det as(
	select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
),dates as(
	select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
)
,member_det as (
	(
	select id as ref_id, member_id
	from rch_child_analytics_details,dates,location_det 
	where ''#serviceType#'' in (''rch_child_service'')
	and date_part(''years'',age(to_date, dob)) < 5 and
	rch_child_analytics_details.loc_id = location_det.loc_id
	order by id
	limit #limit# offset #offset#)
)
select member_det.ref_id,mem.id as member_id, concat(mem.first_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as member_name,
mem.middle_name as father_name, concat(fam.address1, '','', fam.address2) as address, date_part(''years'',age(localtimestamp, dob)) as age, dob as dob
rel.value as religion, cas.value as cast
from imt_member mem
inner join member_det on mem.id = member_det.member_id
inner join imt_family fam on mem.family_id = fam.family_id
left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
',true,'ACTIVE');


delete from query_master where code = 'get_rch_register_child_service_detail_info';
delete from query_master where code = 'get_rch_register_child_service_detailed_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_child_service_detailed_info','member_id','
with test as (
	select given_on
		from rch_immunisation_master 
		where immunisation_given = ''VITAMIN_A'' 
		and member_id = #member_id# 
		order by given_on asc limit 1 offset 1
		
),
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
	case when dpt_booster is null then ''N/A'' else to_char(dpt_booster,''dd-MM-yyyy'') end as dpt_booster,
	case when bcg is not null and 
		opv1 is not null and 
		penta1 is not null  and 
		opv2 is not null and 
		penta2 is not null   and 
		opv3 is not null   and  
		penta3 is not null   and  
		opv_booster is not null   and  
		dpt_booster is not null and 
		test.given_on is not null
	
	then case when 
		EXTRACT(year FROM age(GREATEST( opv1,penta1, opv2,penta2, opv3, penta3,opv_booster, dpt_booster, test.given_on  ), child.dob))*12 
		+ EXTRACT(month FROM age(GREATEST( opv1,penta1, opv2,penta2, opv3, penta3,opv_booster, dpt_booster, test.given_on ),child.dob))
		< 24 then ''Yes'' else ''No'' end else ''No'' end as fully_immunization_in_two_year

		
	from rch_child_analytics_details child
	left join imt_member mem on child.member_id = mem.id
	left join imt_member mother on child.mother_id = mother.id
	left join imt_family fam on mem.family_id = fam.family_id
	left join location_master dob_location on child.loc_id = dob_location.id
	left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
	left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
	left join test on true = true
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
	case when given_on is not null then to_char(given_on ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_2_given_on, 
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
        case when child_ser.service_date is not null then to_char(child_ser.service_date ,''dd-MM-yyyy'') else ''N/A'' end as dpt_booster_given_date,
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

select bas.*, vitamin_a_dose, dpt_booster_2_given_on, dpt_booster_2_adverse_effect, vaccination_details, dpt_booster_given_date, 
dpt_booster_child_weight, is_diarrhea, is_pnuemonia 
from basic_info bas
left join vitamin_a_dose vit_a on bas.member_id = vit_a.member_id
left join side_effect_vaccination_dpt_booster_2 booster_2 on bas.member_id = booster_2.member_id
left join side_effect_vaccination_dpt_booster booster on bas.member_id = booster.member_id
limit 1
',true,'ACTIVE');