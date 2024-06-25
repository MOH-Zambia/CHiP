DELETE FROM QUERY_MASTER WHERE CODE='loaction_ward_uphc_retrieval';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f14a8828-17e2-4226-978f-2033dc74bad4', 75398,  current_date , 75398,  current_date , 'loaction_ward_uphc_retrieval', 
'level,locationType,wardId,parentId', 
'select
    m.id,
    m.name,
    t.type as "typeCode",
    t.name as "type",
    m.parent as "areaParentId"
    from location_hierchy_closer_det c
    inner join location_type_master t on t.type = c.child_loc_type
    inner join location_master m on m.id = c.child_id
    left join location_wards_mapping lwm on lwm.location_id = m.id
    where t.level=#level#
    and t.type=#locationType#
    and parent_id=#parentId#
    and (lwm.ward_id is null or (lwm.ward_id is not null and lwm.ward_id=#wardId#))
    order by depth', 
'Location Ward UPHC Retrieval', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='location_ward_retrieval_by_lgd_code';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5c2c9044-d8d0-4a20-909e-05942f1e3b6d', 75398,  current_date , 75398,  current_date , 'location_ward_retrieval_by_lgd_code', 
'lgdCode,id', 
'SELECT
    id,
    ward_name,
    lgd_code,
    location_id
    FROM location_wards
    WHERE
    lgd_code = #lgdCode#
    and id != #id#;', 
'Retrieve Location Ward By LGD Code', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='location_ward_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f821d4ed-686f-446a-b34a-b123d2e85a5d', 75398,  current_date , 75398,  current_date , 'location_ward_update', 
'wardName,lgdCode,locationId,wardNameEnglish,loggedInUserId,id', 
'UPDATE location_wards
    SET
    "ward_name"=#wardName#, ward_name_english=#wardNameEnglish#, lgd_code=#lgdCode#, location_id=#locationId#, modified_by=#loggedInUserId#, modified_on=now()
    WHERE id=#id#;', 
'Update Location Ward', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='location_ward_create';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8dd72b0b-7ff6-4f72-bd26-2189daada164', 75398,  current_date , 75398,  current_date , 'location_ward_create', 
'wardName,lgdCode,locationId,wardNameEnglish,loggedInUserId', 
'INSERT INTO location_wards(
    ward_name, ward_name_english, lgd_code, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        #wardName#, #wardNameEnglish#, #lgdCode#, #locationId#, #loggedInUserId#, now(), #loggedInUserId#, now()
    ) returning id;', 
'Create Location Ward', 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_location_by_rch_code_and_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'41376d68-1f45-4994-8272-852044b4f374', 75398,  current_date , 75398,  current_date , 'retrieve_rch_location_by_rch_code_and_type', 
'rchCode,type,anmolId', 
'select
    *
from
    anmol_location_master
where
    (case
        when #type# in (''S'') and type in (''S'') then true
        when #type# in (''D'', ''C'') and type in (''D'') then true
        when #type# in (''B'', ''Z'') and type in (''T'') then true
        when #type# in (''P'') and type in (''F'') then true
        when #type# in (''U'') and type in (''FU'') then true
        when #type# in (''SC'', ''ANM'') and type in (''SF'') then true
        when #type# in (''V'', ''ANG'') and type in (''V'') then true
        else false
    end)
    and rch_code = #rchCode#
    and (id != #anmolId# or #anmolId# = null);', 
'Retrieve RCH Location By RCH Code And Type', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_rch_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'395041f9-e6f6-43a0-ad6c-9065a4a9229b', 75398,  current_date , 75398,  current_date , 'update_rch_location', 
'anmId,newRchCode,locationId,updateParentRchCodeInMapping,newParentRchCode,locationLevel,oldRchCode,loggedInUserId,ashaId,anmolType', 
'begin;

    -- update rch_code in anmol_location_master (in current and child locations)

    UPDATE
    anmol_location_master
    SET
    rch_code = #newRchCode#,
    parent_rch_code = case when #updateParentRchCodeInMapping# = true then #newParentRchCode# else parent_rch_code end,
    asha_id = cast(case when #locationLevel# = 7 then #ashaId# else null end as numeric),
    anm_id = cast(case when #locationLevel# = 7 then #anmId# else null end as numeric),
    modified_by = #loggedInUserId#,
    modified_on = now()
    where rch_code = #oldRchCode#
    and type = #anmolType#;

    UPDATE
    anmol_location_master
    SET
    parent_rch_code=#newRchCode#,
    modified_by = #loggedInUserId#,
    modified_on = now()
    where parent_rch_code = #oldRchCode#
    and parent_type = #anmolType#;

    -- update rch_code in anmol_location_mapping

    UPDATE
    anmol_location_mapping
    set
        state_code = case when #locationLevel# = 1 then cast(#newRchCode# as integer) else state_code end,
        district_code = case when #locationLevel# = 3 then #newRchCode# else district_code end,
        taluka_code = case when #locationLevel# = 4 then #newRchCode# else taluka_code end,
        health_facility_code = case when #locationLevel# = 5 then cast(#newRchCode# as integer)  else health_facility_code end,
        health_subfacility_code = case when #locationLevel# = 6 then cast(#newRchCode# as integer) else health_subfacility_code end,
        village_code = case when #locationLevel# = 7 then #newRchCode# else village_code end,
        asha_id = case when #locationLevel# = 7 then #ashaId# else asha_id end,
        anm_id = case when #locationLevel# = 7 then #anmId# else anm_id end,
        modified_by = #loggedInUserId#,
        modified_on = now()
    WHERE
    case
        when #locationLevel# = 1 then state_code = cast(#oldRchCode# as integer)
        when #locationLevel# = 3 then district_code = #oldRchCode#
        when #locationLevel# = 4 then taluka_code = ''#oldRchCode#''
        when #locationLevel# = 5 then health_facility_code = cast(#oldRchCode# as integer)
        when #locationLevel# = 6 then health_subfacility_code = cast(#oldRchCode# as integer)
        when #locationLevel# = 7 then village_code = #oldRchCode#
        else false
    end;

    -- update parent rch_code in anmol_location_mapping if updateParentRchCodeInMapping flag is true

    UPDATE
    anmol_location_mapping
    set
        state_code = case when #locationLevel# = 3 then cast(#newParentRchCode# as integer) else state_code end,
        district_code = case when #locationLevel# = 4 then #newParentRchCode# else district_code end,
        taluka_code = case when #locationLevel# = 5 then #newParentRchCode# else taluka_code end,
        health_facility_code = case when #locationLevel# = 6 then cast(#newParentRchCode# as integer) else health_facility_code end,
        health_subfacility_code = case when #locationLevel# = 7 then cast(#newParentRchCode# as integer) else health_subfacility_code end,
        modified_by = #loggedInUserId#,
        modified_on = now()
    WHERE
    #updateParentRchCodeInMapping# = true
    and case
            when #locationLevel# = 1 then state_code = cast(#oldRchCode# as integer)
            when #locationLevel# = 3 then district_code = #oldRchCode#
            when #locationLevel# = 4 then taluka_code = #oldRchCode#
            when #locationLevel# = 5 then health_facility_code = cast(#oldRchCode# as integer)
            when #locationLevel# = 6 then health_subfacility_code = cast(#oldRchCode# as integer)
            when #locationLevel# = 7 then village_code = #oldRchCode#
            else false
        end;

    -- update location_master

    UPDATE
    location_master
    SET
    rch_code= cast(#newRchCode# as bigint), 
    modified_by = #loggedInUserId#,
    modified_on = now()
    WHERE id=#locationId#;

    commit;', 
'Update RCH Location', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_rch_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dc8e6c67-f21e-4d2b-86bb-37e023afaccf', 75398,  current_date , 75398,  current_date , 'insert_rch_location', 
'englishName,anmId,techoLocationType,parentRchCode,locationId,name,locationLevel,rchCode,techoParentLocationType,loggedInUserId,ashaId', 
'begin;

    -- insert record in anmol_location_master

    insert
	into
	anmol_location_master ("name", english_name, "type", techo_location_type, rch_code, parent_type, techo_parent_location_type, parent_rch_code, asha_id, anm_id, created_by, created_on, modified_by, modified_on)
	values (
	    #name#,
	    #englishName#,
		case
			when #locationLevel# = 1 then ''S''
			when #locationLevel# = 3 then ''D''
			when #locationLevel# = 4 then ''T''
			when #locationLevel# = 5 and #techoLocationType# = ''P'' then ''F''
			when #locationLevel# = 5 and #techoLocationType# = ''U'' then ''FU''
			when #locationLevel# = 6 then ''SF''
			when #locationLevel# = 7 then ''V''
			else null
		end,
		#techoLocationType#,
		#rchCode#,
		case
			when #locationLevel# = 1 then ''''
			when #locationLevel# = 3 then ''S''
			when #locationLevel# = 4 then ''D''
			when #locationLevel# = 5 then ''T''
			when #locationLevel# = 6 and #techoParentLocationType# = ''P'' then ''F''
			when #locationLevel# = 6 and #techoParentLocationType# = ''U'' then ''FU''
			when #locationLevel# = 7 then ''SF''
			else null
		end,
		#techoParentLocationType#,
		#parentRchCode#,
        cast(case
            when #locationLevel# = 7 then #ashaId#
            else null
        end as numeric),
        cast(case
            when #locationLevel# = 7 then #anmId#
            else null
        end as numeric),
        #loggedInUserId#,
        now(),
        #loggedInUserId#,
        now()
    );

    -- update location_master

    UPDATE
    location_master
    SET
    rch_code = cast(#rchCode# as bigint),
    modified_by = #loggedInUserId#,
    modified_on = now()
    WHERE id = #locationId#;

    commit;', 
'Insert RCH Location', 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_user_for_health_approval';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fa8c87a4-4db6-4420-a783-63a669f64109', 75398,  current_date , 75398,  current_date , 'retrieve_user_for_health_approval', 
'state', 
'select * from soh_user where state = #state#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='delete_all_lab_test_by_health_infra_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dd049419-5646-4856-a0ea-d2b1c42371c8', 75398,  current_date , 75398,  current_date , 'delete_all_lab_test_by_health_infra_id', 
'type,health_infra_id', 
'delete
from
	health_infrastructure_lab_test_mapping
where
	health_infra_id = #health_infra_id# and permission_type = #type#;', 
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
        no_of_beds=#noOfBeds#,
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


DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_create';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'04c7681c-516f-4431-9cc3-fc584e3feebc', 75398,  current_date , 75398,  current_date , 'health_infrastructure_create', 
'issncu,isfru,ispmjy,mobilenumber,isCovidLab,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isCovidHospital,isbalsaka,isMaYojna,nin,postalcode,contactNumber,email,longitude,isNoReportingUnit,address,isbloodbank,isIdsp,noOfPpe,nameinenglish,iscpconfirmationcenter,iscmtc,contactPersonName,createdBy,locationid,landlinenumber,ishwc,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme', 
'with insert_health_infrastructure as (
        INSERT
        INTO
        health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd, is_hwc, is_idsp,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy, address, latitude,
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician,
            postal_code, landline_number, mobile_number, email,contact_person_name,contact_number, name_in_english, is_cpconfirmationcenter, created_by, created_on, state,
            modified_on, modified_by, is_balsakha1, is_balsakha3, is_usg_facility, is_referral_facility, is_ma_yojna, is_npcb, is_no_reporting_unit, no_of_beds,
            is_covid_hospital, is_covid_lab, no_of_ppe
        )
        VALUES (
            #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
            #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#, #latitude#,
            #longitude#, #nin#, cast(#emamtaid# as bigint), #isbloodbank#, #isgynaec#, #ispediatrician#,
            #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
            now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, cast(#noOfBeds# as integer),
            #isCovidHospital#, #isCovidLab#, cast(#noOfPpe# as integer)
        )
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
        (select id from insert_health_infrastructure), ''CREATE'', #type#, #name#, #locationid#, #isnrc#, #iscmtc#, #isfru#, #issncu#, #forncd#, #ishwc#, #isIdsp#,
        #ischiranjeevischeme#, #isbalsaka#, #ispmjy#, #address#, #latitude#,
        #longitude#, #nin#, cast(#emamtaid# as bigint), #isbloodbank#, #isgynaec#, #ispediatrician#,
        #postalcode#, #landlinenumber#, #mobilenumber#, #email#,#contactPersonName#,#contactNumber#, #nameinenglish#, #iscpconfirmationcenter#, #createdBy#, now(), ''ACTIVE'',
        now(), #createdBy#, #isBalsakha1#, #isBalsakha3#, #isUsgFacility#, #isReferralFacility#, #isMaYojna#, #isNpcb#, #isNoReportingUnit#, cast(#noOfBeds# as integer),
        #isCovidHospital#, #isCovidLab#, cast(#noOfPpe# as integer)
    )
    returning health_infrastructure_details_id as id;', 
'Create Health Infrastructure', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='get_service_by_service_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8e220db1-036a-4b7a-8db6-b264b0296734', 75398,  current_date , 75398,  current_date , 'get_service_by_service_date', 
'fromDate,locationId,toDate', 
'with services_by_dates as(
	select 
	sum(case when geo_location_state = ''CORRECT'' then 1 else 0 end) as correct, 
        sum(case when geo_location_state = ''INCORRECT'' then 1 else 0 end) as incorrect,
        sum(case when geo_location_state = ''NOT_FOUND'' or geo_location_state is null then 1 else 0 end) as notfound,
        to_char(ser.service_date,''yyyy-MM-dd'') as service_date_temp
	from rch_member_services_last_90_days ser, location_hierchy_closer_det lh 
	where 
	ser.service_date between  #fromDate# and #toDate#  
       and ser.latitude is not null and ser.latitude != ''0.0'' 
        and service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'') and 
	lh.child_id = ser.location_id  
	and lh.parent_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id=#locationId# and depth = 1)
	group by service_date_temp order by service_date_temp
)
select to_char(to_date(service_date_temp,''yyyy-MM-dd''),''dd-Mon(Dy)'' ) as service_date_view,*
from services_by_dates', 
null, 
true, 'ACTIVE');