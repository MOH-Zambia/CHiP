DELETE FROM QUERY_MASTER WHERE CODE='update_gvk_covid_104_calls_response';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6b6ce8f1-ff78-45b9-bc39-f5979f91db1d', 75398,  current_date , 75398,  current_date , 'update_gvk_covid_104_calls_response', 
'feverDays,country,address,dateOfCalling,gender,isInformationCall,travelAbroad,coughDays,arrivalDate,personName,inTouchWithAnyone,hasFever,pinCode,district,block,modifiedBy,hasShortnessOfBreath,id,village,havingCough,age,contactNo', 
'update gvk_covid_104_calls_response
set date_of_calling = #dateOfCalling#,
person_name = #personName#,
age = #age#,
gender = #gender#,
contact_no = #contactNo#,
address = #address#,
pin_code = #pinCode#,
district = #district#,
block = #block#,
village = #village#,
is_information_call = #isInformationCall#,
has_fever = #hasFever#,
fever_days = #feverDays#,
having_cough = #havingCough#,
cough_days = #coughDays#,
has_shortness_of_breath = #hasShortnessOfBreath#,
has_travel_abroad_in_15_days = #travelAbroad#,
country = #country#,
arrival_date = #arrivalDate#,
in_touch_with_anyone_travelled_recently = #inTouchWithAnyone#,
modified_by = #modifiedBy#,
modified_on = now()
where id = #id#;
delete from gvk_covid_104_calls_contact_response where gvk_response_id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_gvk_covid_104_calls_response';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ec8b8f99-538b-4998-a83f-042da76481d6', 75398,  current_date , 75398,  current_date , 'insert_gvk_covid_104_calls_response', 
'feverDays,country,address,dateOfCalling,gender,isInformationCall,travelAbroad,coughDays,arrivalDate,personName,inTouchWithAnyone,hasFever,createdBy,pinCode,district,block,modifiedBy,hasShortnessOfBreath,village,havingCough,age,contactNo', 
'insert into gvk_covid_104_calls_response
(date_of_calling,person_name,age,gender,contact_no,address,pin_code,district,block,village,
is_information_call,has_fever,fever_days,having_cough,cough_days,has_shortness_of_breath,has_travel_abroad_in_15_days,
country,arrival_date,in_touch_with_anyone_travelled_recently,created_by,created_on,modified_by,modified_on)
values(#dateOfCalling#,#personName#,#age#,#gender#,#contactNo#,#address#,#pinCode#,#district#,#block#,#village#,
#isInformationCall#,#hasFever#,#feverDays#,#havingCough#,#coughDays#,#hasShortnessOfBreath#,#travelAbroad#,
#country#, #arrivalDate#,#inTouchWithAnyone#,#createdBy#,now(),#modifiedBy#,now())
returning id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_gvk_covid_104_calls_contact_response';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8e8bfd6a-3f77-480f-9d82-695daed72522', 75398,  current_date , 75398,  current_date , 'insert_gvk_covid_104_calls_contact_response', 
'personName,gvkId,otherDetails,district,contactNo', 
'insert into gvk_covid_104_calls_contact_response
(gvk_response_id,person_name,contact_no,district,other_detail)
values(#gvkId#,
#personName#,
#contactNo#,
#district#,
#otherDetails#);', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_beneficary_detail_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6fd0996e-92b3-402a-8de2-0300bf3c436c', 75398,  current_date , 75398,  current_date , 'covid19_get_beneficary_detail_by_id', 
'id', 
'with travel_history as(
select
json_agg(json_build_object(''id'',cct.id
,''travelDate'',to_char(cct.treavel_date,''DD/MM/YYYY'')
,''placeOfOrigin'',cct.place_of_origin
,''destination'',cct.destination
,''modeOfTransport'',cct.mode_of_transport
,''flightNo'',cct.flight_no
,''flightSeatNo'',cct.flight_seat_no
,''isFromOtherCountry'',cct.is_another_country
,''otherTransportDetails'',cct.other_detail
,''purposeOfTravel'',cct.purpose_of_travel
,''trainNo'',cct.train_no
,''trainSeatNo'',cct.train_seat_no
,''busDetail'',cct.bus_detail
,''travelAgencyDetail'',cct.travel_agency_detail
,''travelAgencyDetail'',cct.travel_agency_detail
)) as travel_history
from covid_case_travel_history cct
where cct.contact_person_id = #id#
),contact_person as (
select
json_agg(json_build_object(''id'',ccch.id
,''contactDate'',to_char(ccch.contact_date,''DD/MM/YYYY'')
,''name'',ccch.person_name
,''otherDetails'',ccch.other_detail
,''address'',ccch.address
,''contactNo'',ccch.contact_no
,''location'',(select name from location_master where id = ccch.location_id)
)) as contact_person
from covid_case_contact_history ccch
where ccch.parent_id = #id#
)
select cch.id,cch.person_name as name,cch.age,cch.gender,cch.contact_no,cch.address,cch.health_state as state,cch.parent_id,cch.level
,cch.location_id as "locationId",get_location_hierarchy(cch.location_id) as "location"
,(select cast(travel_history as text) from travel_history) as travel_history
,(select cast(contact_person as text) from contact_person) as contact_person
from covid_case_contact_history cch
where cch.id=#id#;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_contatct_tracing_update_beneficary_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'428e2c3f-25e4-4c7a-8f22-77f686af67b1', 75398,  current_date , 75398,  current_date , 'covid19_contatct_tracing_update_beneficary_detail', 
'address,gender,contact_no,name,modified_by,location,state,id,age', 
'update covid_case_contact_history
set person_name =#name# ,
age =#age# ,
gender =#gender# ,
contact_no =#contact_no# ,
address =#address# ,
health_state = #state#,
location_id=#location#,
modified_on = now() ,
modified_by =  #modified_by#
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_contact_tracing_insert_beneficary_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3e23b4b1-9e35-4ca7-8829-383d88f96f37', 75398,  current_date , 75398,  current_date , 'covid19_contact_tracing_insert_beneficary_data', 
'address,gender,contact_no,name,location,state,loggedInUserId,age', 
'insert into covid_case_contact_history(person_name,age,gender,contact_no,address,health_state,state, location_id,created_by, created_on, modified_on, modified_by,level)
values(
#name#, #age#,
#gender#, #contact_no#, #address#,  #state#,''PENDING'', #location#,
#loggedInUserId#,now(), now(), #loggedInUserId#,0
)
returning id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_save_travel_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f03cc64a-ddf2-41cd-a639-0a8773fd665e', 75398,  current_date , 75398,  current_date , 'covid19_save_travel_history', 
'destination,train_seat_no,contact_person_id,loggedInUserId,flight_seat_no,purpose_of_travel,place_of_origin,mode_of_transport,flight_no,bus_detail,isFromOtherCountry,train_no,treavel_date,travel_agency_detail,other_detail', 
'INSERT INTO covid_case_travel_history 
(contact_person_id
, place_of_origin
, destination
, mode_of_transport
, flight_no
, flight_seat_no
, train_no
, train_seat_no
, bus_detail
, travel_agency_detail
, purpose_of_travel
, treavel_date
, other_detail
,is_another_country
, created_by
, created_on
, modified_by
, modified_on) 
VALUES(#contact_person_id# 
,(case when #place_of_origin# = ''null'' then null else #place_of_origin# end) 
,(case when #destination# = ''null'' then null else #destination# end) 
,(case when #mode_of_transport# = ''null'' then null else #mode_of_transport# end) 
,(case when #flight_no# = ''null'' then null else #flight_no# end) 
,(case when #flight_seat_no# = ''null'' then null else #flight_seat_no# end) 
,(case when #train_no# = ''null'' then null else #train_no# end) 
,(case when #train_seat_no# = ''null'' then null else #train_seat_no# end) 
,(case when #bus_detail# = ''null'' then null else #bus_detail# end) 
,(case when #travel_agency_detail# = ''null'' then null else #travel_agency_detail# end) 
,(case when #purpose_of_travel# = ''null'' then null else #purpose_of_travel# end) 
,#treavel_date# 
,(case when #other_detail# = ''null'' then null else #other_detail# end) 
,#isFromOtherCountry#
,#loggedInUserId#
, now() 
,#loggedInUserId#
,now()) returning id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_contact_tracing_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'55881043-672c-4e49-b75b-3f909d16f285', 75398,  current_date , 75398,  current_date , 'covid19_insert_contact_tracing_detail', 
'address,contact_no,contactDate,name,location,loggedInUserId,contact_id,other_detail', 
'insert into covid_case_contact_history(person_name,contact_no,address,other_detail,health_state,state,location_id,created_by, created_on, modified_on, modified_by,parent_id,contact_date)
values(
(case when #name# = null then null else #name# end)
,(case when #contact_no# = null then null else #contact_no# end)
,(case when #address# = null then null else #address# end)
,(case when #other_detail# = null then null else #other_detail# end)
,''Suspected''
,''PENDING''
,(case when #location# = null then null else #location# end)
,#loggedInUserId#
, now()
, now()
, #loggedInUserId#
,(case when #contact_id# = null then null else #contact_id# end)
,#contactDate#
)
returning id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='area_level_location_search_for_web';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2493316-969b-4609-a5e9-e850d0221be9', 75398,  current_date , 75398,  current_date , 'area_level_location_search_for_web', 
'locationString', 
'select loc.id,string_agg(l.name,''>'' order by lhcd.depth desc) as "hierarchy"
    from location_master loc
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = loc.id
    inner join location_master l on l.id = lhcd.parent_id
    where (loc.name ilike concat(''%'',#locationString#,''%'') or loc.english_name ilike concat(''%'',#locationString#,''%'')) and loc.type in (''A'',''AA'')
    group by loc.id, loc.name
    limit 50;', 
'Area Level Location Search for selectize', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_location_and_create_imt_member_of_covid_19_traveller';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'860dbac6-e3ab-47ec-ab16-efdca2723004', 75398,  current_date , 75398,  current_date , 'update_location_and_create_imt_member_of_covid_19_traveller', 
'isOutOfState,address,locationId,dob,loggedInUserId,id', 
'begin;

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = #address#,
    is_out_of_state = #isOutOfState#,
    is_active = true,
    tracking_start_date = now(),
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- create notification

    INSERT INTO techo_notification_master (
        notification_type_id, notification_code, location_id,
        member_id, schedule_date, expiry_date,
        state, created_by, created_on, modified_by, modified_on
    )
    select (select id from notification_type_master where name = ''Travellers Screening Alert''),
    row_number() OVER () as rnum, location_id, id,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as sched_date,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as exp_date, ''PENDING'',
    ''-1'', now(), ''-1'', now() from covid_travellers_info ct
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id > 0 and location_id is not null;

    -- create record of imt_member and imt_family

    with get_asha_area_id as (
        select
        case
            when parent_loc_type in (''A'',''AA'') then parent_id
            when parent_loc_type in (''V'',''ANG'') then child_id
        end as location_id
        from location_hierchy_closer_det
        where parent_id = #locationId#
        limit 1
    ),
    insert_imt_family as (
        INSERT INTO imt_family (address1, area_id, caste, created_on, family_id, religion, location_id, state, basic_state, created_by, modified_by, modified_on)
        select
        #address# as address, (select location_id from get_asha_area_id) as area_id, ''627'' as caste, now() as created_on, ''FM/'' || date_part(''YEAR'', NOW()) || ''/'' || nextval(''family_id_seq'') || ''N'' as family_id,
        ''640'' as religion, (select case when type in (''A'',''AA'') then parent else id end from location_master where id = #locationId#) as location_id,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, #loggedInUserId#, #loggedInUserId#, now()
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning family_id
    ),
    insert_imt_member as (
        INSERT INTO imt_member(unique_health_id, first_name, dob, gender, state, basic_state, created_by, created_on, modified_by, modified_on, family_head, family_id)
        select ''A'' || nextval(''member_unique_health_id_seq'') || ''N'' as unique_health_id, cti.name as first_name, #dob# as dob,
        case
            when cti.gender ilike ''m'' or cti.gender ilike ''male'' then ''M''
            when cti.gender ilike ''f'' or cti.gender ilike ''female'' then ''F''
            else ''OTHER''
        end as gender,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, #loggedInUserId#, now(), #loggedInUserId#, now(), true, (select family_id from insert_imt_family)
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning id
    ),
    update_covid_travellers_info as (
        update covid_travellers_info
        set member_id = (select id from insert_imt_member)
        where id = #id# and member_id is null
    )
    update
    imt_family
    set hof_id  = (select id from insert_imt_member)
    where family_id = (select family_id from insert_imt_family);

    commit;', 
'Update Location and Insert Imt Member/Family of COVID 19 Traveller', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_location_and_create_imt_member_of_covid_19_non_contactable_traveller';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c628ece0-4094-4d01-adf6-83d6990b4a3d', 75398,  current_date , 75398,  current_date , 'update_location_and_create_imt_member_of_covid_19_non_contactable_traveller', 
'isOutOfState,address,locationId,dob,loggedInUserId,id', 
'begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = #address#,
    is_out_of_state = #isOutOfState#,
    is_active = true,
    tracking_start_date = now(),
    is_update_location = false,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    -- create new notifications

    INSERT INTO techo_notification_master (
        notification_type_id, notification_code, location_id,
        member_id, schedule_date, expiry_date,
        state, created_by, created_on, modified_by, modified_on
    )
    select (select id from notification_type_master where name = ''Travellers Screening Alert''),
    row_number() OVER () as rnum, location_id, id,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as sched_date,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as exp_date, ''PENDING'',
    ''-1'', now(), ''-1'', now() from covid_travellers_info ct
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id is not null and location_id > 0;

    -- create record of imt_member and imt_family

    with get_asha_area_id as (
        select
        case
            when parent_loc_type in (''A'',''AA'') then parent_id
            when parent_loc_type in (''V'',''ANG'') then child_id
        end as location_id
        from location_hierchy_closer_det
        where parent_id = #locationId#
        limit 1
    ),
    insert_imt_family as (
        INSERT INTO imt_family (address1, area_id, caste, created_on, family_id, religion, location_id, state, basic_state, created_by, modified_by, modified_on)
        select
        #address# as address, (select location_id from get_asha_area_id) as area_id, ''627'' as caste, now() as created_on, ''FM/'' || date_part(''YEAR'', NOW()) || ''/'' || nextval(''family_id_seq'') || ''N'' as family_id,
        ''640'' as religion, (select case when type in (''A'',''AA'') then parent else id end from location_master where id = #locationId#) as location_id,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, #loggedInUserId#, #loggedInUserId#, now()
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning family_id
    ),
    insert_imt_member as (
        INSERT INTO imt_member(unique_health_id, first_name, dob, gender, state, basic_state, created_by, created_on, modified_by, modified_on, family_head, family_id)
        select ''A'' || nextval(''member_unique_health_id_seq'') || ''N'' as unique_health_id, cti.name as first_name, #dob# as dob,
        case
            when cti.gender ilike ''m'' or cti.gender ilike ''male'' then ''M''
            when cti.gender ilike ''f'' or cti.gender ilike ''female'' then ''F''
            else ''OTHER''
        end as gender,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, #loggedInUserId#, now(), #loggedInUserId#, now(), true, (select family_id from insert_imt_family)
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning id
    ),
    update_covid_travellers_info as (
        update covid_travellers_info
        set member_id = (select id from insert_imt_member)
        where id = #id# and member_id is null
    )
    update
    imt_family
    set hof_id  = (select id from insert_imt_member)
    where family_id = (select family_id from insert_imt_family);

    commit;', 
'Update Location and Create IMT Member/Family of COVID 19 Non-Contactable Traveller', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_location_of_covid_19_traveller';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd0813502-d6ae-4f14-a83c-d287cbdaa09d', 75398,  current_date , 75398,  current_date , 'update_location_of_covid_19_traveller', 
'isOutOfState,address,districtId,locationId,loggedInUserId,id', 
'-- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = #address#,
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    is_active = true,
    tracking_start_date = now(),
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;', 
'Update Location of COVID 19 Traveller', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_location_of_covid_19_non_contactable_traveller';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'35f296bf-de3b-4e70-b24d-46e5ffe54ac3', 75398,  current_date , 75398,  current_date , 'update_location_of_covid_19_non_contactable_traveller', 
'isOutOfState,address,districtId,locationId,loggedInUserId,id', 
'begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = #address#,
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    is_active = true,
    tracking_start_date = now(),
    is_update_location = true,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    commit;', 
'Update Location of COVID 19 Non-Contactable Traveller', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_location_not_found_of_covid_19_traveller';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'93efe83f-2bb1-4a7b-9bce-6774dea092c7', 75398,  current_date , 75398,  current_date , 'update_location_not_found_of_covid_19_traveller', 
'reason,loggedInUserId,id', 
'begin;

    -- update location

    update covid_travellers_info
    set location_id = -1,
    is_update_location = true,
    update_location_reason = ''OTHER'',
    other_update_location_reason = #reason#,
    update_location_source_type = ''WEB'',
    is_active = false,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    commit;', 
'Update Location Not Found of COVID 19 Non-Contactable Traveller', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_ward_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ac6d4d72-fc3d-4b31-9660-e7095bee136b', 75398,  current_date , 75398,  current_date , 'covid19_get_ward_detail', 
'loggedInUserId', 
'select ward.id,ward_name
from health_infrastructure_ward_details ward 
where ward.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi 
	where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_admission_by_health_infra_and_case_no';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'21403fb9-4924-4606-bb1f-d49e968eec47', 75398,  current_date , 75398,  current_date , 'covid19_get_admission_by_health_infra_and_case_no', 
'loggedInUserId,caseNo', 
'with health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id 
from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
)
select concat_ws('' '',first_name, middle_name,last_name,''is already register with same indoor case no. Please enter new indoor case number'') as "resultMsg"
from covid19_admission_detail where health_infra_id in (select id from health_infra_det) 
and case_no = #caseNo# limit 1', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_covid19_new_admission_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6b262f1a-c954-46ac-abae-a76051a2975c', 75398,  current_date , 75398,  current_date , 'update_covid19_new_admission_detail', 
'inContactWithCovid19Paitent,otherCoMobidity,firstname,indications,occupation,gender,bed_no,date_of_onset_symptom,isHypertension,isRenalCondition,emergencyContactNo,isHeartPatient,isOtherCoMobidity,abroad_contact_details,flightno,referFromHosital,opdCaseNo,contact_no,admission_date,case_number,isImmunocompromized,address,unitno,ward_no,emergencyContactName,isSari,hasCough,pregnancy_status,middlename,travelHistory,loggedInUserId,isCOPD,travelledPlace,lastname,isMalignancy,hasShortnessBreath,isMigrant,hasFever,isHIV,otherIndications,districtLocationId,is_abroad_in_contact,admissionId,isDiabetes,age,ageMonth', 
'update covid19_admission_detail set
first_name =#firstname#,
middle_name =(case when #middlename# = null then null else #middlename# end),
last_name =(case when #lastname# = null then null else #lastname# end),
age =(case when #age# = null then  age else  #age# end)
,age_month =(case when #ageMonth# = null then  age_month else  #ageMonth# end),
contact_number =(case when #contact_no# = null then null else #contact_no# end),
address =(case when #address# = null then null else #address# end),
gender =(case when #gender# = null then null else #gender# end),
flight_no =(case when #flightno# = null then null else #flightno# end),
refer_from_hospital =(case when #referFromHosital# = null then null else #referFromHosital# end),
case_no =(case when #case_number# = null then null else #case_number# end),
unit_no =(case when #unitno# = null then null else #unitno# end),
is_cough =#hasCough#,
is_fever =#hasFever#,
is_breathlessness =#hasShortnessBreath#,
location_id =#districtLocationId#,
current_ward_id =#ward_no#,
current_bed_no =#bed_no#,
admission_date =#admission_date#,
admission_entry_by =#loggedInUserId#,
admission_entry_on =now(),
is_hiv = #isHIV#,
is_heart_patient =#isHeartPatient#,
is_diabetes =#isDiabetes#,
status =''CONFORMED'',
health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE''),
emergency_contact_name =(case when #emergencyContactName# = null then null else #emergencyContactName# end),
emergency_contact_no =(case when #emergencyContactNo# = null then null else #emergencyContactNo# end),
is_immunocompromized =#isImmunocompromized#,
is_hypertension =#isHypertension#,
is_malignancy =#isMalignancy#,
is_renal_condition =#isRenalCondition#,
is_copd =#isCOPD#,
pregnancy_status =(case when #pregnancy_status# = null then null else #pregnancy_status# end),
date_of_onset_symptom =(case when #date_of_onset_symptom# = null then null else to_date(#date_of_onset_symptom#,''MM-DD-YYYY'') end),
occupation =(case when #occupation# = null then null else #occupation# end),
travel_history =(case when #travelHistory# = null then null else #travelHistory# end),
travelled_place =(case when #travelledPlace# = null then null else #travelledPlace# end),
is_abroad_in_contact =(case when #is_abroad_in_contact# = null then null else #is_abroad_in_contact# end),
abroad_contact_details =(case when #abroad_contact_details# = null then null else #abroad_contact_details# end),
in_contact_with_covid19_paitent =(case when #inContactWithCovid19Paitent# = null then null else #inContactWithCovid19Paitent# end),
opd_case_no =(case when #opdCaseNo# = null then null else #opdCaseNo# end),
is_other_co_mobidity =#isOtherCoMobidity#,
other_co_mobidity =(case when #otherCoMobidity# = null then null else #otherCoMobidity# end),
is_sari =#isSari#,
indications =(case when #indications# = null then null else #indications# end),
indication_other =(case when #otherIndications# = null then null else #otherIndications# end),
is_migrant =#isMigrant#
where id=#admissionId#;', 
null, 
false, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='covid19_addmitted_case_daily_status_insert_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'407bd0ba-a73c-498f-8fde-dc1f5cd6e04b', 75398,  current_date , 75398,  current_date , 'covid19_addmitted_case_daily_status_insert_data', 
'otherCoMobidity,temprature,isSerum,isECG,serviceDate,cTScanImpression,G6PDImpression,ventilatorType2,ventilatorType1,isHypertension,serumCreatinineImpression,isG6PD,hydroxychloroquine,bedNumber,bpDialostic,memberId,isImmunocompromized,onAir,h1N1TestImpression,sp02,azithromycin,isSGPT,wardId,loggedInUserId,isCOPD,hasShortnessBreath,healthStatus,xRAYImpression,antibiotics,isRenalCondition,isHeartPatient,isOtherCoMobidity,respirationRate,isH1N1,locationId,onO2,bloodCultureImpression,isXray,bpSystolic,isSari,sGPTImpression,hasCough,eCGImpression,isMalignancy,isBlood,hasFever,onVentilator,isHIV,pulseRate,admissionId,oseltamivir,isDiabetes,clinicallyCured,remarks,isCtScan', 
'with insert_daily_check_up as (
insert into covid19_admitted_case_daily_status(member_id,
location_id,
admission_id,
service_date,
ward_id,
bed_no,
health_status,
on_ventilator,
ventilator_type1,
ventilator_type2,
on_o2,
on_air,
clinically_clear,
remarks,
created_by,
created_on,

temperature,   
pulse_rate,
bp_systolic,
bp_dialostic,
respiration_rate,
spo2,

azithromycin,
hydroxychloroquine,
oseltamivir,
antibiotics,

is_xray,
xray_detail,
is_ctscan,
ct_scan_detail,
is_ecg,
ecg_detail,
is_serum_creatinine,
serum_creatinine_detail,
is_sgpt,
sgpt_detail,
is_h1n1_test,
h1n1_test_detail,
blood_culture,
blood_culture_detail,
is_g6pd,
g6pd_detail)
values(
#memberId#,
#locationId#,
#admissionId#,
#serviceDate#
,#wardId#
,(case when #bedNumber# = null then null else #bedNumber# end)
,#healthStatus#
, #onVentilator#
,#ventilatorType1#
,#ventilatorType2#
,#onO2#
,#onAir#
,#clinicallyCured#
,#remarks#
,#loggedInUserId#
,now()

,#temprature#,
#pulseRate#,
#bpSystolic#,
#bpDialostic#,
#respirationRate#,
#sp02#,

#azithromycin#,
#hydroxychloroquine#,
#oseltamivir#,
#antibiotics#,

#isXray#,
(case when #xRAYImpression# = null then null else #xRAYImpression# end),
#isCtScan#,
(case when #cTScanImpression# = null then null else #cTScanImpression# end),
#isECG#,
(case when #eCGImpression# = null then null else #eCGImpression# end),
#isSerum#,
(case when #serumCreatinineImpression# = null then null else #serumCreatinineImpression# end),
#isSGPT# ,
(case when #sGPTImpression# = null then null else #sGPTImpression# end),
#isH1N1#,
(case when #h1N1TestImpression# = null then null else #h1N1TestImpression# end),
#isBlood#,
(case when #bloodCultureImpression# = null then null else #bloodCultureImpression# end),
#isG6PD#,
(case when #G6PDImpression# = null then null else #G6PDImpression# end)
)
returning id
)
update covid19_admission_detail cad set current_ward_id = #wardId#
, current_bed_no = (case when #bedNumber# = null then null else  #bedNumber# end)
, last_check_up_detail_id = (select id from insert_daily_check_up),
is_cough=#hasCough#,
is_fever=#hasFever#,
is_breathlessness=#hasShortnessBreath#,
is_sari=#isSari#,
is_copd=#isCOPD#,
is_diabetes=#isDiabetes#,
is_hiv=#isHIV#,
is_heart_patient=#isHeartPatient#,
is_hypertension=#isHypertension#,
is_renal_condition=#isRenalCondition#,
is_immunocompromized=#isImmunocompromized#,
is_malignancy=#isMalignancy#,
is_other_co_mobidity=#isOtherCoMobidity#,
other_co_mobidity= (case when #otherCoMobidity# = null then null else  #otherCoMobidity# end)
where id = #admissionId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_update_admitted_patients_det_for_editing';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'88043cfc-5c58-4830-b157-be687977ebda', 75398,  current_date , 75398,  current_date , 'covid19_update_admitted_patients_det_for_editing', 
'is_copd,is_hypertension,firstname,indications,occupation,gender,refer_from_hospital,date_of_onset_symptom,other_co_mobidity,is_breathlessness,emergency_contact_name,location_id,abroad_contact_details,emergency_contact_no,flight_no,travel_history,admission_date,is_diabetes,is_malignancy,health_status,is_fever,is_cough,pincode,case_no,address,is_sari,pregnancy_status,is_other_co_mobidity,middlename,current_bed_no,is_immunocompromized,contact_number,is_hiv,lastname,is_renal_condition,isMigrant,travelled_place,is_heart_patient,otherIndications,unit_no,is_abroad_in_contact,admissionId,opd_case_no,in_contact_with_covid19_paitent,age,current_ward_id,ageMonth', 
'begin;
update covid19_admission_detail
set
first_name = case when #firstname# != null then #firstname# else null end,
middle_name = case when #middlename# != null then #middlename# else null end,
last_name = case when #lastname# != null then #lastname# else null end,
address = case when #address# != null then #address# else null end,
pincode = #pincode#,
occupation = case when #occupation# != null then #occupation# else null end,
travel_history = case when #travel_history# != null then #travel_history# else null end,
travelled_place = case when #travelled_place# != null then #travelled_place# else null end,
flight_no = case when #flight_no# != null then #flight_no# else null end,
is_abroad_in_contact = case when #is_abroad_in_contact# != null then #is_abroad_in_contact# else null end,
in_contact_with_covid19_paitent = case when #in_contact_with_covid19_paitent# != null then #in_contact_with_covid19_paitent# else null end,
abroad_contact_details = case when #abroad_contact_details# != null then #abroad_contact_details# else null end,
admission_date = #admission_date#,
case_no = case when #case_no# != null then #case_no# else null end ,
opd_case_no = case when #opd_case_no# != null then #opd_case_no# else null end,
contact_number = case when #contact_number# != null then #contact_number# else null end,
gender = case when #gender# != null then #gender# else null end,
pregnancy_status = case when #pregnancy_status# != null then #pregnancy_status# else null end,
age = #age#,
is_fever = #is_fever#,
is_cough = #is_cough#,
is_breathlessness = #is_breathlessness#,
is_sari = #is_sari#,
is_hiv = #is_hiv#,
is_heart_patient = #is_heart_patient#,
is_diabetes = #is_diabetes#,
is_copd = #is_copd#,
is_hypertension = #is_hypertension#,
is_renal_condition = #is_renal_condition#,
is_immunocompromized = #is_immunocompromized#,
is_malignancy = #is_malignancy#,
is_other_co_mobidity = #is_other_co_mobidity#,
other_co_mobidity = case when #other_co_mobidity# != null then #other_co_mobidity# else null end,
indications = case when #indications# != null then #indications# else null end,
date_of_onset_symptom = (case when #date_of_onset_symptom# = null then null else to_date(#date_of_onset_symptom#,''MM-DD-YYYY'') end),
refer_from_hospital = case when #refer_from_hospital# != null then #refer_from_hospital# else null end,
current_bed_no = case when #current_bed_no# != null then #current_bed_no# else null end,
unit_no = case when #unit_no# != null then #unit_no# else null end,
emergency_contact_name = case when #emergency_contact_name# != null then #emergency_contact_name# else null end,
emergency_contact_no = case when #emergency_contact_no# != null then #emergency_contact_no# else null end,
current_ward_id = #current_ward_id#,
is_migrant=#isMigrant#,
age_month=case when #ageMonth# = null then age_month else #ageMonth#  end,
indication_other=case when #otherIndications# != null then #otherIndications# else null end,
location_id = #location_id#
where id = #admissionId#;

update covid19_admitted_case_daily_status
set 
location_id = #location_id#,
health_status = case when #health_status# != null then #health_status# else null end 
where admission_id = #admissionId#;

commit;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_admission_discharge';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b50326fd-d508-439e-b172-f4049630d843', 75398,  current_date , 75398,  current_date , 'covid19_admission_discharge', 
'admissionStatus,tohealthInfraId,dischargeRemark,referralState,dischargeDate,admissionId,loggedInUserId,deathCause', 
'with health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
),
refer_to_helth_infra as(
insert into covid19_admission_refer_detail (admission_id, refer_from_health_infra_id,refer_to_health_infra_id,state,status, created_by,created_on)
select #admissionId#, (select id from health_infra_det), #tohealthInfraId#, #referralState#,#admissionStatus#, #loggedInUserId#, now() 
)
update covid19_admission_detail set status = #admissionStatus#,
discharge_date = #dischargeDate#,
discharge_status = #admissionStatus#,
discharge_entry_by =#loggedInUserId#,
discharge_entry_on =now(),
discharge_remark=#dischargeRemark#,
death_cause = #deathCause#
where id = #admissionId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_refer_in_admit';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2f063e77-c1c0-4fa3-86cd-ca0e69791b47', 75398,  current_date , 75398,  current_date , 'covid19_refer_in_admit', 
'inContactWithCovid19Paitent,admissionDate,unitNo,travelHistory,loggedInUserId,wardId,travelledPlace,caseNo,abroad_contact_details,flightno,opdCaseNo,bedNo,is_abroad_in_contact,admissionId,id', 
'update covid19_admission_refer_detail card set
old_ward_id = cad.current_ward_id,
old_admission_date = cad.admission_date,
old_case_no = cad.case_no,
old_opd_case_no = cad.opd_case_no,
old_unit_no = cad.unit_no,
old_bed_no = cad.current_bed_no,
state=''COMPLETED'',
modified_by=#loggedInUserId#,
modified_on=now()
from covid19_admission_detail cad
where card.admission_id= cad.id and card.id = #id#;

update covid19_admission_detail set 
current_ward_id = #wardId#,
current_bed_no=#bedNo#,
unit_no = #unitNo#,
case_no = #caseNo#,
opd_case_no = #opdCaseNo#,
health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE''),
status = ''CONFORMED'',
admission_date=#admissionDate#,
travel_history = #travelHistory#,
travelled_place = #travelledPlace#,
is_abroad_in_contact = #is_abroad_in_contact#,
abroad_contact_details = #abroad_contact_details#,
in_contact_with_covid19_paitent = #inContactWithCovid19Paitent#,
flight_no = #flightno#
where id = #admissionId#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_covid19_new_admission_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8201f0fd-c01a-4610-ae0d-1a32e3e782b1', 75398,  current_date , 75398,  current_date , 'insert_covid19_new_admission_detail', 
'otherCoMobidity,indications,occupation,isHypertension,emergencyContactNo,abroad_contact_details,referFromHosital,opdCaseNo,admission_date,contact_no,case_number,health_status,memberId,isImmunocompromized,unitno,pregnancy_status,loggedInUserId,isCOPD,travelledPlace,lastname,hasShortnessBreath,pinCode,is_abroad_in_contact,inContactWithCovid19Paitent,firstname,gender,bed_no,date_of_onset_symptom,isRenalCondition,isHeartPatient,isOtherCoMobidity,flightno,locationId,member_id,address,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,middlename,travelHistory,isMalignancy,isMigrant,covid19_lab_test_recommendation_id,hasFever,isHIV,otherIndications,districtLocationId,isDiabetes,age,ageMonth', 
'with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id 
),health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#districtLocationId#,(select id from generated_id),#admission_date#,#ward_no#,#bed_no#,#health_status#,#loggedInUserId#,now())
returning id
),insert_lab_test as (
INSERT INTO covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, (select id from generated_id),''COLLECTION_PENDING'',#loggedInUserId#,now(), (select id from health_infra_det))
returning id
),update_lab_test_recommdation as (
update covid19_lab_test_recommendation set admission_id = (select id from generated_id)
where id = #covid19_lab_test_recommendation_id#
)
insert into covid19_admission_detail 
(id,
member_id,
first_name,
middle_name,
last_name,
age,
age_month,
contact_number,
address,
gender,
flight_no,
refer_from_hospital,

case_no,
unit_no,

is_cough,
is_fever,
is_breathlessness,
location_id,
covid19_lab_test_recommendation_id,
last_lab_test_id,
last_check_up_detail_id,
health_infra_id,
current_ward_id,
current_bed_no,
admission_status_id,
admission_date,
admission_entry_by,
admission_entry_on,
is_hiv,
is_heart_patient,
is_diabetes,
admission_from,
status,
pincode,
emergency_contact_name,
emergency_contact_no,
is_immunocompromized,
is_hypertension,
is_malignancy,
is_renal_condition,
is_copd,
pregnancy_status,
date_of_onset_symptom,
occupation,
travel_history,
travelled_place,
is_abroad_in_contact,
abroad_contact_details,

in_contact_with_covid19_paitent,
opd_case_no,
is_other_co_mobidity,
other_co_mobidity,
is_sari,
indications,
indication_other,
is_migrant
)
values(
(select id from generated_id)
,#member_id#
,#firstname#
,(case when #middlename# = null then null else #middlename# end)
,(case when #lastname# = null then null else #lastname# end)
,#age#
,#ageMonth#
,(case when #contact_no# = null then null else #contact_no# end)
,(case when #address# = null then null else #address# end)
,(case when #gender# = null then null else #gender# end)
,(case when #flightno# = null then null else #flightno# end)
,(case when #referFromHosital# = null then null else #referFromHosital# end)

,(case when #case_number# = null then null else #case_number# end)
,(case when #unitno# = null then null else #unitno# end)
,#hasCough#
,#hasFever#
,#hasShortnessBreath#
,#districtLocationId#
,#covid19_lab_test_recommendation_id#
,(select id from insert_lab_test)
,(select id from insert_daily_admission_det)
,(select id from health_infra_det)
,#ward_no#
,#bed_no#
,(select id from insert_daily_admission_det)
,#admission_date#
,#loggedIn_user#
,now()
,#isHIV#
,#isHeartPatient#
,#isDiabetes#
,''NEW''
,''SUSPECT''
,(case when #pinCode# = null then null else #pinCode# end)
,(case when #emergencyContactName# = null then null else #emergencyContactName# end)
,(case when #emergencyContactNo# = null then null else #emergencyContactNo# end)
,#isImmunocompromized#
,#isHypertension#
,#isMalignancy#
,#isRenalCondition#
,#isCOPD#
,(case when #pregnancy_status# = null then null else #pregnancy_status# end)
,(case when #date_of_onset_symptom# = null then null else to_date(#date_of_onset_symptom#,''MM-DD-YYYY'') end)
,(case when #occupation# = null then null else #occupation# end)
,(case when #travelHistory# = null then null else #travelHistory# end)
,(case when #travelledPlace# = null then null else #travelledPlace# end)
,(case when #is_abroad_in_contact# = null then null else #is_abroad_in_contact# end)
,(case when #abroad_contact_details# = null then null else #abroad_contact_details# end)

,(case when #inContactWithCovid19Paitent# = null then null else #inContactWithCovid19Paitent# end)
,(case when #opdCaseNo# = null then null else #opdCaseNo# end)
,#isOtherCoMobidity#
,(case when #otherCoMobidity# = null then null else #otherCoMobidity# end)
,#isSari#
,(case when #indications# = null then null else #indications# end)
,(case when #otherIndications# = null then null else #otherIndications# end)
,#isMigrant#
)
RETURNING id;', 
'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI 
JSON as input paramter', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_covid19_lab_test_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'09460a16-a5a6-4003-8a05-1456b4d0e5c4', 75398,  current_date , 75398,  current_date , 'insert_covid19_lab_test_detail', 
'locationId,admissionId,loggedInUserId,memberId', 
'with insert_lab_test_detail as (
INSERT INTO covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, #admissionId#,''COLLECTION_PENDING'',#loggedInUserId#,now(),(select health_infra_id from covid19_admission_detail where id  = #admissionId#))
returning id
)
update covid19_admission_detail set last_lab_test_id = (select id from insert_lab_test_detail)
where id = #admissionId#;', 
null, 
false, 'ACTIVE');