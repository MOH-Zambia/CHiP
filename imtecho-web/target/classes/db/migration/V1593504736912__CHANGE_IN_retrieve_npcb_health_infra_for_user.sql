DELETE FROM QUERY_MASTER WHERE CODE='retrieve_npcb_health_infra_for_user';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'129d4092-dd3b-46a5-985d-a30062fdb931', 75398,  current_date , 75398,  current_date , 'retrieve_npcb_health_infra_for_user', 
'userId', 
'select  h.name , h.id,h.type as type from health_infrastructure_details h, user_health_infrastructure  u where u.health_infrastrucutre_id=h.id and user_id=#userId# and is_npcb and u.state=''ACTIVE''', 
'Retrieve NPCB Health Infrastructure for the user id', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='npcb_mark_as_spectacles_given';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4855a380-d4cc-46b0-8aa2-d66292b2349e', 75398,  current_date , 75398,  current_date , 'npcb_mark_as_spectacles_given', 
'id,spectaclesGivenDate,memberId', 
'update npcb_member_examination_detail
set spectacles_given_date =  to_date(#spectaclesGivenDate#,''YYYY-MM-DD'')
where id = #id#;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),''{npcbStatus}'',''"SPECTACLES_GIVEN"'',true)
else ''{"npcbStatus":"SPECTACLES_GIVEN"}'' end
where id = #memberId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='installed_app_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7d6e6ecc-2df5-4f57-9bd6-7c0610a5e43a', 75398,  current_date , 75398,  current_date , 'installed_app_info', 
'user_name,imei', 
'select appinfo.user_id, usr.user_name as username,
appinfo.imei,
appinfo.package_name,
appinfo.application_name,
appinfo.installed_date
from user_installed_apps appinfo
inner join um_user usr on appinfo.user_id = usr.id 
	and usr.user_name = #user_name# 
	and case when #imei# is null then true else appinfo.imei = #imei# end
order by imei, application_name', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='block_imei_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'05a148cb-ab0a-4642-afdf-b07dfb12f7a0', 75398,  current_date , 75398,  current_date , 'block_imei_number', 
'imei,userid', 
'INSERT INTO blocked_devices_master (imei, created_by, created_on,is_block_device)
VALUES (#imei#, #userid#, localtimestamp,true)
ON CONFLICT (imei) DO UPDATE
  SET is_block_device = true', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='unblock_imei_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a1a83233-e9dc-4d94-a600-a34e617b5f1d', 75398,  current_date , 75398,  current_date , 'unblock_imei_number', 
'imei', 
'delete from blocked_devices_master where imei = #imei#', 
'Unblock the Imei Number', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='delete_imei_database';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'158bc0bf-b55a-467b-90c3-045e4b6aa391', 75398,  current_date , 75398,  current_date , 'delete_imei_database', 
'imei,userid', 
'INSERT INTO blocked_devices_master (imei, created_by, created_on,is_delete_database)
VALUES (#imei#, #userid#, localtimestamp,true)
ON CONFLICT (imei) DO UPDATE
  SET is_delete_database = true', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='school_retrieval_by_code';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b63d2e3b-266c-42c3-ba4b-cf09fb96caa0', 75398,  current_date , 75398,  current_date , 'school_retrieval_by_code', 
'code,id', 
'SELECT
    id,
    name,
    english_name as "englishName",
    code,
	location_id as "locationId",
	get_location_hierarchy(location_id) as "locationHierarchy"
    FROM school_master
    WHERE
    code = #code#
    and id != #id#;', 
'Retrieve School By Code', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='school_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'685089f3-417e-4c68-84ae-989588c803fd', 75398,  current_date , 75398,  current_date , 'school_update', 
'isPrimarySchool,englishName,code,childFemale9To10,schoolType,isGurukul,childFemale6To8,childMale6To8,locationId,contactNumber,childFemale11To12,modifiedBy,id,rbskTeamId,isHigherSecondarySchool,otherSchoolType,isPrePrimarySchool,noOfTeachers,principalName,childFemale1To5,childMale11To12,isMadresa,contactPersonName,childMale1To5,name,grantType,isOther,childMale9To10', 
'UPDATE school_master
    SET
    "name"=#name#, code=#code#, english_name=#englishName#, grant_type=#grantType#, school_type=#schoolType#, no_of_teachers=#noOfTeachers#, principal_name=#principalName#, contact_person_name=#contactPersonName#, is_pre_primary_school=#isPrePrimarySchool#, is_primary_school=#isPrimarySchool#, is_higher_secondary_school=#isHigherSecondarySchool#, is_madresa=#isMadresa#, is_gurukul=#isGurukul#, is_other=#isOther#, other_school_type=#otherSchoolType#, contact_number=#contactNumber#,
    child_male_1_to_5=#childMale1To5#, child_female_1_to_5=#childFemale1To5#, child_male_6_to_8=#childMale6To8#, child_female_6_to_8=#childFemale6To8#, child_male_9_to_10=#childMale9To10#, child_female_9_to_10=#childFemale9To10#, child_male_11_to_12=#childMale11To12#, child_female_11_to_12=#childFemale11To12#,
    rbsk_team_id=#rbskTeamId#, location_id=#locationId#, modified_by=#modifiedBy#, modified_on=now()
    WHERE id=#id#;', 
'Update School', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='school_create';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c2a20050-2738-465f-a0e1-39081d97c107', 75398,  current_date , 75398,  current_date , 'school_create', 
'isPrimarySchool,englishName,code,childFemale9To10,schoolType,isGurukul,childFemale6To8,childMale6To8,locationId,contactNumber,childFemale11To12,modifiedBy,rbskTeamId,isHigherSecondarySchool,otherSchoolType,isPrePrimarySchool,noOfTeachers,principalName,childFemale1To5,childMale11To12,isMadresa,contactPersonName,createdBy,childMale1To5,name,grantType,isOther,childMale9To10', 
'INSERT INTO school_master(
    "name", code, english_name, grant_type, school_type, no_of_teachers, principal_name, contact_person_name, is_pre_primary_school, is_primary_school, is_higher_secondary_school, is_madresa, is_gurukul, is_other, other_school_type, contact_number,
    child_male_1_to_5, child_female_1_to_5, child_male_6_to_8, child_female_6_to_8, child_male_9_to_10, child_female_9_to_10, child_male_11_to_12, child_female_11_to_12,
    rbsk_team_id, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        #name#, #code#, #englishName#, #grantType#, #schoolType#, #noOfTeachers#, #principalName#, #contactPersonName#, #isPrePrimarySchool#, #isPrimarySchool#, #isHigherSecondarySchool#, #isMadresa#, #isGurukul#, #isOther#, #otherSchoolType#, #contactNumber#,
        #childMale1To5#, #childFemale1To5#, #childMale6To8#, #childFemale6To8#, #childMale9To10#, #childFemale9To10#, #childMale11To12#, #childFemale11To12#,
        #rbskTeamId#, #locationId#, #createdBy#, now(), #modifiedBy#, now()
    );', 
'Create School', 
false, 'ACTIVE');

