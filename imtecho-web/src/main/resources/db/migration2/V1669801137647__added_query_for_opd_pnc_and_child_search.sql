DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_abha_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e0c2297c-76c2-4320-9f93-ef933b9bfc70', 97070,  current_date , 97070,  current_date , 'opd_search_by_abha_number',
'offSet,limit,abhaNumber',
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.area_id as "areaId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.health_id_number in (#abhaNumber#)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#',
'OPD Search By Abha Number',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_abha_address';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'453f6d81-97ba-4b9e-9ed9-0ecc52ac9313', 97070,  current_date , 97070,  current_date , 'opd_search_by_abha_address',
'offSet,limit,abhaAddress',
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.area_id as "areaId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.health_id in (#abhaAddress#)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#',
'OPD Search By Abha Address',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_abha_address';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd34689b7-f303-4a5f-b5d5-fbe22b596c3d', 97070,  current_date , 97070,  current_date , 'pnc_retrieve_mother_list_by_abha_address',
'abhaAddres,offSet,limit',
'select * from imt_member where id in
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where health_id in (#abhaAddres#)))
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#',
'PNC Search By Abha Address',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_abha_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'403b8188-0c57-4635-8f67-b8dcdebbc9b6', 97070,  current_date , 97070,  current_date , 'pnc_retrieve_mother_list_by_abha_number',
'offSet,limit,abhaNumber',
'select * from imt_member where id in
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where health_id_number in (#abhaNumber#)))
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#',
'PNC Search By Abha Number',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_abha_address';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a3efb0ff-46cf-4b83-b751-70800b8a27f8', 97070,  current_date , 97070,  current_date , 'child_service_retrieve_child_list_by_abha_address',
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
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_abha_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1c0bdc51-9834-4c43-a1b7-216428832645', 97070,  current_date , 97070,  current_date , 'child_service_retrieve_child_list_by_abha_number',
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
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_dob';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fb372992-ea27-4c1b-8a0b-f703ad272129', 97070,  current_date , 97070,  current_date , 'child_service_retrieve_child_list_by_dob',
'offSet,dob,locationId,limit',
'with member_details as
(select member_id from analytics.rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years''
and rch_child_analytics_details.dob = #dob#
and rch_child_analytics_details.loc_id in
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join member_details on member_details.member_id = imt_member.id
where ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'01dc8d5c-1ef3-4060-873a-9ccea72884f1', 97070,  current_date , 97070,  current_date , 'child_service_retrieve_child_list_by_name',
'offSet,locationId,name,limit',
'with member_details as
(select member_id from analytics.rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years''
and similarity(#name#,rch_child_analytics_details.member_name)>=0.50
and rch_child_analytics_details.loc_id in
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join member_details on member_details.member_id = imt_member.id
where ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_location_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'815da090-7958-4178-9776-074f5801cc43', 97070,  current_date , 97070,  current_date , 'child_service_retrieve_child_list_by_location_id',
'offSet,locationId,limit',
'with member_details as
(select member_id from analytics.rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years''
and rch_child_analytics_details.loc_id in
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join member_details on member_details.member_id = imt_member.id
where ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))',
null,
true, 'ACTIVE');