update query_master set modified_on = now(), query = '
with const as (
	select cast(''M'' as text) as const, cast(''Male'' as text) as name
	union
	select cast(''F'' as text) as const, cast(''Female'' as text) as name
	union
	select cast(''T'' as text) as const, cast(''Transgender'' as text) as name
	union
	select cast(''LBIRTH'' as text) as const, cast(''Live Birth'' as text) as name
	union
	select cast(''SBIRTH'' as text) as const, cast(''Still Birth'' as text) as name
	union
	select cast(''YES'' as text) as const, cast(''Yes'' as text) as name
	union
	select cast(''NO'' as text) as const, cast(''No'' as text) as name
	union
	select cast(''NOT_REQUIRED'' as text) as const, cast(''Not Required'' as text) as name
), wpd_child_id as (
	select id from rch_wpd_child_master where wpd_mother_id = #visitId#
), cong_def as (
	select rel.wpd_id, string_agg(det.value ,'', '') as cong_def
	from rch_wpd_child_congential_deformity_rel rel
	inner join listvalue_field_value_detail det on rel.congential_deformity = det.id
	where rel.wpd_id in (select * from wpd_child_id) group by rel.wpd_id
), immu as (
	select imm.visit_id, string_agg(concat(
		case when scm.constant is null then imm.immunisation_given else scm.value end,
		'' - '',
		to_char(imm.given_on, ''dd/MM/yyyy'')), chr(10))
	as immu_given
	from rch_immunisation_master imm
	left join system_constant_master scm on scm.constant = imm.immunisation_given
	where visit_id in (select * from wpd_child_id)
	and visit_type = ''FHW_WPD''
	group by visit_id
)
select
concat(mem.first_name, '' '', mem.middle_name, '' '', mem.last_name, '' ('', mem.unique_health_id, '')'') as "Member Name",
outcome.name as "Pregnancy Outcome",
case when gender.name is not null then gender.name else child.gender end as "Infant Gender",
case when child.birth_weight is not null then concat(child.birth_weight, '' Kgs'') else null end as "Birth Weight",
case when child.baby_cried_at_birth = true then ''Yes'' when child.baby_cried_at_birth = false then ''No'' else null end as "Infant Cried At Birth",
case when mother.breast_feeding_in_one_hour = true then ''Yes'' when mother.breast_feeding_in_one_hour = false then ''No'' else null end as "Infant Breastfeeding started in 1 hour of birth",
child.other_congential_deformity as "Other Congential Deformity",
case when child.is_high_risk_case = true then ''Yes'' when child.is_high_risk_case = false then ''No'' else null end as "Is High Risk Case",
immu.immu_given as "Immunisations Given",
referral_done.name as "Referral done"
from rch_wpd_child_master child
inner join rch_wpd_mother_master mother on child.wpd_mother_id = mother.id and mother.id = #visitId#
inner join imt_member mem on child.member_id = mem.id
left join cong_def on cong_def.wpd_id = child.id
left join immu on immu.visit_id = child.id
left join const outcome on outcome.const = child.pregnancy_outcome
left join const gender on gender.const = child.gender
left join const referral_done on referral_done.const = child.referral_done
'
where code = 'mob_work_register_detail_wpd_child'