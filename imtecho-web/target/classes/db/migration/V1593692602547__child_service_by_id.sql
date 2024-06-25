DELETE FROM QUERY_MASTER WHERE CODE='child_service_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'05eef71a-abae-4f46-a5a8-8564a50391af', 60512,  current_date , 60512,  current_date , 'child_service_by_id',
'childId',
'select child.id as "memberId",
child.unique_health_id as "uniqueHealthId",
concat(child.first_name,'' '',child.middle_name,'' '',child.last_name) as "memberName",
imt_family.id as "familyId",
child.family_id as "familyUniqueId",
get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end as "locationId",
imt_family.area_id as "areaId",
case when child.immunisation_given is not null then child.immunisation_given else '''' end as "immunisationGiven",
child.dob as "dob",
child.additional_info as "additionalInfo",
child.gender as "gender",
listvalue_field_value_detail.value as "caste",
mother.mobile_number as "motherMobileNumber"
from imt_member child
left join imt_member mother on child.mother_id = mother.id
inner join imt_family on child.family_id = imt_family.family_id
left join listvalue_field_value_detail on cast(imt_family.caste as integer) = listvalue_field_value_detail.id
where child.id = #childId#',
null,
true, 'ACTIVE');