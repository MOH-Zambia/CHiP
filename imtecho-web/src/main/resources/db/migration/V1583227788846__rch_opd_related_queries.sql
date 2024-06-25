-- By Smeet --

drop table if exists rch_opd_member_master;
drop table if exists rch_opd_lab_test_provisional_rel;
drop table if exists rch_opd_lab_test_details;
drop table if exists rch_opd_edl_details;
drop table if exists rch_opd_lab_test_master;

create table rch_opd_member_master
(
  id serial primary key,
  member_id integer NOT NULL,
  health_infra_id integer not null,
  service_date timestamp without time zone NOT NULL,
  medicines_given_on timestamp without time zone NOT NULL,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer NOT NULL,
  modified_on timestamp without time zone NOT NULL
);

create table rch_opd_lab_test_provisional_rel
(
  opd_member_master_id integer not null,
  provisional_id integer not null,
  CONSTRAINT rch_opd_lab_test_provisional_rel_pkey PRIMARY KEY (opd_member_master_id, provisional_id)
);

create TABLE rch_opd_lab_test_details
(
  id serial primary key,
  member_id integer NOT NULL,
  opd_member_master_id integer NOT NULL,
  lab_test_id integer NOT NULL,
  status character varying(55),
  request_on timestamp without time zone NOT NULL,
  completed_on timestamp without time zone,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer NOT NULL,
  modified_on timestamp without time zone NOT NULL,
  result text
);

create TABLE rch_opd_edl_details
(
  id serial primary key,
  member_id integer NOT NULL,
  opd_member_master_id integer NOT NULL,
  edl_id integer NOT NULL,
  frequency numeric(6, 2),
  quantity_before_food numeric(6, 2),
  quantity_after_food numeric(6, 2),
  number_of_days numeric(6, 2),
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer NOT NULL,
  modified_on timestamp without time zone NOT NULL
);

-- opd_search_by_member_id

