-- queries for feature of mange schools
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3036


delete from query_master where code='school_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'school_retrieval', 'limit,offset,locationId', '
    SELECT
    sm.id,
	sm.name,
	sm.code,
	lfvd1.value as "grantType",
	lfvd2.value as "schoolType",
	sm.no_of_teachers as "noOfTeachers",
	sm.principal_name as "principalName",
	sm.contact_person_name as "contactPersonName",
	sm.is_primary_school as "isPrimarySchool",
	sm.is_higher_secondary_school as "isHigherSecondarySchool",
	sm.is_madresa as "isMadresa",
	sm.is_gurukul as "isGurukul",
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
	WHERE sm.location_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#) or ''#locationId#'' = ''null'' or ''#locationId#'' = ''''
  	limit #limit# offset #offset#
', true, 'ACTIVE', 'School Retrieval');

--

delete from query_master where code='school_retrieval_by_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'school_retrieval_by_id', 'limit,offset,id', '
    SELECT
    sm.id,
	sm.name,
	sm.code,
	sm.grant_type as "grantType",
	sm.school_type as "schoolType",
	sm.no_of_teachers as "noOfTeachers",
	sm.principal_name as "principalName",
	sm.contact_person_name as "contactPersonName",
	sm.is_primary_school as "isPrimarySchool",
	sm.is_higher_secondary_school as "isHigherSecondarySchool",
	sm.is_madresa as "isMadresa",
	sm.is_gurukul as "isGurukul",
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

--

delete from query_master where code='school_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'school_create','name,code,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,createdBy,createdOn,modifiedBy,modifiedOn','
INSERT INTO public.school_master(
    "name", code, grant_type, school_type, no_of_teachers, principal_name, contact_person_name, is_primary_school, is_higher_secondary_school, is_madresa, is_gurukul, contact_number,
    child_male_1_to_5, child_female_1_to_5, child_male_6_to_8, child_female_6_to_8, child_male_9_to_10, child_female_9_to_10, child_male_11_to_12, child_female_11_to_12,
    rbsk_team_id, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#name#'', ''#code#'', #grantType#, #schoolType#, #noOfTeachers#, ''#principalName#'', ''#contactPersonName#'', #isPrimarySchool#, #isHigherSecondarySchool#, #isMadresa#, #isGurukul#, ''#contactNumber#'',
        #childMale1To5#, #childFemale1To5#, #childMale6To8#, #childFemale6To8#, #childMale9To10#, #childFemale9To10#, #childMale11To12#, #childFemale11To12#,
        ''#rbskTeamId#'', #locationId#, #createdBy#, ''#createdOn#'', #modifiedBy#, ''#modifiedOn#''
    );', false, 'ACTIVE', 'Create School');

--

delete from query_master where code='school_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, now(), 'school_update', 'id,name,code,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,modifiedBy,modifiedOn','
UPDATE public.school_master
    SET
    "name"=''#name#'', code=''#code#'', grant_type=#grantType#, school_type=#schoolType#, no_of_teachers=#noOfTeachers#, principal_name=''#principalName#'', contact_person_name=''#contactPersonName#'', is_primary_school=#isPrimarySchool#, is_higher_secondary_school=#isHigherSecondarySchool#, is_madresa=#isMadresa#, is_gurukul=#isGurukul#, contact_number=''#contactNumber#'',
    child_male_1_to_5=#childMale1To5#, child_female_1_to_5=#childFemale1To5#, child_male_6_to_8=#childMale6To8#, child_female_6_to_8=#childFemale6To8#, child_male_9_to_10=#childMale9To10#, child_female_9_to_10=#childFemale9To10#, child_male_11_to_12=#childMale11To12#, child_female_11_to_12=#childFemale11To12#,
    rbsk_team_id=''#rbskTeamId#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=''#modifiedOn#''
    WHERE id=#id#;', false, 'ACTIVE', 'Update School');
