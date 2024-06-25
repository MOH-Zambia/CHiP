alter table health_infrastructure_details
drop column if exists contact_person_name,
drop column if exists contact_number,
add column contact_person_name text,
add column contact_number text;

alter table health_infrastructure_details_history
drop column if exists contact_person_name,
drop column if exists contact_number,
add column contact_person_name text,
add column contact_number text;

delete from QUERY_MASTER where CODE='health_infrastructure_create';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_create',
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,contactNumber,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,noOfPpe,nameinenglish,iscpconfirmationcenter,iscmtc,contactPersonName,createdBy,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme',
'with insert_health_infrastructure as (
        INSERT
        INTO
        public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
            postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
            modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
            is_covid_hospital, is_covid_lab, no_of_ppe
        )
        VALUES (
            #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
            #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
            ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
            ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'',''#contactPersonName#'',''#contactNumber#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
            now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
            #isCovidHospital#, #isCovidLab#, #noOfPpe#
        )
        returning id
    )
    INSERT
    INTO
    public.health_infrastructure_details_history(
        health_infrastructure_details_id, action, type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe
    )
    VALUES (
        (select id from insert_health_infrastructure), ''CREATE'', #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
        ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'',''#contactPersonName#'',''#contactNumber#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
        now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#
    )
    returning health_infrastructure_details_id as id;',
'Create Health Infrastructure',
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='health_infrastructure_update';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_update',
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,contactNumber,modifiedBy,id,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,created_by,noOfPpe,nameinenglish,iscpconfirmationcenter,iscmtc,contactPersonName,created_on,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme',
'with update_health_infrastructure as (
        UPDATE
        public.health_infrastructure_details
        SET
        type=#type#,
        name=''#name#'',
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
        address=''#address#'',
        latitude=''#latitude#'',
        longitude=''#longitude#'',
        nin=''#nin#'',
        emamta_id=#emamtaid#,
        is_blood_bank=#isbloodbank#,
        is_gynaec=#isgynaec#,
        is_pediatrician=#ispediatrician#,
        postal_code=''#postalcode#'',
        landline_number=''#landlinenumber#'',
        mobile_number=''#mobilenumber#'',
        email=''#email#'',
        contact_person_name = ''#contactPersonName#'',
        contact_number = ''#contactNumber#'',
        name_in_english=''#nameinenglish#'',
        is_cpconfirmationcenter=#iscpconfirmationcenter#,
        created_by=#created_by#,
        created_on=''#created_on#'',
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
        no_of_beds=#noOfBeds#,
        is_covid_hospital=#isCovidHospital#,
        is_covid_lab=#isCovidLab#,
        no_of_ppe=#noOfPpe#
        WHERE id=#id#
        returning id
    )
    INSERT
    INTO
    public.health_infrastructure_details_history(
        health_infrastructure_details_id, action, type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe
    )
    VALUES (
        (select id from update_health_infrastructure), ''UPDATE'', #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
        ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'',''#contactPersonName#'',''#contactNumber#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #modifiedBy#, now(), ''ACTIVE'',
        now(), #modifiedBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#
    )
    returning health_infrastructure_details_id as id;',
'Update Health Infrastructure',
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='health_infrastructure_retrieve_by_id';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_retrieve_by_id',
'id',
'with hd as (
        select
        health_infrastructure_details.id as id,
        health_infrastructure_details.type as type,
        health_infrastructure_details.name as name,
        location_id as locationid,
        health_infrastructure_details.address as address,
        is_nrc as isnrc,
        for_ncd as forncd,
        is_hwc as ishwc,
        is_fru as isfru,
        is_cmtc as iscmtc,
        is_sncu as issncu,
        is_blood_bank as isbloodbank,
        is_gynaec as isgynaec,
        is_pediatrician as ispediatrician,
        is_cpconfirmationcenter as iscpconfirmationcenter,
        is_chiranjeevi_scheme as "ischiranjeevischeme",
        is_balsakha1 as "isBalsakha1",
        is_balsakha3 as "isBalsakha3",
        is_usg_facility as "isUsgFacility",
        is_referral_facility as "isReferralFacility",
        is_ma_yojna as "isMaYojna",
        is_pmjy as "ispmjy",
        is_npcb as "isNpcb",
        is_Idsp as "isIdsp",
        is_no_reporting_unit as "isNoReportingUnit",
        no_of_beds as "noOfBeds",
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
        health_infrastructure_details.is_covid_hospital as "isCovidHospital",
        health_infrastructure_details.is_covid_lab as "isCovidLab"
        from  health_infrastructure_details, location_master
        where health_infrastructure_details.location_id = location_master.id
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