delete from query_master where code='opd_search_by_member_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_member_id', 'offSet,limit,uniqueHealthId', '
    with maxDeliveryDateOfMember as (
		select
		rwmm.member_id,
		max(rwmm.date_of_delivery) as max_delivery_date
		from
		rch_wpd_mother_master rwmm
		where
		rwmm.member_id in (select id from imt_member im where unique_health_id in (''#uniqueHealthId#''))
		and rwmm.has_delivery_happened is true
		group by rwmm.member_id
	)
    select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber",
    im.is_pregnant as "isPregnant",
    cast(mddom.max_delivery_date as date) as "lastDeliveryDate",
    case
		when mddom.max_delivery_date is null then false
		when current_date - cast(mddom.max_delivery_date as date) <= 45 then true
		else false
	end as "hasDeliveryHappenedInLast45Days",
	case
		when nmdd1.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd1.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd1.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "hypertensionStatus",
	case
		when nmdd2.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd2.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd2.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "diabetesStatus"
    from imt_member im
    inner join imt_family if on im.family_id = if.family_id
    left join um_user_location uul1 on uul1.loc_id = if.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = if.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    left join maxDeliveryDateOfMember mddom on mddom.member_id = im.id
    left join ncd_member_diseases_diagnosis nmdd1 on nmdd1.member_id = im.id and nmdd1.disease_code = ''HT''
    left join ncd_member_diseases_diagnosis nmdd2 on nmdd2.member_id = im.id and nmdd2.disease_code = ''D''
    where im.unique_health_id in (''#uniqueHealthId#'')
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Member ID');


-- opd_search_by_family_id

delete from query_master where code='opd_search_by_family_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_family_id', 'familyId,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_family.family_id in (''#familyId#'')
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Family ID');


-- opd_search_by_location_id

delete from query_master where code='opd_search_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_location_id', 'offSet,locationId,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Location ID');


-- opd_search_by_mobile_number

delete from query_master where code='opd_search_by_mobile_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_mobile_number', 'offSet,mobileNumber,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_member.mobile_number = ''#mobileNumber#''
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Mobile Number');


-- opd_search_by_pmjay_number

delete from query_master where code='opd_search_by_pmjay_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_pmjay_number', 'pmjayNumber,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_member_cfhc_master on imt_member.id = imt_member_cfhc_master.member_id
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_member_cfhc_master.pmjay_number = ''#pmjayNumber#''
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By PMJAY Number');


-- opd_search_by_ration_number

delete from query_master where code='opd_search_by_ration_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_ration_number', 'rationNumber,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_family.ration_card_number = ''#rationNumber#''
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Ration Number');


-- opd_search_by_maa_vatsalya_number

delete from query_master where code='opd_search_by_maa_vatsalya_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_maa_vatsalya_number', 'maavatsalyaNumber,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_family.maa_vatsalya_number = ''#maavatsalyaNumber#''
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By MAA Vatsalya Number');


-- opd_search_by_dob

delete from query_master where code='opd_search_by_dob';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_dob', 'dob,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.location_id as "locationId",
    get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from imt_member
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imt_member.dob = cast(''#dob#'' as date)
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By DOB');


-- retrieve_opd_lab_tests_by_health_infrastructure

delete from query_master where code='retrieve_opd_lab_tests_by_health_infrastructure';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_lab_tests_by_health_infrastructure', 'healthInfrastructureId,healthInfrastructureType,categories,type', '
    select
    case when ''#type#'' = ''OPD_CATEGORY'' then listvalue_field_value_detail.id else null end as "categoryId",
    case when ''#type#'' = ''OPD_CATEGORY'' then listvalue_field_value_detail.value else null end as "categoryName",
    case when ''#type#'' = ''OPD_LAB_TEST'' then rch_opd_lab_test_master.id else null end as "labTestId",
    case when ''#type#'' = ''OPD_LAB_TEST'' then rch_opd_lab_test_master.name else null end as "labTestName"
    from health_infrastructure_lab_test_mapping
    left join listvalue_field_value_detail on ''#type#'' = ''OPD_CATEGORY''
    and health_infrastructure_lab_test_mapping.ref_id = listvalue_field_value_detail.id
    left join rch_opd_lab_test_master on ''#type#'' = ''OPD_LAB_TEST''
    and health_infrastructure_lab_test_mapping.ref_id = rch_opd_lab_test_master.id
    where
    case
        when (select count(*) from health_infrastructure_lab_test_mapping where health_infra_id = #healthInfrastructureId#) > 0 then health_infra_id = #healthInfrastructureId#
        else health_infra_type = #healthInfrastructureType#
    end
    and permission_type = ''#type#''
    and case
            when ''#type#'' = ''OPD_LAB_TEST'' then ref_id in (select id from rch_opd_lab_test_master where category in (#categories#) and is_active)
            else true
         end;
', true, 'ACTIVE', 'Retrieve OPD Lab Tests By Health Infrastructure');

-- by Monika --

drop table if exists health_infrastructure_lab_test_mapping;
drop table if exists rch_opd_lab_test_master;
delete from query_master where code='insert_in_health_infra_lab_test_mapping';
delete from query_master where code='insert_lab_test_for_selected_infra_type';
delete from query_master where code='delete_all_lab_test_by_health_infra_id';
delete from query_master where code='get_lab_test_details_by_id';
delete from query_master where code='get_lab_test';
delete from query_master where code='get_all_lab_test';
delete from query_master where code='update_opd_lab_test_state';
delete from query_master where code='fetch_form_details';
delete from form_master where code = 'opd_lab_test';
delete from listvalue_field_value_detail where field_key = 'opd_lab_test_category';
delete from listvalue_field_master where field_key = 'opd_lab_test_category';
delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'Manage OPD Lab Test');
delete from menu_config where menu_name = 'Manage OPD Lab Test';
delete from menu_group where group_name = 'Manage OPD';
delete from query_master where code='delete_lab_test_mapping_by_type';
delete from query_master where code='fetch_health_infra_lab_test_mapping';

--

insert
	into
		form_master( code, name, state, created_by, created_on, modified_by, modified_on )
	values( 'opd_lab_test', 'OPD Lab Test', 'ACTIVE',- 1, current_date,- 1, current_date );

--

insert
	into
		listvalue_field_master( field_key, field, is_active, field_type, form )
	values( 'opd_lab_test_category', 'OPD Lab Test Category', true, 'T', 'opd_lab_test' );

--

insert
	into
		listvalue_field_value_detail( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size )
	values
	    ( true, false,- 1, current_date, 'Clinical Pathology', 'opd_lab_test_category', 0 ),
	    ( true, false,- 1, current_date, 'Urine Analysis', 'opd_lab_test_category', 0 ),
	    ( true, false,- 1, current_date, 'Biochemistry', 'opd_lab_test_category', 0 ),
	    ( true, false,- 1, current_date, 'Microbiology', 'opd_lab_test_category', 0 ),
	    ( true, false,- 1, current_date, 'Radiology', 'opd_lab_test_category', 0 ),
	    ( true, false,- 1, current_date, 'Cardiology', 'opd_lab_test_category', 0 );

--

insert into menu_group(group_name, active, group_type) values ('Manage OPD', true, 'admin');

--

insert into menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)
select 'Manage OPD Lab Test','admin',TRUE,'techo.manage.manageOpdLabTest','{}',id from menu_group where group_name = 'Manage OPD' and group_type = 'admin';

--

create TABLE rch_opd_lab_test_master
(
  id serial primary key,
  form_id integer,
  name character varying(255) not null,
  category integer,
  is_active boolean,
  created_by integer,
  created_on timestamp without time zone NOT NULL,
  modified_on timestamp without time zone NOT NULL,
  modified_by integer
);

--

create table health_infrastructure_lab_test_mapping (
    id serial primary key,
    health_infra_id integer,
    ref_id integer,
    health_infra_type integer,
    permission_type character varying(50)
);

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_lab_test','','
select
	lab_test.id,
	lab_test.name,
	lab_test.category,
	field_value.value as "categoryName",
	lab_test.is_active as "isActive",
	lab_test.form_id as "formId",
	form_master.form_name as "formName"
from
	rch_opd_lab_test_master as "lab_test"
inner join listvalue_field_value_detail as "field_value" on
	lab_test.category = field_value.id
inner join system_form_master as "form_master" on
	lab_test.form_id = form_master.id
where
	lab_test.is_active = true
',true,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_all_lab_test','','
select
	lab_test.id,
	lab_test.name,
	lab_test.category,
	field_value.value as "categoryName",
	lab_test.is_active as "isActive",
	lab_test.form_id as "formId",
	form_master.form_name as "formName"
from
	rch_opd_lab_test_master as "lab_test"
inner join listvalue_field_value_detail as "field_value" on
	lab_test.category = field_value.id
inner join system_form_master as "form_master" on
	lab_test.form_id = form_master.id
',true,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'insert_in_health_infra_lab_test_mapping','health_infra_id,ref_ids,type','
delete
from
	health_infrastructure_lab_test_mapping
where
	health_infra_id = #health_infra_id# and permission_type = ''#type#'';

insert
	into
		health_infrastructure_lab_test_mapping( health_infra_id, ref_id, permission_type )
	values(#health_infra_id#, unnest( array#ref_ids#), ''#type#'' )

',false,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'insert_lab_test_for_selected_infra_type','infraTypeIds,refId,permissionType','
delete
from
	health_infrastructure_lab_test_mapping
where
    health_infra_id is null and
	ref_id = #refId#
	and permission_type = ''#permissionType#'';

 insert
	into
		health_infrastructure_lab_test_mapping( health_infra_type, ref_id, permission_type )
	values ( unnest( array#infraTypeIds#), #refId#, ''#permissionType#'' )
',false,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'delete_all_lab_test_by_health_infra_id','health_infra_id,type','

delete
from
	health_infrastructure_lab_test_mapping
where
	health_infra_id = #health_infra_id# and permission_type = ''#type#'';

',false,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_lab_test_details_by_id','id','
select
	rch_opd_lab_test_master.name,
	rch_opd_lab_test_master.category,
	rch_opd_lab_test_master.is_active,
	rch_opd_lab_test_master.form_id as "formId",
	string_agg(cast(health_infrastructure_lab_test_mapping.health_infra_type as text),'','') as "infraType"
from
	rch_opd_lab_test_master
left join health_infrastructure_lab_test_mapping on
	rch_opd_lab_test_master.id = health_infrastructure_lab_test_mapping.ref_id
where
	rch_opd_lab_test_master.id = #id#
group by rch_opd_lab_test_master.id

',true,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'update_opd_lab_test_state','id,state','
update
	rch_opd_lab_test_master
set
	is_active = #state#
where
	id = #id#
',false,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'fetch_form_details','','
select
	*
from
	system_form_master
',true,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'delete_lab_test_mapping_by_type','labTestId,categoryId','
delete
from
	health_infrastructure_lab_test_mapping
where
    health_infra_id is null and
	ref_id = #labTestId#
	or ref_id = #categoryId#
',false,'ACTIVE');

--

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'fetch_health_infra_lab_test_mapping','healthInfraId,healthInfraType','
select
	*
from
	health_infrastructure_lab_test_mapping
where
	(case when (SELECT COUNT(*) FROM health_infrastructure_lab_test_mapping WHERE health_infra_id = #healthInfraId#) > 0 THEN health_infra_id = #healthInfraId#
	else health_infra_type = #healthInfraType#
	end)
',true,'ACTIVE');


-- by Dhaval --

-- Out-Patient Treatment (OPD) menu_config

insert into menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
select null, true, 'Out-Patient Treatment (OPD)', 'techo.manage.outPatientTreatmentSearch', 'manage', false
WHERE NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name = 'Out-Patient Treatment (OPD)');

-- create table rch_opd_member_registration

drop table if exists rch_opd_member_registration;

create table rch_opd_member_registration
(
  id serial primary key,
  member_id integer NOT NULL,
  registration_date timestamp without time zone NOT NULL,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer NOT NULL,
  modified_on timestamp without time zone NOT NULL
);

-- retrieve_opd_registered_patients

delete from query_master where code='retrieve_opd_registered_patients';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_registered_patients', '', '
    select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    romr.registration_date as "registrationDate"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    where cast(romr.registration_date as date) = current_date
    order by romr.registration_date
', true, 'ACTIVE', 'Retrieve OPD Registered Patients');

-- register_opd_patient

delete from query_master where code='register_opd_patient';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'register_opd_patient', 'memberId,registrationDate,loggedInUserId', '
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, created_by, created_on, modified_by, modified_on)
    VALUES
    (#memberId#, ''#registrationDate#'', #loggedInUserId#, now(), #loggedInUserId#, now());
', false, 'ACTIVE', 'Register OPD Patient');


-- Add key value pair in db for OPD Provisional Diagnosis

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'opd_provisional_diagnosis', 'opdProvisionalDiagnosis', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='opd_provisional_diagnosis');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Test Diagnosis 1', 'opd_provisional_diagnosis', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='opd_provisional_diagnosis' AND value='Test Diagnosis 1');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Test Diagnosis 2', 'opd_provisional_diagnosis', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='opd_provisional_diagnosis' AND value='Test Diagnosis 2');


-- Add key value pair in db for Essential Drugs

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'opd_essential_drugs', 'opdEssentialDrugs', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='opd_essential_drugs');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Test Drug 1', 'opd_essential_drugs', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='opd_essential_drugs' AND value='Test Drug 1');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Test Drug 2', 'opd_essential_drugs', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='opd_essential_drugs' AND value='Test Drug 2');

-- retrieve_opd_patients_for_medicines

delete from query_master where code='retrieve_opd_patients_for_medicines';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_patients_for_medicines', '', '
    select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    romm.id as "opdMemberMasterId",
    romm.health_infra_id as "healthInfraId",
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn"
    from rch_opd_member_master romm
    inner join imt_member im on im.id = romm.member_id
    inner join imt_family if on im.family_id = if.family_id
    where cast(romm.medicines_given_on as date) = current_date
    order by romm.medicines_given_on
', true, 'ACTIVE', 'Retrieve OPD Patients for Medicines');


-- opd_search_by_opd_member_master_id

delete from query_master where code='opd_search_by_opd_member_master_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_opd_member_master_id', 'opdMemberMasterId', '
    with maxDeliveryDateOfMember as (
		select
		rwmm.member_id,
		max(rwmm.date_of_delivery) as max_delivery_date
		from
		rch_wpd_mother_master rwmm
		where
		rwmm.member_id in (select id from imt_member im where unique_health_id in (''#uniqueHealthId#''))
		and rwmm.has_delivery_happened is true
		group by rwmm.member_id
	)
    select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber",
    im.is_pregnant as "isPregnant",
    cast(mddom.max_delivery_date as date) as "lastDeliveryDate",
    case
		when mddom.max_delivery_date is null then false
		when current_date - cast(mddom.max_delivery_date as date) <= 45 then true
		else false
	end as "hasDeliveryHappenedInLast45Days",
	case
		when nmdd1.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd1.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd1.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "hypertensionStatus",
	case
		when nmdd2.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd2.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd2.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "diabetesStatus",
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn",
    hid."name" as "healthInfraName",
    (
    	select
    	string_agg(
    		roltm.name, '', ''
		)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    where roltd.opd_member_master_id = romm.id
    ) as "labTests",
    (
    	select
    	string_agg(
    		lfvd.value, '', ''
		)
	    from listvalue_field_value_detail lfvd
	    inner join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
	    where lfvd.id = roltpr.provisional_id
    ) as "provisionalDiagnosis",
    (
    	select
    	cast(
            json_agg(
                json_build_object(
                    ''id'', roed.id,
                    ''memberId'', roed.member_id,
                    ''opdMemberMasterId'', roed.opd_member_master_id,
                    ''edlId'', roed.edl_id,
                    ''frequency'', cast(roed.frequency as text),
                    ''quantityBeforeFood'', cast(roed.quantity_before_food as text),
                    ''quantityAfterFood'', cast(roed.quantity_after_food as text),
                    ''numberOfDays'', cast(roed.number_of_days as text),
                    ''createdBy'', roed.created_by,
                    ''createdOn'', roed.created_on
                )
		    )
		as text)
	    from rch_opd_edl_details roed
	    where roed.opd_member_master_id = romm.id
    ) as "opdEdlDetails"
	from rch_opd_member_master romm
    inner join imt_member im on romm.member_id = im.id
    inner join imt_family if on im.family_id = if.family_id
    left join um_user_location uul1 on uul1.loc_id = if.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = if.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    left join maxDeliveryDateOfMember mddom on mddom.member_id = im.id
    left join ncd_member_diseases_diagnosis nmdd1 on nmdd1.member_id = im.id and nmdd1.disease_code = ''HT''
    left join ncd_member_diseases_diagnosis nmdd2 on nmdd2.member_id = im.id and nmdd2.disease_code = ''D''
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where romm.id = #opdMemberMasterId#
    and cast(romm.medicines_given_on as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
', true, 'ACTIVE', 'OPD Search By OPD Member Master ID');


-- opd_member_treatment_history

delete from query_master where code='opd_member_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_member_treatment_history', 'uniqueHealthId', '
    select
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn",
    hid."name" as "healthInfraName",
    (
    	select
    	string_agg(
    		roltm.name, '', ''
		)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    where roltd.opd_member_master_id = romm.id
    ) as "labTests",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''name'', roltm.name,
		    	''category'', (select value from listvalue_field_value_detail where id = roltm.category),
		    	''result'', roltr.result,
		    	''requestedOn'', roltd.request_on,
		    	''formConfigJson'', sfc.form_config_json
			)
		) as text)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    left join rch_opd_lab_test_results roltr on roltr.lab_test_details_id = roltd.id
	    left join system_form_configuration sfc on sfc.form_id = roltd.lab_test_id
	    where roltd.opd_member_master_id = romm.id
    ) as "labTestResults",
    (
    	select
    	string_agg(
    		lfvd.value, '', ''
		)
	    from listvalue_field_value_detail lfvd
	    inner join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
	    where lfvd.id = roltpr.provisional_id
    ) as "provisionalDiagnosis",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''id'', roed.id,
		    	''memberId'', roed.member_id,
		    	''opdMemberMasterId'', roed.opd_member_master_id,
		    	''edlName'', (select value from listvalue_field_value_detail where id = roed.edl_id),
	    		''frequency'', cast(roed.frequency as text),
	    		''quantityBeforeFood'', cast(roed.quantity_before_food as text),
	    		''quantityAfterFood'', cast(roed.quantity_after_food as text),
	    		''numberOfDays'', cast(roed.number_of_days as text)
			)
		) as text)
	    from rch_opd_edl_details roed
	    where roed.opd_member_master_id = romm.id
    ) as "opdEdlDetails",
    concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "treatmentDoneBy"
    from rch_opd_member_master romm
    inner join imt_member im on romm.member_id = im.id
    inner join um_user uu on romm.created_by = uu.id
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where im.unique_health_id in (''#uniqueHealthId#'')
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    order by romm.service_date desc
', true, 'ACTIVE', 'OPD Member Treatment History');
