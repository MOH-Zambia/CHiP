DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_abha_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'98880fa8-f215-452a-b02f-bddac727dec7', 97632,  current_date , 97632,  current_date , 'child_service_retrieve_child_list_by_abha_number',
'offSet,limit,abhaNumber',
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id
where imt_member.dob > now()-interval ''5 years''
and imt_member.health_id_number = #abhaNumber#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#',
'To fetch child service details by abha number',
true, 'ACTIVE');