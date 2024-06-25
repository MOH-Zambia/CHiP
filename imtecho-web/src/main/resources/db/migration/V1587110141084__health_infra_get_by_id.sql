DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_retrieve_by_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_retrieve_by_id',
'id',
'
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
        health_infrastructure_details.is_covid_hospital as "isCovidHospital",
        health_infrastructure_details.is_covid_lab as "isCovidLab",
        listvalue_field_value_detail.value as "typeOfHospitalName"
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
    ) as t1
',
'Retrieve Health Infrastructure by Id',
true, 'ACTIVE');