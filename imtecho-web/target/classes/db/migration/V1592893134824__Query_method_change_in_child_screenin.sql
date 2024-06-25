
DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_family_id_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6e3f411a-2f58-440b-8623-611479a48ed1', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_family_id_search', 
'familyId,offSet,limit', 
'select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
where imt_member.family_id = #familyId#
and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
group by
imt_member.id,
imt_member.first_name,
imt_member.middle_name,
imt_member.last_name,dob
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_follow_up_unique_health_id_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6bda3369-1bd8-434a-bb81-f34d3dc12cbe', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_follow_up_unique_health_id_search', 
'offSet,limit,uniqueHealthId', 
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
where imt_member.unique_health_id = #uniqueHealthId#
and csd.state = ''DISCHARGE'' and csd.is_case_completed is null
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_follow_up_name_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9f367260-9b93-4f93-be6d-58ab74131ffa', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_follow_up_name_search', 
'firstName,lastName,offSet,limit', 
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
where imt_member.first_name ilike concat(''%'',#firstName#,''%'') and imt_member.last_name ilike concat(''%'',#lastName#,''%'')
and csd.state = ''DISCHARGE'' and csd.is_case_completed is null
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_follow_up_mobile_number_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd4bd4de9-1241-4c5b-826b-7b2e1353ac13', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_follow_up_mobile_number_search', 
'offSet,mobileNumber,limit', 
'select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
csd.admission_id as "admissionId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy"
from imt_member
inner join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join child_cmtc_nrc_screening_detail csd on imt_member.id = csd.child_id 
where m2.mobile_number = #mobileNumber#
and csd.state = ''DISCHARGE'' and csd.is_case_completed is null
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_unique_health_id_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'87ab3cdb-3664-4daa-833f-8dc6b4480b55', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_unique_health_id_search', 
'offSet,limit,uniqueHealthId', 
'select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
where imt_member.unique_health_id = #uniqueHealthId#
and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
group by
imt_member.id,
imt_member.first_name,
imt_member.middle_name,
imt_member.last_name,dob
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_mobile_number_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'442b1295-a65c-4954-a36f-200bf6a8215c', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_mobile_number_search', 
'offSet,mobileNumber,limit', 
'with ids as(
	select imt_member.id,string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
	inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
	inner join imt_member m2 on imt_member.mother_id = m2.id
	where m2.mobile_number = #mobileNumber#
	and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
	group by
	imt_member.id
	limit #limit# offset #offSet#
)select imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
ids."locationHierarchy"
from ids inner join imt_member on imt_member.id = ids.id', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='cmtc_nrc_name_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4c92a0eb-d13d-42a3-96e1-0d400e0f0519', 75398,  current_date , 75398,  current_date , 'cmtc_nrc_name_search', 
'firstName,lastName,offSet,locationId,limit', 
'with members as (
	select
	imt_member.id,
	imt_member.first_name,
	imt_member.middle_name,
	imt_member.last_name,
	imt_member.dob as dob,
	imt_family.location_id
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
	and location_hierchy_closer_det.parent_id = #locationId#
	where imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
	and imt_member.dob between (current_date - interval ''60 months'') and (current_date)
	and imt_member.first_name ilike concat(''%'',#firstName#,''%'') and imt_member.last_name ilike concat(''%'',#lastName#,''%'')
	limit #limit# offset #offSet#
)
select members.id,members.first_name as "firstName",members.middle_name as "middleName",members.last_name as "lastName",
string_agg(l.name,''>'' order by lhcd.depth desc) as "locationHierarchy"
from members inner join location_master dl on  members.location_id = dl.id
inner join location_hierchy_closer_det lhcd on lhcd.child_id = dl.id
inner join location_master l on l.id = lhcd.parent_id
group by dl.id, members.id, members.first_name,members.middle_name,members.last_name,members.dob,members.location_id', 
null, 
true, 'ACTIVE');

