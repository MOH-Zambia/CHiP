INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('RCH Register - Village Profile Development','manage',TRUE,'techo.manage.rchregister','{}');

CREATE INDEX idx_rch_pregnancy_analytics_details_pregnancy_reg_id
  ON public.rch_pregnancy_analytics_details
  (pregnancy_reg_id);

CREATE INDEX rch_child_analytics_details_id_indx
  ON public.rch_child_analytics_details
  (id);


CREATE INDEX idx_rch_pregnancy_analytics_details_member_current_location_id
  ON public.rch_pregnancy_analytics_details
(member_current_location_id);

delete from query_master where code = 'get_rch_register_member_details';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_member_details','location_id,to_date,from_date,limit,offset,serviceType','
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
	union all
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
mem.middle_name as husband_name, concat(fam.address1, '','', fam.address2) as address, date_part(''years'',age(localtimestamp, dob)) as age,
rel.value as religion, cas.value as cast
from imt_member mem
inner join member_det on mem.id = member_det.member_id
inner join imt_family fam on mem.family_id = fam.family_id
left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
',true,'ACTIVE');


delete from query_master where code = 'get_rch_register_eligible_couple_detailed_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_eligible_couple_detailed_info','preg_reg_id','
with preg_member as (
    select * from rch_pregnancy_registration_det where id = #preg_reg_id#
)
,basic_member_info as (
    select preg.member_id, to_char(date_of_delivery,''dd-MM-yyyy'') as date_of_delivery, mem.unique_health_id, to_char(preg.lmp_date,''dd-MM-yyyy'') as lmp_date, to_char(preg.reg_service_date,''dd-MM-yyyy'') as reg_service_date, del_week as pregnancy_week_number, preg.member_name,
    case when TRUNC(DATE_PART(''day'', cast(preg.date_of_delivery as timestamp)  - cast(preg.lmp_date as timestamp ))/7) > 11 then ''Yes'' else ''No'' end as twelve_pregnancy_week_number,
    mem.middle_name as husband_name, preg.edd, preg.age_during_delivery as age_during_delivery, mem.dob, preg.expected_delivery_place, mem.weight, 
    mem.blood_group, 
    concat(fam.address1, '','', fam.address2) as address, mem.mobile_number, rel.value as religion, cas.value as cast, fam.bpl_flag 
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
		select to_char(service_date,''dd-MM-yyyy'') as inspection_date,
		ins_place.value as inspection_place,  
		TRUNC(DATE_PART(''day'', cast(anc.service_date as timestamp) - cast(anc.lmp as timestamp))/7) as pregnancy_week,
		anc.weight as preg_women_weight,
		systolic_bp as systolic_bp, 
		diastolic_bp  as diastolic_bp, 
		haemoglobin_count as haemoglobin_count,
		fa_tablets_given as falic_acid_tablets,
		ifa_tablets_given as ifa_tablet,
		urine_test_done, urine_albumin, urine_sugar,
		sugar_test_before_food_val, sugar_test_after_food_val,
		immun.immunisation_given,
		foetal_height, 
		foetal_heart_sound, foetal_position, foetal_movement,
		referral_done, 
		family_planning_method, 
		dead_flag, death_reason  
		from rch_anc_master anc
		left join rch_immunisation_master immun on anc.id = immun.visit_id
		left join listvalue_field_value_detail ins_place on anc.anc_place = ins_place.id 
		where anc.pregnancy_reg_det_id = #preg_reg_id#
		order by service_date
	) t
), delivery_result as(
	select cast( json_agg(t) as text) as delivery_result_json from 
	(select 
	child.member_id, to_char(mother.date_of_delivery,''dd-MM-yyyy HH:mm:ss'') as date_of_delivery, delivery_place, delivery_person_name, mother.type_of_delivery,to_char( discharge_date,''dd-MM-yyyy HH:mm:ss'') as discharge_date,  
	case when child.pregnancy_outcome = ''LBIRTH'' then ''Alive'' 
		when child.pregnancy_outcome = ''SBIRTH'' then ''Dead''
		else ''N/A'' end as is_alive_dead,
	was_premature, gender, baby_cried_at_birth, birth_weight, child.breast_feeding_in_one_hour ,
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
	child.pregnancy_outcome, immunisation_given,immun.given_on, child.member_id)t
)
,pnc_visit as (
	select cast( json_agg(t) as text) as pnc_visit_json from ( 
	select
	to_char(mas.service_date,''dd-MM-yyyy'') as service_date,
	mother_pnc.ifa_tablets_given, mother_pnc.other_danger_sign, mother_pnc.referral_place, mother_pnc.family_planning_method, mother_pnc.is_alive, 
	mother_pnc.death_reason,to_char(mother_pnc.death_date,''dd-MM-yyyy'') as death_date, mother_pnc.place_of_death, concat(''['',string_agg(cast(row_to_json(child_pnc.*) as text), '',''),'']'') as child_pnc_dto
	from rch_pnc_master mas
	left join rch_pnc_mother_master mother_pnc on mas.id = mother_pnc.pnc_master_id 
	left join rch_pnc_child_master child_pnc on mas.id = child_pnc.pnc_master_id 
	where mas.pregnancy_reg_det_id  =  #preg_reg_id#
	group by mas.id,mother_pnc.ifa_tablets_given, mother_pnc.other_danger_sign, mother_pnc.referral_place, mother_pnc.family_planning_method, mother_pnc.is_alive, 
	mother_pnc.death_reason, mother_pnc.death_date, mother_pnc.place_of_death
	order by mas.service_date
 )t
)
select * from basic_member_info,previous_pregnancy_details,pre_delivery_care,delivery_result,pnc_visit
',true,'ACTIVE');



