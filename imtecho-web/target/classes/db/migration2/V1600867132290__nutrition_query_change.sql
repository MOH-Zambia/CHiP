delete from QUERY_MASTER where CODE='cmtc_nrc_follow_up_family_id_search';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'd2243cf3-bb3a-4d7a-a06e-3a189593b098', 60512,  current_date , 60512,  current_date , 'cmtc_nrc_follow_up_family_id_search',
'familyId,offSet,limit',
'select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
csd.admission_id as "admissionId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join child_cmtc_nrc_screening_detail csd on imt_member.id = csd.child_id
where imt_member.family_id = #familyId#
and csd.state = ''DISCHARGE'' and csd.is_case_completed is null
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='cmtc_nrc_follow_up_name_search';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'9f367260-9b93-4f93-be6d-58ab74131ffa', 60512,  current_date , 60512,  current_date , 'cmtc_nrc_follow_up_name_search',
'firstName,lastName,offSet,locationId,limit',
'select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
csd.admission_id as "admissionId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
and location_hierchy_closer_det.parent_id = #locationId#
inner join child_cmtc_nrc_screening_detail csd on imt_member.id = csd.child_id
where imt_member.first_name ilike concat(''%'',#firstName#,''%'') and imt_member.last_name ilike concat(''%'',#lastName#,''%'')
and csd.state = ''DISCHARGE'' and csd.is_case_completed is null
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');