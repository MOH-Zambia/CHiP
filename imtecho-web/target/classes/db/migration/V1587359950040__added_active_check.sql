DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_opd_member_master_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_by_opd_member_master_id',
'opdMemberMasterId,userId',
'
    with maxDeliveryDateOfMember as (
        select
        rwmm.member_id,
        max(rwmm.date_of_delivery) as max_delivery_date
        from
        rch_wpd_mother_master rwmm
        where
        rwmm.member_id in (select member_id from rch_opd_member_master where id = #opdMemberMasterId#)
        and rwmm.has_delivery_happened is true
        group by rwmm.member_id
    )
    select
    im.id as "memberId",
    im.mobile_number as "mobileNumber",
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
    romm.any_other_state_specific_disease as "anyOtherStateSpecificDisease",
    romm.unusual_syndromes as "unusualSyndromes",
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
    -- and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
',
'OPD Search By OPD Member Master ID',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_opd_member_registration_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_by_opd_member_registration_id',
'opdMemberRegistrationId,userId',
'
    with maxDeliveryDateOfMember as (
		select
		rwmm.member_id,
		max(rwmm.date_of_delivery) as max_delivery_date
		from
		rch_wpd_mother_master rwmm
		where
		rwmm.member_id in (select member_id from rch_opd_member_registration where id = #opdMemberRegistrationId#)
		and rwmm.has_delivery_happened is true
		group by rwmm.member_id
	)
   select
   im.id as "memberId",
   im.unique_health_id as "uniqueHealthId",
   if.family_id as "familyId",
   im.mobile_number as "mobileNumber",
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
	romr.health_infra_id as "healthInfraId",
	hid.name as "healthInfraName",
	hid."type" as "healthInfraType"
	from rch_opd_member_registration romr
   inner join  imt_member im on romr.member_id = im.id
   inner join imt_family if on im.family_id = if.family_id
   left join um_user_location uul1 on uul1.loc_id = if.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = if.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   left join maxDeliveryDateOfMember mddom on mddom.member_id = im.id
   left join ncd_member_diseases_diagnosis nmdd1 on nmdd1.member_id = im.id and nmdd1.disease_code = ''HT''
   left join ncd_member_diseases_diagnosis nmdd2 on nmdd2.member_id = im.id and nmdd2.disease_code = ''D''
   left join health_infrastructure_details hid on hid.id = romr.health_infra_id
   where romr.id = #opdMemberRegistrationId#
   -- and cast(romr.registration_date as date) = current_date
   -- and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'')
   and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
',
'OPD Search By OPD Member Registration ID',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_registered_patients';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_opd_registered_patients',
'fetchPendingOnly,searchDate,userId',
'
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
    romr.id as "opdMemberRegistrationId",
    romr.registration_date as "registrationDate",
    romr.health_infra_id as "healthInfraId",
    hid.name as "healthInfraName"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romr.health_infra_id
    left join rch_opd_member_master romm on romr.id = romm.opd_member_registration_id
    where cast(romr.registration_date as date) = cast(''#searchDate#'' as date)
    and (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romr.registration_date
',
'Retrieve OPD Registered Patients',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_patients_for_medicines';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_opd_patients_for_medicines',
'userId',
'
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
    romm.medicines_given_on as "medicinesGivenOn",
    hid.name as "healthInfraName"
    from rch_opd_member_master romm
    inner join imt_member im on im.id = romm.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where romm.is_medicines_given is not true
    and cast(romm.medicines_given_on as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romm.medicines_given_on
',
'Retrieve OPD Patients for Medicines',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_patients_for_treatment';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_opd_patients_for_treatment',
'fetchPendingOnly,searchDate,userId',
'
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
    romr.id as "opdMemberRegistrationId",
    romr.registration_date as "registrationDate",
    romr.health_infra_id as "healthInfraId",
    hid.name as "healthInfraName"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romr.health_infra_id
    left join rch_opd_member_master romm on romr.id = romm.opd_member_registration_id
    where
        (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    -- and cast(romr.registration_date as date) = cast(''#searchDate#'' as date)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romr.registration_date desc
',
'Retrieve OPD Patients for Treatment',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_assigned_covid_hospitals';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'retrieve_assigned_covid_hospitals',
'userId',
'
    select
    health_infrastructure_details.*,
    get_location_hierarchy(health_infrastructure_details.location_id) as "healthInfraLocation",
    listvalue_field_value_detail.value as "typeOfHosiptalName"
    from health_infrastructure_details
    inner join user_health_infrastructure on health_infrastructure_details.id = user_health_infrastructure.health_infrastrucutre_id
    left join listvalue_field_value_detail on health_infrastructure_details.type = listvalue_field_value_detail.id
    where user_health_infrastructure.user_id = #userId#
    and user_health_infrastructure.state = ''ACTIVE''
    and (health_infrastructure_details.is_covid_hospital or health_infrastructure_details.is_covid_lab)
',
null,
true, 'ACTIVE');
