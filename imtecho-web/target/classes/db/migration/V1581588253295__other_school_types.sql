-- Add key value pair for other school types
-- For issue - https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3150

-- add is_other and other_school_type columns

alter table school_master
drop COLUMN IF EXISTS is_other,
add COLUMN is_other boolean;

alter table school_master
drop COLUMN IF EXISTS other_school_type,
add COLUMN other_school_type integer;

-- other school types

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'other_school_types', 'Other School Types', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='other_school_types');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Special School', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Special School');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Children Home', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Children Home');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Kendriya Vidyalaya', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Kendriya Vidyalaya');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Blind School', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Blind School');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Deaf and Dumb', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Deaf and Dumb');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Orphanage', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Orphanage');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Kasturba School', 'other_school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='other_school_types' AND value='Kasturba School');


-- update get post queries --

-- queries for feature of mange schools

-- retrieve all school

delete from query_master where code='school_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'school_retrieval', 'limit,offset,locationId', '
    SELECT
    sm.id,
	sm.name,
	sm.code,
	sm.english_name as "englishName",
	lfvd1.value as "grantType",
	lfvd2.value as "schoolType",
	sm.no_of_teachers as "noOfTeachers",
	sm.principal_name as "principalName",
	sm.contact_person_name as "contactPersonName",
	sm.is_pre_primary_school as "isPrePrimarySchool",
	sm.is_primary_school as "isPrimarySchool",
	sm.is_higher_secondary_school as "isHigherSecondarySchool",
	sm.is_madresa as "isMadresa",
	sm.is_gurukul as "isGurukul",
	sm.is_other as "isOther",
	lfvd3.value as "otherSchoolType",
	sm.contact_number as "contactNumber",
	sm.child_male_1_to_5 as "childMale1To5",
	sm.child_female_1_to_5 as "childFemale1To5",
	sm.child_male_6_to_8 as "childMale6To8",
	sm.child_female_6_to_8 as "childFemale6To8",
	sm.child_male_9_to_10 as "childMale9To10",
	sm.child_female_9_to_10 as "childFemale9To10",
	sm.child_male_11_to_12 as "childMale11To12",
	sm.child_female_11_to_12 as "childFemale11To12",
	sm.rbsk_team_id as "rbskTeamId",
	get_location_hierarchy(sm.location_id) as "locationHierarchy"
 	FROM public.school_master sm
	LEFT JOIN listvalue_field_value_detail lfvd1 on lfvd1.id = sm.grant_type
	LEFT JOIN listvalue_field_value_detail lfvd2 on lfvd2.id = sm.school_type
	LEFT JOIN listvalue_field_value_detail lfvd3 on lfvd3.id = sm.other_school_type
	WHERE sm.location_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#) or ''#locationId#'' = ''null'' or ''#locationId#'' = ''''
  	limit #limit# offset #offset#
', true, 'ACTIVE', 'School Retrieval');

-- retrieve school by id

delete from query_master where code='school_retrieval_by_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'school_retrieval_by_id', 'limit,offset,id', '
    SELECT
    sm.id,
	sm.name,
	sm.code,
	sm.english_name as "englishName",
	sm.grant_type as "grantType",
	sm.school_type as "schoolType",
	sm.no_of_teachers as "noOfTeachers",
	sm.principal_name as "principalName",
	sm.contact_person_name as "contactPersonName",
	sm.is_pre_primary_school as "isPrePrimarySchool",
	sm.is_primary_school as "isPrimarySchool",
	sm.is_higher_secondary_school as "isHigherSecondarySchool",
	sm.is_madresa as "isMadresa",
	sm.is_gurukul as "isGurukul",
	sm.is_other as "isOther",
	sm.other_school_type as "otherSchoolType",
	sm.contact_number as "contactNumber",
	sm.child_male_1_to_5 as "childMale1To5",
	sm.child_female_1_to_5 as "childFemale1To5",
	sm.child_male_6_to_8 as "childMale6To8",
	sm.child_female_6_to_8 as "childFemale6To8",
	sm.child_male_9_to_10 as "childMale9To10",
	sm.child_female_9_to_10 as "childFemale9To10",
	sm.child_male_11_to_12 as "childMale11To12",
	sm.child_female_11_to_12 as "childFemale11To12",
	sm.rbsk_team_id as "rbskTeamId",
	sm.location_id as "locationId",
	get_location_hierarchy(sm.location_id) as "locationHierarchy"
 	FROM public.school_master sm
    where sm.id = #id#
  	limit #limit# offset #offset#
', true, 'ACTIVE', 'School Retrieval By Id');

-- create school

delete from query_master where code='school_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'school_create','name,code,englishName,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrePrimarySchool,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,isOther,otherSchoolType,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,createdBy,modifiedBy','
INSERT INTO public.school_master(
    "name", code, english_name, grant_type, school_type, no_of_teachers, principal_name, contact_person_name, is_pre_primary_school, is_primary_school, is_higher_secondary_school, is_madresa, is_gurukul, is_other, other_school_type, contact_number,
    child_male_1_to_5, child_female_1_to_5, child_male_6_to_8, child_female_6_to_8, child_male_9_to_10, child_female_9_to_10, child_male_11_to_12, child_female_11_to_12,
    rbsk_team_id, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#name#'', ''#code#'', ''#englishName#'', #grantType#, #schoolType#, #noOfTeachers#, ''#principalName#'', ''#contactPersonName#'', #isPrePrimarySchool#, #isPrimarySchool#, #isHigherSecondarySchool#, #isMadresa#, #isGurukul#, #isOther#, #otherSchoolType#, ''#contactNumber#'',
        #childMale1To5#, #childFemale1To5#, #childMale6To8#, #childFemale6To8#, #childMale9To10#, #childFemale9To10#, #childMale11To12#, #childFemale11To12#,
        ''#rbskTeamId#'', #locationId#, #createdBy#, now(), #modifiedBy#, now()
    );', false, 'ACTIVE', 'Create School');

-- update school

delete from query_master where code='school_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, now(), 'school_update', 'id,name,code,englishName,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrePrimarySchool,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,isOther,otherSchoolType,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,modifiedBy','
UPDATE public.school_master
    SET
    "name"=''#name#'', code=''#code#'', english_name=''#englishName#'', grant_type=#grantType#, school_type=#schoolType#, no_of_teachers=#noOfTeachers#, principal_name=''#principalName#'', contact_person_name=''#contactPersonName#'', is_pre_primary_school=#isPrePrimarySchool#, is_primary_school=#isPrimarySchool#, is_higher_secondary_school=#isHigherSecondarySchool#, is_madresa=#isMadresa#, is_gurukul=#isGurukul#, is_other=#isOther#, other_school_type=#otherSchoolType#, contact_number=''#contactNumber#'',
    child_male_1_to_5=#childMale1To5#, child_female_1_to_5=#childFemale1To5#, child_male_6_to_8=#childMale6To8#, child_female_6_to_8=#childFemale6To8#, child_male_9_to_10=#childMale9To10#, child_female_9_to_10=#childFemale9To10#, child_male_11_to_12=#childMale11To12#, child_female_11_to_12=#childFemale11To12#,
    rbsk_team_id=''#rbskTeamId#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=now()
    WHERE id=#id#;', false, 'ACTIVE', 'Update School');

--



