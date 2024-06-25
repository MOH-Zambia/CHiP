DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_location_cluster_mapping_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd2a40d1b-8fba-42f9-a3db-4cad23f4680e', 75398,  current_date , 75398,  current_date , 'covid19_insert_location_cluster_mapping_detail', 
'locations,clusterId,userId', 
'insert into location_cluster_mapping_detail
(cluster_id,location_id,state,created_by,created_on,modified_by,modified_on)
select #clusterId#,x,''ACTIVE'',#userId#,now(),#userId#,now()
from unnest(cast (#locations# as int[])) x;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_in_health_infra_lab_test_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0784f5a6-452b-437f-8a19-d3d4858873ab', 75398,  current_date , 75398,  current_date , 'insert_in_health_infra_lab_test_mapping', 
'ref_ids,type,health_infra_id', 
'delete
from
	health_infrastructure_lab_test_mapping
where
	health_infra_id = #health_infra_id# and permission_type = #type#;

insert
	into
		health_infrastructure_lab_test_mapping( health_infra_id, ref_id, permission_type )
	values(#health_infra_id#, unnest(cast( #ref_ids# as int[]) ), #type# )', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2bb9b2c2-93a3-4c29-b1ad-fe50fa491371', 75398,  current_date , 75398,  current_date , 'health_infrastructure_update', 
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,contactNumber,modifiedBy,id,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,created_by,noOfPpe,nameinenglish,iscpconfirmationcenter,iscmtc,contactPersonName,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme', 
'with update_health_infrastructure as (
        UPDATE
        health_infrastructure_details
        SET
        type=#type#,
        name=#name#,
        location_id=#locationid#,
        for_ncd=#forncd#,
        is_nrc=#isnrc#,
        is_cmtc=#iscmtc#,
        is_fru=#isfru#,
        is_sncu=#issncu#,
        is_hwc=#ishwc#,
        is_chiranjeevi_scheme=#ischiranjeevischeme#,
        is_balsaka=#isbalsaka#,
        is_pmjy=#ispmjy#,
        address=#address#,
        latitude=#latitude#,
        longitude=#longitude#,
        nin=#nin#,
        emamta_id=#emamtaid#,
        is_blood_bank=#isbloodbank#,
        is_gynaec=#isgynaec#,
        is_pediatrician=#ispediatrician#,
        postal_code=#postalcode#,
        landline_number=#landlinenumber#,
        mobile_number=#mobilenumber#,
        email=#email#,
        contact_person_name = #contactPersonName#,
        contact_number = #contactNumber#,
        name_in_english=#nameinenglish#,
        is_cpconfirmationcenter=#iscpconfirmationcenter#,
        created_by=#created_by#,
        created_on=now(),
        modified_on=now(),
        modified_by=#modifiedBy#,
        is_balsakha1=#isBalsakha1#,
        is_balsakha3=#isBalsakha3#,
        is_usg_facility=#isUsgFacility#,
        is_referral_facility=#isReferralFacility#,
        is_ma_yojna=#isMaYojna#,
        is_npcb=#isNpcb#,
        is_idsp=#isIdsp#,
        is_no_reporting_unit=#isNoReportingUnit#,
        no_of_beds=cast(#noOfBeds# as integer),
        is_covid_hospital=#isCovidHospital#,
        is_covid_lab=#isCovidLab#,
        no_of_ppe=#noOfPpe#
        WHERE id=#id#
        returning id
    )
    INSERT
    INTO
    health_infrastructure_details_history(
        health_infrastructure_details_id, action, type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe
    )
    VALUES (
        (select id from update_health_infrastructure), ''UPDATE'', #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#, #latitude#,
        #longitude#, #nin#, #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #modifiedBy#, now(), ''ACTIVE'',
        now(), #modifiedBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#
    )
    returning health_infrastructure_details_id as id;', 
'Update Health Infrastructure', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='translation_label_retrival';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'578b67fd-94cb-44f0-9e86-ff8ed9536f50', 75398,  current_date , 75398,  current_date , 'translation_label_retrival', 
'searchText,offset,limit,startsWith', 
'SELECT labelMaster1.key AS KEY, labelMaster1.language AS LANGUAGE ,labelMaster2.text AS label ,labelMaster1.text ,CASE WHEN labelMaster1.language = ''EN'' THEN ''English'' ELSE ''Gujarati'' END AS languageToDisplay, labelMaster1.translation_pending AS "isTranslationPending",labelMaster1.custom3b AS "isMobileLabel" FROM internationalization_label_master AS labelMaster1 JOIN internationalization_label_master AS labelMaster2 ON labelMaster2.key = labelMaster1.key WHERE labelMaster2.language = ''EN'' AND (#startsWith# = null OR labelMaster2.text ilike CONCAT(#startsWith# , ''%'')) AND (#searchText# = null OR labelMaster2.text ilike CONCAT(''%'',#searchText# , ''%'')) ORDER BY labelMaster1.key 
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='translation_label_check';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'305ca773-b081-462f-ba6a-6928a4056406', 75398,  current_date , 75398,  current_date , 'translation_label_check', 
'key', 
'select * from internationalization_label_master where key = #key#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='translation_label_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ca191c03-3147-4e9f-be41-7e6ce31878ad', 75398,  current_date , 75398,  current_date , 'translation_label_update', 
'oldKey,isMobileLabel,isTranslationPending,language,text', 
'UPDATE internationalization_label_master SET custom3b=#isMobileLabel#, text =#text#, translation_pending=#isTranslationPending#,modified_on=now()
 WHERE key = #oldKey# and language=#language#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='translation_label_add';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ef3a751e-377b-4113-8016-5d97f4100baa', 75398,  current_date , 75398,  current_date , 'translation_label_add', 
'isMobileLabel,language,label,loggedInUserId,text', 
'INSERT INTO internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
VALUES (''IN'', REPLACE(#label#,'' '',''''), #language#, #loggedInUserId# , now(), #isMobileLabel# , #text# ,false );', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_family_area';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1d07070c-2e6b-4cc8-9096-ff5240337785', -1,  current_date , -1,  current_date , 'update_family_area', 
'id,areaId,loggedInUserId', 
'
    update
        imt_family
    set
        area_id = #areaId#,
        modified_by = #loggedInUserId#,
        modified_on = now()
    where
        id = #id#;
', 
'Update family area', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_techo_member_contact_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b13bf844-5963-4228-baa5-3615d88906e3', 75398,  current_date , 75398,  current_date , 'covid19_insert_techo_member_contact_detail', 
'address,contact_no,name,location,loggedInUserId,memberId', 
'insert into covid_case_contact_history
(member_id,person_name,contact_no,address,health_state,state,location_id,created_by, created_on, modified_on, modified_by)
values(#memberId#,#name#
,(case when #contact_no# = null then null else #contact_no# end)
,(case when #address# = null then null else #address# end)
,''Suspected''
,''PENDING''
,(case when #location# = null then null else #location# end)
,#loggedInUserId#
, now()
, now()
, #loggedInUserId#
)
returning id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_soh_location_type_role_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8274392d-9e2c-4409-97cc-ac95d9e5032f', 75398,  current_date , 75398,  current_date , 'insert_soh_location_type_role_mapping', 
'location_type,role_ids', 
'delete from soh_location_type_role_mapping where location_type = #location_type#;
insert
	into
		soh_location_type_role_mapping( location_type, role_id )
	values( #location_type#, unnest(cast(#role_ids# as int[])))', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='delete_soh_location_user_by_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bc8277cb-3130-4814-9a1c-ec8b0bf7dd9b', 75398,  current_date , 75398,  current_date , 'delete_soh_location_user_by_type', 
'location_type', 
'delete from soh_location_users where location_type = #location_type#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='set_soh_enbale_in_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd229c71e-009e-44a0-ac97-fb4b45f1101b', 75398,  current_date , 75398,  current_date , 'set_soh_enbale_in_location_type', 
'is_soh_enable,type', 
'update
	location_type_master
set
	is_soh_enable = #is_soh_enable#
where
	type = #type#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='preg_reg_date_edit_list_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bd8e4ec8-bf64-40c1-bdbf-99c13caa41ed', 75398,  current_date , 75398,  current_date , 'preg_reg_date_edit_list_retrieve', 
'from_date,to_date,offSet,locationId,limit', 
'with dates as(
	select to_date(#from_date#,''MM/DD/YYYY'') from_date,
	to_date(#to_date#,''MM/DD/YYYY'') + interval ''1 month'' - interval ''1 millisecond'' to_date
),preg_ids as (
	select id,member_id from rch_pregnancy_registration_det
	inner join dates on true
	where location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
	and rch_pregnancy_registration_det.is_reg_date_verified is null
	and rch_pregnancy_registration_det.reg_date between dates.from_date and dates.to_date
	order by rch_pregnancy_registration_det.reg_date desc
	limit #limit# offset #offSet#
),anc_date as (
	select rch_anc_master.pregnancy_reg_det_id,to_char(min(service_date),''DD/MM/YYYY'') as ancVisitDate from preg_ids
	left join rch_anc_master on preg_ids.id = rch_anc_master.pregnancy_reg_det_id
	group by rch_anc_master.pregnancy_reg_det_id
)
select imt_member.id as "memberId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name,'' ('',imt_member.unique_health_id,'')'') as "memberNameId",
get_location_hierarchy(rch_pregnancy_registration_det.current_location_id) as "locationHierarchy",
rch_pregnancy_registration_det.reg_date as "regDate",
rch_pregnancy_registration_det.lmp_date as "lmpDate",
rch_pregnancy_registration_det.id as "pregId",
concat(um_user.first_name,'' '',um_user.last_name) as "fhwName",
anc_date.ancVisitDate as "ancVisitDate"
from preg_ids
inner join imt_member on preg_ids.member_id = imt_member.id
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.id = preg_ids.id
left join anc_date on rch_pregnancy_registration_det.id = anc_date.pregnancy_reg_det_id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.location_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 30 and um_user.state = ''ACTIVE''', 
'Retrieves List of registered pregnant women in Pregnancy Registration Edit Screen', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='preg_reg_date_edit_mark_incorrect';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3504ae0a-cf34-4d07-9795-5ba0545a53c3', 75398,  current_date , 75398,  current_date , 'preg_reg_date_edit_mark_incorrect', 
'pregId,pregDate', 
'update rch_pregnancy_registration_det
set reg_date = to_date(#pregDate#,''YYYY-MM-DD''), is_reg_date_verified = true
where id = #pregId#', 
'To change the pregnancy registration date in Pregnancy Registration Edit Screen', 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='role_search_for_selectize';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd5d3aaed-c896-4151-895f-f6ab129af880', 1027,  current_date , 1027,  current_date , 'role_search_for_selectize', 
'searchString,roleIds', 
'select id,first_name as "firstName", last_name as "lastName", user_name as "userName" from um_user where role_id in (#roleIds#) and (first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#%'') limit 50', 
'Return list of roles for wpd', 
true, 'ACTIVE');