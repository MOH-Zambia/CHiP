DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_abha_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'22cb333f-d254-4ac0-a963-2777cf02df5b', 97632,  current_date , 97632,  current_date , 'sickle_cell_search_by_abha_number',
'offSet,limit,abhaNumber',
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_member.mobile_number as "mobileNumber",
concat(imt_family.address1,'', '',imt_family.address2) as "address",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age",
extract(year from age(imt_member.dob)) as "ageInYears"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where health_id_number in (#abhaNumber#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#',
'Sickle Cell search using abha number',
true, 'ACTIVE');