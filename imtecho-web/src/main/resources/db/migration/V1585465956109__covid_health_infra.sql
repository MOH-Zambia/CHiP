
--  feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3459

alter table health_infrastructure_details
drop column if exists is_covid_hospital,
add column is_covid_hospital boolean;


alter table health_infrastructure_details
drop column if exists is_covid_lab,
add column is_covid_lab boolean;


-- health_infrastructure_create

delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'health_infrastructure_create',
'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,nameinenglish,iscpconfirmationcenter,iscmtc,createdBy,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,isCovidHospital,isCovidLab', '
    INSERT
    INTO
    public.health_infrastructure_details(
        type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
        is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
        longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
        postal_code, landline_number, mobile_number, email, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab
    )
    VALUES (
        #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
        ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
        now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#
    )
    returning id;
', true, 'ACTIVE', 'Create Health Infrastructure');


-- health_infrastructure_update

delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'health_infrastructure_update',
'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,modifiedBy,id,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,created_by,nameinenglish,iscpconfirmationcenter,iscmtc,created_on,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,isCovidHospital,isCovidLab', '
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
    is_covid_lab=#isCovidLab#
    WHERE id=#id#
    returning id;
', true, 'ACTIVE', 'Update Health Infrastructure');


-- health_infrastructure_retrieve_by_id

delete from query_master where code='health_infrastructure_retrieve_by_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'health_infrastructure_retrieve_by_id', 'id', '
    with hd as (
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
    ) as t1
', true, 'ACTIVE', 'Retrieve Health Infrastructure by Id');


-- Add key value pair in db for ward type

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'health_infrastructure_ward_types', 'healthInfrastructureWardTypes', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='health_infrastructure_ward_types');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'ICU', 'health_infrastructure_ward_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='health_infrastructure_ward_types' AND value='ICU');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Isolation', 'health_infrastructure_ward_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='health_infrastructure_ward_types' AND value='Isolation');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Severe', 'health_infrastructure_ward_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='health_infrastructure_ward_types' AND value='Severe');

-- create table health_infrastructure_ward_details

drop table if exists health_infrastructure_ward_details;
create table health_infrastructure_ward_details (
    id serial primary key,
    health_infra_id integer,
    ward_name varchar(255),
    ward_type integer,
    number_of_beds integer,
    number_of_ventilators_type1 integer,
    number_of_vantilators_type2 integer,
    number_of_o2 integer,
    status varchar(50),
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);

-- fetch ward details by health_infra_id
-- get_health_infrastructure_ward_details

delete from query_master where code='get_health_infrastructure_ward_details';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'get_health_infrastructure_ward_details', 'healthInfraId', '
    select
    id as "id",
    health_infra_id as "healthInfraId",
    ward_name as "wardName",
    ward_type as "wardType",
    number_of_beds as "numberOfBeds",
    number_of_ventilators_type1 as "numberOfVentilatorsType1",
    number_of_vantilators_type2 as "numberOfVentilatorsType2",
    number_of_o2 as "numberOfO2",
    status as "status",
    created_by as "createdBy",
    created_on as "createdOn",
    modified_by as "modifiedBy",
    modified_on as "modifiedOn"
    from
    health_infrastructure_ward_details
    WHERE health_infra_id = #healthInfraId#
', true, 'ACTIVE', 'Fetch Health Infrastructure Ward Details');
