DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_abha_address';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1a934fd7-6ee8-421b-a079-f5fe3f49923e', 97632,  current_date , 97632,  current_date , 'child_service_retrieve_child_list_by_abha_address',
'offSet,limit,abhaAddress',
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id
where imt_member.dob > now()-interval ''5 years''
and imt_member.health_id = #abhaAddress#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#',
'Child Service details by Abha Address',
true, 'ACTIVE');