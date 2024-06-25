DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_abha_address';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'83ae2895-1409-4a1b-af9e-31b8be29862d', 97632,  current_date , 97632,  current_date , 'opd_search_by_abha_address',
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
null,
true, 'ACTIVE');