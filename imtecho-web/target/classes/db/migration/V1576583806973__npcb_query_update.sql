update query_master
set query = '
select
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.dob as "dob",
imt_family.bpl_flag as "bplFlag",
case
	when imt_member.gender = ''M'' then ''Male''
	when imt_member.gender = ''F'' then ''Female''
	when imt_member.gender = ''T'' then ''Transgender''
	else imt_member.gender
end as gender,
(select value from listvalue_field_value_detail where cast(id as varchar) = imt_family.caste) as "caste",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
case
	when nmdd.disease_code = ''D'' then ''Yes''
	else ''No''
end as hasDiabetes,
case
	when nmdd.disease_code = ''HT'' then ''Yes''
	else ''No''
end as hasHypertension,
npcb_member_screening_master.*
from npcb_member_screening_master
inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
left join ncd_member_diseases_diagnosis nmdd on npcb_member_screening_master.member_id = nmdd.member_id
and (nmdd.status = ''REFERRED'' or nmdd.status = ''CONFIRMED'')
where npcb_member_screening_master.id = #id#
 'where code = 'npcb_screened_details_retrieve';
