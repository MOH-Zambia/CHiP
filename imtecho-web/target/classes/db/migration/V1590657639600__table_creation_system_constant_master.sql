
drop table if exists system_constant_master;

create table system_constant_master(
	constant character varying(30) primary key,
	value text,
	group_name character varying(30)
);

insert into system_constant_master (constant, value, group_name)
select 'HEPATITIS_B_0', 'Hepatitis B 0', 'VACCINE'
union
select 'BCG', 'BCG', 'VACCINE'
union
select 'OPV_0', 'OPV 0', 'VACCINE'
union
select 'OPV_1', 'OPV 1', 'VACCINE'
union
select 'OPV_2', 'OPV 2', 'VACCINE'
union
select 'OPV_3', 'OPV 3', 'VACCINE'
union
select 'OPV_BOOSTER', 'OPV Booster', 'VACCINE'
union
select 'PENTA_1', 'Penta 1', 'VACCINE'
union
select 'PENTA_2', 'Penta 2', 'VACCINE'
union
select 'PENTA_3', 'Penta 3', 'VACCINE'
union
select 'DPT_1', 'DPT 1', 'VACCINE'
union
select 'DPT_2', 'DPT 2', 'VACCINE'
union
select 'DPT_3', 'DPT 3', 'VACCINE'
union
select 'DPT_BOOSTER', 'DPT Booster', 'VACCINE'
union
select 'MEASLES_1', 'Measles 1', 'VACCINE'
union
select 'MEASLES_2', 'Measles 2', 'VACCINE'
union
select 'F_IPV_1_01', 'F IPV 1 01', 'VACCINE'
union
select 'F_IPV_2_01', 'F IPV 2 01', 'VACCINE'
union
select 'F_IPV_2_05', 'F IPV 2 05', 'VACCINE'
union
select 'VITAMIN_A', 'Vitamin A', 'VACCINE'
union
select 'VITAMIN_K', 'Vitamin K', 'VACCINE'
union
select 'ROTA_VIRUS_1', 'Rota Virus 1', 'VACCINE'
union
select 'ROTA_VIRUS_2', 'Rota Virus 2', 'VACCINE'
union
select 'ROTA_VIRUS_3', 'Rota Virus 3', 'VACCINE'
union
select 'MEASLES_RUBELLA_1', 'Measles Rubella 1', 'VACCINE'
union
select 'MEASLES_RUBELLA_2', 'Measles Rubella 2', 'VACCINE'
union
select 'TT1', 'TT 1', 'VACCINE'
union
select 'TT2', 'TT 2', 'VACCINE'
union
select 'TT_BOOSTER', 'TT Booster', 'VACCINE';


update query_master set query = '
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
case when csm.weight is not null then cast(csm.weight as text) else null end as "Weight",
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
'
where code = 'mob_work_register_detail_cs';
