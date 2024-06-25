DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_retrieval';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_retrieval',
'offset,locationId,name,limit,type',
'
    with hospital_data as (
        SELECT
        type as hospitalType,
        name as name,
        location_id as locationid,
        is_blood_bank as isBloodBank,
        is_gynaec as isGynaec,
        is_pediatrician as ispediatrician,
        for_ncd as forncd,
        is_nrc as isNrc,
        is_cmtc as isCmtc,
        is_fru as isFru,
        is_sncu as isSncu,
        is_hwc as isHwc,
        is_chiranjeevi_scheme as ischiranjeevischeme,
        is_balsaka as isBalsaka,
        is_pmjy as ispmjy,
        is_idsp as isidsp,
        id as id,
        address as address,
        is_cpconfirmationcenter as isconfirmationcenter,
        is_balsakha1 as isBalsakha1,
        is_balsakha3 as isBalsakha3,
        is_usg_facility as isUsgFacility,
        is_referral_facility as isReferralFacility,
        is_ma_yojna as isMaYojna,
        is_npcb as isNpcb,
        is_no_reporting_unit as isNoReportingUnit,
        is_covid_hospital as isCovidHospital,
        is_covid_lab as isCovidLab
        FROM public.health_infrastructure_details
        where
            (location_id IN
                (select d.child_id from location_master m, location_hierchy_closer_det d where m.id = d.child_id and (''#locationId#''= ''null'' or parent_id in (#locationId#)) order by depth asc)
                or ''#locationId#'' = ''null'' or ''#locationId#'' = '''')
            and (''#name#'' = ''null'' or name ilike ''%#name#%'')
            and (''#type#'' = ''null'' or type = #type#)
        limit #limit# offset #offset#
    )
    select
    string_agg(location_master.name,'' > '' order by depth desc) as locationname,
    hospitalType,
    locationId,
    isNrc,
    isCmtc,
    isFru,
    forncd,
    isSncu,
    isHwc,
    hospital_data.name,
    isBloodBank,
    isGynaec,
    ispediatrician,
    ischiranjeevischeme,
    isBalsaka,
    ispmjy,
    isidsp,
    isBalsakha1,
    isBalsakha3,
    isUsgFacility,
    isReferralFacility,
    isMaYojna,
    isNpcb,
    isNoReportingUnit,
    hospital_data.id,
    isconfirmationcenter,
    hospital_data.address,
    isCovidHospital,
    isCovidLab
    from hospital_data, location_hierchy_closer_det, location_master
    where location_hierchy_closer_det.child_id = hospital_data.locationid and location_master.id = location_hierchy_closer_det.parent_id
    group by hospitalType, locationid, isNrc, isCmtc, isFru, isSncu, isHwc, hospital_data.name,
    ischiranjeevischeme, isBalsaka, ispmjy, isidsp, hospital_data.id, hospital_data. address, isBloodBank, isGynaec, forncd, ispediatrician, isconfirmationcenter,
    isBalsakha1, isBalsakha3, isUsgFacility, isReferralFacility, isMaYojna, isNpcb, isNoReportingUnit, isCovidHospital, isCovidLab
',
'Retrieve health infrastructures',
true, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='my_health_infrastructure_retrieval';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'my_health_infrastructure_retrieval',
'offset,limit,loggedInUserId',
'
    select
    hid.*,
    get_location_hierarchy(hid.location_id) as "locationHierarchy"
    from user_health_infrastructure uhi
    inner join health_infrastructure_details hid on uhi.health_infrastrucutre_id = hid.id
    where uhi.user_id = #loggedInUserId#
    and uhi.state = ''ACTIVE''
    limit #limit# offset #offset#
',
'Retrieve My Health Infrastructures',
true, 'ACTIVE');


--

insert
into
menu_config(menu_name, menu_type, active, navigation_state, feature_json, group_id)
select
'Manage Health Infrastructure', 'manage', TRUE, 'techo.manage.covid19healthinfrastructures',
'{"canAdd":false,"canEditBloodBank":false,"canEdit":false,"canChangeLocation":false,"canEditFru":false,"canEditPediatrician":false,"canEditCmtc":false,"canEditNrc":false,"canEditGynaec":false,"canEditSncu":false,"canEditChiranjeevi":false,"canEditBalsakha1":false,"canEditBalsakha3":false,"canEditUsgFacility":false,"canEditReferralFacility":false,"canEditMaYojna":false,"canEditPmjayFacility":false,"canEditNpcb":false,"canEditNcd":false,"canEditHWC":false,"canEditIdsp":false,"canEditCovid19Lab":false,"canEditCovid19Hospital":false,"canEditLabTest":false,"manageBasedOnLocation":false,"manageBasedOnAssignment":false}',
id
from menu_group
where group_name = 'COVID-19'
and group_type = 'manage'
and not exists (select id from menu_config where menu_name = 'Manage Health Infrastructure' and menu_type = 'manage');

--

update
menu_config
set
feature_json = '{"canAdd":false,"canEditBloodBank":false,"canEdit":false,"canChangeLocation":false,"canEditFru":false,"canEditPediatrician":false,"canEditCmtc":false,"canEditNrc":false,"canEditGynaec":false,"canEditSncu":false,"canEditChiranjeevi":false,"canEditBalsakha1":false,"canEditBalsakha3":false,"canEditUsgFacility":false,"canEditReferralFacility":false,"canEditMaYojna":false,"canEditPmjayFacility":false,"canEditNpcb":false,"canEditNcd":false,"canEditHWC":false,"canEditIdsp":false,"canEditCovid19Lab":false,"canEditCovid19Hospital":false,"canEditLabTest":false,"manageBasedOnLocation":false,"manageBasedOnAssignment":false}'
where menu_name = 'Health Facility Mapping'
and menu_type = 'manage';

--

alter table health_infrastructure_details
drop column if exists no_of_ppe,
add column no_of_ppe integer;

--

DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_update';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_update',
'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,modifiedBy,id,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,created_by,nameinenglish,iscpconfirmationcenter,iscmtc,created_on,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,isCovidHospital,isCovidLab,noOfPpe',
'
    with update_health_infrastructure as (
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
        postal_code, landline_number, mobile_number, email, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe
    )
    VALUES (
        (select id from update_health_infrastructure), ''UPDATE'', #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
        ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #modifiedBy#, now(), ''ACTIVE'',
        now(), #modifiedBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#
    )
    returning health_infrastructure_details_id as id;
',
'Update Health Infrastructure',
true, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_create';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'health_infrastructure_create',
'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,nameinenglish,iscpconfirmationcenter,iscmtc,createdBy,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,isCovidHospital,isCovidLab,noOfPpe',
'
    with insert_health_infrastructure as (
        INSERT
        INTO
        public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
            postal_code, landline_number, mobile_number, email, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
            modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
            is_covid_hospital, is_covid_lab, no_of_ppe
        )
        VALUES (
            #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
            #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
            ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
            ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
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
        postal_code, landline_number, mobile_number, email, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
        modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
        is_covid_hospital, is_covid_lab, no_of_ppe
    )
    VALUES (
        (select id from insert_health_infrastructure), ''CREATE'', #type#, ''#name#'', #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, ''#address#'', ''#latitude#'',
        ''#longitude#'', ''#nin#'', #emamtaid#, #isbloodbank#, #isgynaec#, #ispediatrician#,
        ''#postalcode#'', ''#landlinenumber#'', ''#mobilenumber#'', ''#email#'', ''#nameinenglish#'', #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
        now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, #noOfBeds#,
        #isCovidHospital#, #isCovidLab#, #noOfPpe#
    )
    returning health_infrastructure_details_id as id;
',
'Create Health Infrastructure',
true, 'ACTIVE');

--

DROP TABLE IF EXISTS public.health_infrastructure_details_history;
CREATE TABLE public.health_infrastructure_details_history (
	id serial NOT NULL,
	health_infrastructure_details_id integer NOT NULL,
	action varchar(50) NOT NULL,
	"name" varchar(500) NULL,
	location_id integer NULL,
	is_nrc boolean NULL,
	is_cmtc boolean NULL,
	is_fru boolean NULL,
	is_sncu boolean NULL,
	is_chiranjeevi_scheme boolean NULL,
	is_balsaka boolean NULL,
	is_pmjy boolean NULL,
	address varchar(1000) NULL,
	state varchar(255) NULL,
	"type" integer NULL,
	latitude varchar(100) NULL,
	longitude varchar(100) NULL,
	nin varchar(100) NULL,
	emamta_id bigint NULL,
	is_blood_bank boolean NULL,
	is_gynaec boolean NULL,
	is_pediatrician boolean NULL,
	postal_code varchar(100) NULL,
	landline_number varchar(100) NULL,
	mobile_number varchar(100) NULL,
	email varchar(256) NULL,
	name_in_english varchar(1000) NULL,
	is_cpconfirmationcenter boolean NULL,
	for_ncd boolean NULL,
	no_of_beds integer NULL,
	is_balsakha1 boolean NULL,
	is_balsakha3 boolean NULL,
	is_usg_facility boolean NULL,
	is_referral_facility boolean NULL,
	is_ma_yojna boolean NULL,
	is_npcb boolean NULL,
	sub_type integer NULL,
	registration_number text NULL,
	is_hwc boolean NULL,
	is_no_reporting_unit boolean NULL,
	is_idsp boolean NULL,
	is_covid_hospital boolean NULL,
	is_covid_lab boolean NULL,
	no_of_ppe integer NULL,
	created_by integer NULL,
	created_on timestamp without time zone NULL,
	modified_by integer NULL,
	modified_on timestamp without time zone NULL
);

--

drop table if exists health_infrastructure_ward_details_history;
create table health_infrastructure_ward_details_history (
    id serial primary key,
    health_infrastructure_ward_details_id integer,
    action varchar(50),
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
