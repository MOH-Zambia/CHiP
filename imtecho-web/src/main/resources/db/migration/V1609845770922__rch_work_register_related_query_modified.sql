-- rch work register related query modified



DELETE FROM QUERY_MASTER WHERE CODE='mob_asha_work_register_detail_cs';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3c714c51-a228-49b4-a82b-06d5fcac3864', 58981,  current_date , 58981,  current_date , 'mob_asha_work_register_detail_cs',
'visitId',
'with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''MAMTA_DAY'' as text) as const, cast(''Mamta Day'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''SWLY'' as text) as const, cast(''Slowly'' as text) as name
	union
	select cast(''VSWLY'' as text) as const, cast(''Very slowly'' as text) as name
	union
	select cast(''NRMLY'' as text) as const, cast(''Normally'' as text) as name
	union
	select cast(''NABTDR'' as text) as const, cast(''Not able to drink'' as text) as name
	union
	select cast(''DRNKP'' as text) as const, cast(''Drinks poorly'' as text) as name
	union
	select cast(''DRNKE'' as text) as const, cast(''Drinks eagerly'' as text) as name
	union
	select cast(''THRSTY'' as text) as const, cast(''Thirsty'' as text) as name
	union
	select cast(''SEVR'' as text) as const, cast(''Severe'' as text) as name
	union
	select cast(''SMMLD'' as text) as const, cast(''Some/Mild'' as text) as name
	union
	select cast(''NONE'' as text) as const, cast(''None'' as text) as name
)
select
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
mem.family_id as "Family Id",
case when csm.service_date is not null then to_char(csm.service_date, ''DD/MM/YYYY'') else null end as "Service Date",
case when csm.death_date is not null then to_char(csm.death_date, ''DD/MM/YYYY'') else null end as "Death Date",
place_of_death.name as "Place Of Death",
death_reason.value as "Death Reason",
csm.other_death_reason as "Other Death Reason",
case when csm.unable_to_drink_breastfeed = true then ''Yes'' when csm.unable_to_drink_breastfeed = false then ''No'' else null end as "Unable to drink breastfeed",
case when csm.vomit_everything = true then ''Yes'' when csm.vomit_everything = false then ''No'' else null end as "Vomit everything",
case when csm.have_convulsions = true then ''Yes'' when csm.have_convulsions = false then ''No'' else null end as "Have convulsions",
case when csm.have_cough_or_fast_breathing = true then ''Yes'' when csm.have_cough_or_fast_breathing = false then ''No'' else null end as "Have cough or fast breathing",
case when csm.cough_days is not null then cast(csm.cough_days as text) else null end as "Cough days",
case when csm.breath_in_one_minute is not null then cast(csm.breath_in_one_minute as text) else null end as "Breath in one minute",
case when csm.have_chest_indrawing = true then ''Yes'' when csm.have_chest_indrawing = false then ''No'' else null end as "Have chest indrawing",
case when csm.have_more_stools_diarrhea = true then ''Yes'' when csm.have_more_stools_diarrhea = false then ''No'' else null end as "Have more stools or diarrhea",
case when csm.diarrhea_days is not null then cast(csm.diarrhea_days as text) else null end as "Diarrhea days",
case when csm.blood_in_stools = true then ''Yes'' when csm.blood_in_stools = false then ''No'' else null end as "Blood in stools",
case when csm.sunken_eyes = true then ''Yes'' when csm.sunken_eyes = false then ''No'' else null end as "Sunken eyes",
case when csm.irritable_or_restless = true then ''Yes'' when csm.irritable_or_restless = false then ''No'' else null end as "Irritable or restless",
case when csm.lethargic_or_unconsious = true then ''Yes'' when csm.lethargic_or_unconsious = false then ''No'' else null end as "Lethargic or unconsious",
skin_behaviour_after_pinching.name as "Skin behaviour after pinching",
drinking_behaviour.name as "Drinking behaviour",
case when csm.have_fever = true then ''Yes'' when csm.have_fever = false then ''No'' else null end as "Have fever",
case when csm.fever_days is not null then cast(csm.fever_days as text) else null end as "Fever days",
case when csm.fever_present_each_day = true then ''Yes'' when csm.fever_present_each_day = false then ''No'' else null end as "Fever present each day",
case when csm.is_neck_stiff = true then ''Yes'' when csm.is_neck_stiff = false then ''No'' else null end as "Is neck stiff",
case when csm.have_fever_on_service = true then ''Yes'' when csm.have_fever_on_service = false then ''No'' else null end as "Have fever on service",
have_palmer_poller.name as "Have palmer poller",
case when csm.have_severe_wasting = true then ''Yes'' when csm.have_severe_wasting = false then ''No'' else null end as "Have severe wasting",
case when csm.have_edema_both_feet = true then ''Yes'' when csm.have_edema_both_feet = false then ''No'' else null end as "Have edema both feet",
case when csm.weight is not null then concat(cast(csm.weight as text), '' Kgs'') else null end as "Weight",
case when csm.date_of_weight is not null then to_char(csm.date_of_weight, ''DD/MM/YYYY'') else null end as "Weight Date",
case when csm.mother_informed_about_grade = true then ''Yes'' when csm.mother_informed_about_grade = false then ''No'' else null end as "Mother informed about malnutrition grade"
from rch_asha_child_service_master csm
inner join imt_member mem on csm.member_id = mem.id
left join listvalue_field_value_detail death_reason on cast(csm.death_reason as bigint) = death_reason.id
left join const place_of_death on place_of_death.const = csm.death_place
left join const skin_behaviour_after_pinching on skin_behaviour_after_pinching.const = csm.skin_behaviour_after_pinching
left join const drinking_behaviour on drinking_behaviour.const = csm.drinking_behaviour
left join const have_palmer_poller on have_palmer_poller.const = csm.have_palmer_poller
where csm.id = #visitId#',
null,
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='mob_asha_work_register_detail_pnc_child';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd35ad954-0dab-4288-904e-7bea88f211f7', 58981,  current_date , 58981,  current_date , 'mob_asha_work_register_detail_pnc_child',
'visitId',
'with const as (
	select cast(''HOME'' as text) as const, cast(''Home'' as text) as name
	union
	select cast(''ON_THE_WAY'' as text) as const, cast(''On the way'' as text) as name
	union
	select cast(''HOSP'' as text) as const, cast(''Hospital'' as text) as name
	union
	select cast(''OK'' as text) as const, cast(''Ok'' as text) as name
	union
	select cast(''WEAK'' as text) as const, cast(''Weak'' as text) as name
	union
	select cast(''STOP'' as text) as const, cast(''Stop'' as text) as name
	union
	select cast(''NRML'' as text) as const, cast(''Normal'' as text) as name
	union
	select cast(''LTUSL'' as text) as const, cast(''Less than usual'' as text) as name
	union
	select cast(''NSUCK'' as text) as const, cast(''No suckling'' as text) as name
	union
	select cast(''FRCFL'' as text) as const, cast(''Forceful'' as text) as name
	union
	select cast(''YLLW'' as text) as const, cast(''Yellow'' as text) as name
	union
	select cast(''PUS'' as text) as const, cast(''Pus'' as text) as name
	union
	select cast(''BLDNG'' as text) as const, cast(''Bleeding'' as text) as name
	union
	select cast(''NONE'' as text) as const, cast(''No pus'' as text) as name
	union
	select cast(''DSTND'' as text) as const, cast(''Distended'' as text) as name
	union
	select cast(''LIMP'' as text) as const, cast(''Limp'' as text) as name
	union
	select cast(''CNE'' as text) as const, cast(''Could not examine'' as text) as name
	union
	select cast(''PUSP'' as text) as const, cast(''Pus Present'' as text) as name
	union
	select cast(''SWLN'' as text) as const, cast(''Swollen'' as text) as name
)
select
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
case when pcm.death_date is not null then to_char(pcm.death_date, ''DD/MM/YYYY'') else null end as "Death Date",
death_reason.value as "Death Reason",
place_of_death.name as "Place Of Death",
pcm.other_death_reason as "Other Death Reason",
cry.name as "Baby''s cry",
fed_less_than_usual.name as "Fed less than usual",
sucking.name as "Sucking",
case when pcm.throws_milk = true then ''Yes'' when pcm.throws_milk = false then ''No'' else null end as "Throws milk",
case when pcm.hands_feets_cold = true then ''Yes'' when pcm.hands_feets_cold = false then ''No'' else null end as "Hands and feets are cold",
skin.name as "Skin",
case when pcm.skin_pustules = true then ''Yes'' when pcm.skin_pustules = false then ''No'' else null end as "Skin Pustules",
case when pcm.have_chest_indrawing = true then ''Yes'' when pcm.have_chest_indrawing = false then ''No'' else null end as "Have chest indrawing",
umbilicus.name as "Umbilicus",
abdomen.name as "Abdomen",
case when pcm.tempreature is not null then concat(cast(pcm.tempreature as text), '' '', chr(176), ''F'') else null end as "Temperature",
limbs_neck.name as "Limbs and neck",
eyes.name as "Eyes",
case when pcm.weight is not null then concat(cast(pcm.weight as text), '' Kgs'') else null end as "Weight"
from rch_asha_pnc_child_master pcm
inner join imt_member mem on pcm.child_id = mem.id
left join listvalue_field_value_detail death_reason on cast(pcm.death_reason as bigint) = death_reason.id
left join const place_of_death on place_of_death.const = pcm.death_place
left join const cry on cry.const = pcm.cry
left join const fed_less_than_usual on fed_less_than_usual.const = pcm.fed_less_than_usual
left join const skin on skin.const = pcm.skin
left join const sucking on sucking.const = pcm.sucking
left join const umbilicus on umbilicus.const = pcm.umbilicus
left join const abdomen on abdomen.const = pcm.abdomen
left join const limbs_neck on limbs_neck.const = pcm.limbs_neck
left join const eyes on eyes.const = pcm.eyes
where pnc_master_id = #visitId#',
null,
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='mob_work_register_detail_cs';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd3d2865a-b87d-4af7-9f2f-099830e64d60', 1,  current_date , 1,  current_date , 'mob_work_register_detail_cs',
'visitId',
'
--mob_work_register_detail_cs
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
	where rel.child_service_id = #visitId#
	group by rel.child_service_id
), immu as (
	select imm.visit_id,
	string_agg(
		concat(
			case when scm.constant is null then imm.immunisation_given else scm.value end,
			'' - '',
			to_char(imm.given_on, ''dd/MM/yyyy'')
		), chr(10) order by imm.given_on
	) as immu_given
	from rch_immunisation_master imm
	left join system_constant_master scm on scm.constant = imm.immunisation_given
	where imm.visit_id = #visitId#
	and imm.visit_type = ''FHW_CS''
	group by imm.visit_id
)
select
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Child Name",
mem.family_id as "Family Id",
case when csm.service_date is not null then to_char(csm.service_date, ''DD/MM/YYYY'') else null end as "Service Date",
case when csm.height is not null then cast(csm.height as text) else null end as "Height",
case when csm.weight is not null then concat(cast(csm.weight as text), '' Kgs'') else null end as "Weight",
case when csm.ifa_syrup_given = true then ''Yes'' when csm.ifa_syrup_given = false then ''No'' else null end as "Ifa Syrup Given",
case when csm.complementary_feeding_started = true then ''Yes'' when csm.complementary_feeding_started = false then ''No'' else null end as "Complementary Feeding Started",
comp_feeding_start_period.name as "Complementary Feeding Start Period",
case when csm.exclusively_breastfeded = true then ''Yes'' when csm.exclusively_breastfeded = false then ''No'' else null end as "Exclusively Breastfeded",
case when csm.mid_arm_circumference is not null then cast(csm.mid_arm_circumference as text) else null end as "Mid Upper Arm Circumference",
case when csm.have_pedal_edema = true then ''Yes'' when csm.have_pedal_edema = false then ''No'' else null end as "Have Pedal Edema",
diseases.diseases as "Diseases",
csm.other_diseases as "Other Diseases",
immu.immu_given as "Immunisation Provided",
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
left join immu on csm.id = immu.visit_id
where csm.id = #visitId#
',
null,
true, 'ACTIVE');
