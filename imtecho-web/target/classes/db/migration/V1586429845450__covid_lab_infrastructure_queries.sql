drop table if exists covid19_lab_infrastructure_kit_history;

create table covid19_lab_infrastructure_kit_history
(
	id serial primary key,
	health_infra_id integer not null,
	receipt_date timestamp without time zone not null,
	received_from text not null,
	list_of_kits integer not null,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

drop table if exists covid19_lab_infrastructure_component_history;

create table covid19_lab_infrastructure_component_history
(
	id serial primary key,
	health_infra_id integer not null,
	receipt_date timestamp without time zone not null,
	rna_extraction integer not null,
	eg_available integer not null,
	confirmatory_assay integer not null,
	ag_path integer not null,
	test_capacity integer not null,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

delete from QUERY_MASTER where CODE='covid19_insert_lab_infrastructure_kit_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_insert_lab_infrastructure_kit_details',
'healthInfraId,receiptDate,receivedFrom,kitsList,userId',
'insert into covid19_lab_infrastructure_kit_history
(health_infra_id,receipt_date,received_from,list_of_kits,created_by,created_on,modified_by,modified_on)
values(#healthInfraId#,to_timestamp(''#receiptDate#'',''DD/MM/YYYY''),''#receivedFrom#'',#kitsList#,#userId#,now(),#userId#,now());',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_insert_lab_infrastructure_component_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_insert_lab_infrastructure_component_details',
'healthInfraId,eg,confirmatoryAssay,testCapacity,receiptDate,agPath,userId,rnaExtraction',
'insert into covid19_lab_infrastructure_component_history
(health_infra_id,receipt_date,rna_extraction,eg_available,confirmatory_assay,ag_path,test_capacity,created_by,created_on,modified_by,modified_on)
values(#healthInfraId#,to_timestamp(''#receiptDate#'',''DD/MM/YYYY''),#rnaExtraction#,#eg#,#confirmatoryAssay#,#agPath#,#testCapacity#,#userId#,now(),#userId#,now());',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_retrieve_lab_infrastructure_testing_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_retrieve_lab_infrastructure_testing_details',
'healthInfraId',
'select receipt_date as "receiptDate",
received_from as "receivedFrom",
list_of_kits as "kitsList"
from covid19_lab_infrastructure_kit_history
where health_infra_id = #healthInfraId#;',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_retrieve_lab_infrastructure_component_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_retrieve_lab_infrastructure_component_details',
'healthInfraId',
'select receipt_date as "receiptDate",
rna_extraction as "rnaExtraction",
eg_available as "eg",
confirmatory_assay as "confirmatoryAssay",
ag_path as "agPath",
test_capacity as "testCapacity"
from covid19_lab_infrastructure_component_history
where health_infra_id = #healthInfraId#;',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_component_details_by_date_and_infra';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_component_details_by_date_and_infra',
'healthInfraId,receiptDate',
'select *
from covid19_lab_infrastructure_component_history
where health_infra_id = #healthInfraId#
and receipt_date = to_timestamp(''#receiptDate#'',''DD/MM/YYYY'');',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='retrieve_assigned_covid_hospitals';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'retrieve_assigned_covid_hospitals',
'userId',
'select health_infrastructure_details.*,
get_location_hierarchy(health_infrastructure_details.location_id) as "healthInfraLocation",
listvalue_field_value_detail.value as "typeOfHosiptalName"
from health_infrastructure_details
inner join user_health_infrastructure on health_infrastructure_details.id = user_health_infrastructure.health_infrastrucutre_id
left join listvalue_field_value_detail on health_infrastructure_details.type = listvalue_field_value_detail.id
where user_health_infrastructure.user_id = #userId#
and (health_infrastructure_details.is_covid_hospital or health_infrastructure_details.is_covid_lab)',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_update_lab_infrastructure_component_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_update_lab_infrastructure_component_details',
'eg,confirmatoryAssay,testCapacity,id,agPath,userId,rnaExtraction',
'update covid19_lab_infrastructure_component_history
set rna_extraction = #rnaExtraction#,
eg_available = #eg#,
confirmatory_assay = #confirmatoryAssay#,
ag_path = #agPath#,
test_capacity = #testCapacity#,
modified_by = #userId#,
modified_on = now()
where id = #id#',
null,
false, 'ACTIVE');

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
    ) as t1',
'Retrieve Health Infrastructure by Id',
true, 'ACTIVE');

delete from menu_config where menu_name = 'Manage Lab Infrastructure';

insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),true,'Manage Lab Infrastructure','techo.manage.labinfrastructure','manage');