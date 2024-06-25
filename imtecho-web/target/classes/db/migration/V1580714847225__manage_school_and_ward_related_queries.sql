
-- manage school related queries

delete from query_master where code='school_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'school_create','name,code,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,createdBy,modifiedBy','
INSERT INTO public.school_master(
    "name", code, grant_type, school_type, no_of_teachers, principal_name, contact_person_name, is_primary_school, is_higher_secondary_school, is_madresa, is_gurukul, contact_number,
    child_male_1_to_5, child_female_1_to_5, child_male_6_to_8, child_female_6_to_8, child_male_9_to_10, child_female_9_to_10, child_male_11_to_12, child_female_11_to_12,
    rbsk_team_id, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#name#'', ''#code#'', #grantType#, #schoolType#, #noOfTeachers#, ''#principalName#'', ''#contactPersonName#'', #isPrimarySchool#, #isHigherSecondarySchool#, #isMadresa#, #isGurukul#, ''#contactNumber#'',
        #childMale1To5#, #childFemale1To5#, #childMale6To8#, #childFemale6To8#, #childMale9To10#, #childFemale9To10#, #childMale11To12#, #childFemale11To12#,
        ''#rbskTeamId#'', #locationId#, #createdBy#, now(), #modifiedBy#, now()
    );', false, 'ACTIVE', 'Create School');

--

delete from query_master where code='school_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, now(), 'school_update', 'id,name,code,grantType,schoolType,noOfTeachers,principalName,contactPersonName,isPrimarySchool,isHigherSecondarySchool,isMadresa,isGurukul,contactNumber,childMale1To5,childFemale1To5,childMale6To8,childFemale6To8,childMale9To10,childFemale9To10,childMale11To12,childFemale11To12,rbskTeamId,locationId,modifiedBy','
UPDATE public.school_master
    SET
    "name"=''#name#'', code=''#code#'', grant_type=#grantType#, school_type=#schoolType#, no_of_teachers=#noOfTeachers#, principal_name=''#principalName#'', contact_person_name=''#contactPersonName#'', is_primary_school=#isPrimarySchool#, is_higher_secondary_school=#isHigherSecondarySchool#, is_madresa=#isMadresa#, is_gurukul=#isGurukul#, contact_number=''#contactNumber#'',
    child_male_1_to_5=#childMale1To5#, child_female_1_to_5=#childFemale1To5#, child_male_6_to_8=#childMale6To8#, child_female_6_to_8=#childFemale6To8#, child_male_9_to_10=#childMale9To10#, child_female_9_to_10=#childFemale9To10#, child_male_11_to_12=#childMale11To12#, child_female_11_to_12=#childFemale11To12#,
    rbsk_team_id=''#rbskTeamId#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=now()
    WHERE id=#id#;', false, 'ACTIVE', 'Update School');

--

delete from query_master where code='school_retrieval_by_code';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'school_retrieval_by_code', 'id,code','
    SELECT
    id,
    name,
    code,
    location_id
    FROM public.school_master
    WHERE
    code = ''#code#''
    and id != #id#;
', true, 'ACTIVE', 'Retrieve School By Code');

-- manage ward related queries

delete from query_master where code='location_ward_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_create','wardName,lgdCode,locationId,createdBy,modifiedBy','
INSERT INTO public.location_wards(
    ward_name, lgd_code, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#wardName#'', ''#lgdCode#'', #locationId#, #createdBy#, now(), #modifiedBy#, now()
    ) returning id;', true, 'ACTIVE', 'Create Location Ward');

--

delete from query_master where code='location_ward_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_update', 'id,wardName,lgdCode,locationId,modifiedBy','
UPDATE public.location_wards
    SET
    "ward_name"=''#wardName#'', lgd_code=''#lgdCode#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=now()
    WHERE id=#id#;', false, 'ACTIVE', 'Update Location Ward');

--

delete from query_master where code='location_ward_retrieval_by_lgd_code';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_retrieval_by_lgd_code', 'id,lgdCode','
    SELECT
    id,
    ward_name,
    lgd_code,
    location_id
    FROM public.location_wards
    WHERE
    lgd_code = ''#lgdCode#''
    and id != #id#;
', true, 'ACTIVE', 'Retrieve Location Ward By LGD Code');

-- add constraints of not null in school_master table

alter table school_master alter column "name" set not null;
alter table school_master alter column code set not null;
alter table school_master alter column grant_type set not null;
alter table school_master alter column location_id set not null;
alter table school_master alter column contact_person_name set not null;
alter table school_master alter column contact_number set not null;

-- add constraints of not null in location_wards table

alter table location_wards alter column ward_name set not null;
alter table location_wards alter column lgd_code set not null;
alter table location_wards alter column location_id set not null;


alter table location_wards_mapping alter column ward_id set not null;
alter table location_wards_mapping alter column location_id set not null;

--