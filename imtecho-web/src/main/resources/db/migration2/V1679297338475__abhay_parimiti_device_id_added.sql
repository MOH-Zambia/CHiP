alter table health_infrastructure_details
add column if not exists abhay_parimiti_id text;

alter table archive.health_infrastructure_details_history
add column if not exists abhay_parimiti_id text;

alter table chardham_tourist_screening_master
add column if not exists scan_id text;

DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_create';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'04c7681c-516f-4431-9cc3-fc584e3feebc', 60512,  current_date , 60512,  current_date , 'health_infrastructure_create',
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,hasOxygenCylinders,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,fundedBy,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,hasDefibrillators,contactNumber,hasVentilators,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,noOfPpe,nameinenglish,iscpconfirmationcenter,abhayParimitiId,iscmtc,contactPersonName,createdBy,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme',
'with insert_health_infrastructure as (
        INSERT
        INTO
        health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy, address,funded_by, latitude,
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
            postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
            modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
            is_covid_hospital, is_covid_lab, no_of_ppe,has_ventilators,has_defibrillators,has_oxygen_cylinders,abhay_parimiti_id
        )
        VALUES (
            #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
            #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#,#fundedBy#, #latitude#,
            #longitude#, #nin#, cast(#emamtaid# as bigint), #isbloodbank#, #isgynaec#, #ispediatrician#,
            #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
            now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, cast(#noOfBeds# as integer),
            #isCovidHospital#, #isCovidLab#, cast(#noOfPpe# as integer),#hasVentilators#,#hasDefibrillators#,#hasOxygenCylinders#, #abhayParimitiId#
        )
        returning id
    )
    INSERT
    INTO
    archive.health_infrastructure_details_history(
        health_infrastructure_details_id, action, type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address,funded_by, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe,has_ventilators,has_defibrillators,has_oxygen_cylinders,abhay_parimiti_id
    )
    VALUES (
        (select id from insert_health_infrastructure), ''CREATE'', #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#,#fundedBy#, #latitude#,
        #longitude#, #nin#, cast(#emamtaid# as bigint), #isbloodbank#, #isgynaec#, #ispediatrician#,
        #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
        now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, cast(#noOfBeds# as integer),
        #isCovidHospital#, #isCovidLab#, cast(#noOfPpe# as integer),#hasVentilators#,#hasDefibrillators#,#hasOxygenCylinders#, #abhayParimitiId#
    )
    returning health_infrastructure_details_id as id;',
'Create Health Infrastructure',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2bb9b2c2-93a3-4c29-b1ad-fe50fa491371', 60512,  current_date , 60512,  current_date , 'health_infrastructure_update',
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,hasOxygenCylinders,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,fundedBy,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,hasDefibrillators,contactNumber,modifiedBy,hasVentilators,id,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,created_by,noOfPpe,nameinenglish,iscpconfirmationcenter,abhayParimitiId,iscmtc,contactPersonName,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme',
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
        funded_by = #fundedBy#,
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
        --created_on=now(),
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
        no_of_ppe=#noOfPpe#,
        has_ventilators = #hasVentilators#,
        has_defibrillators = #hasDefibrillators#,
        has_oxygen_cylinders = #hasOxygenCylinders#,
        abhay_parimiti_id = #abhayParimitiId#
        WHERE id=#id#
        returning id
    )
    INSERT
    INTO
    archive.health_infrastructure_details_history(
        health_infrastructure_details_id, action, type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address,funded_by, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe,has_ventilators,has_defibrillators,has_oxygen_cylinders,abhay_parimiti_id
    )
    VALUES (
        (select id from update_health_infrastructure), ''UPDATE'', #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#,#fundedBy#, #latitude#,
        #longitude#, #nin#, #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #modifiedBy#, now(), ''ACTIVE'',
        now(), #modifiedBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#, #hasVentilators#, #hasDefibrillators#, #hasOxygenCylinders#, #abhayParimitiId#
    )
    returning health_infrastructure_details_id as id;',
'Update Health Infrastructure',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_retrieve_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ca2b8c66-29c6-4025-80b4-24107991f260', 60512,  current_date , 60512,  current_date , 'health_infrastructure_retrieve_by_id',
'id',
'with hd as (
    select
    health_infrastructure_details.id as id,
    health_infrastructure_details.type as type,
    health_infrastructure_details.name as name,
    location_id as locationid,
    health_infrastructure_details.address as address,
    health_infrastructure_details.funded_by as "fundedBy",
    no_of_beds as "noOfBeds",
    no_of_ppe as "noOfPpe",
    (case when postal_code=''null'' then '''' else postal_code end)  as postalcode,
    (case when landline_number=''null'' then '''' else landline_number end) as landlinenumber,
    (case when mobile_number=''null'' then '''' else mobile_number end) as mobilenumber,
    (case when email=''null'' then '''' else email end) as email,
    case when contact_person_name=''null'' then '''' else contact_person_name end as "contactPersonName",
    case when contact_number=''null'' then '''' else contact_number end as "contactNumber",
    (case when name_in_english=''null'' then '''' else name_in_english end) as nameinenglish,
    (case when latitude=''null'' then '''' else latitude end) as latitude,
    (case when longitude=''null'' then '''' else longitude end) as longitude,
    emamta_id as emamtaid,
    (case when nin=''null'' then '''' else nin end) as nin,
    location_master.type as locationtype,
    health_infrastructure_details.created_by,
    health_infrastructure_details.created_on,
    listvalue_field_value_detail.value as "typeOfHospitalName",
    abhay_parimiti_id as "abhayParimitiId"
    from  health_infrastructure_details, location_master,listvalue_field_value_detail
    where health_infrastructure_details.location_id = location_master.id
    and health_infrastructure_details.type = listvalue_field_value_detail.id
    and health_infrastructure_details.id = #id#
)
select
*
from hd h, (
    select
    child_id,
    string_agg(location_master.name,'' > '' order by depth desc) as locationname
    from location_hierchy_closer_det, location_master, hd
    where child_id = hd.locationid
    and location_master.id = location_hierchy_closer_det.parent_id
    group by child_id
) as t1',
'Retrieve Health Infrastructure by Id',
true, 'ACTIVE');