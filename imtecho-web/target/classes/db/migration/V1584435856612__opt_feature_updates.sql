
-- opd_member_treatment_history

delete from query_master where code='opd_member_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_member_treatment_history', 'uniqueHealthId,limit,offset', '
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
		    	''result'', roltd.result,
		    	''requestedOn'', roltd.request_on,
		    	''formConfigJson'', sfc.form_config_json
			)
		) as text)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
        left join rch_opd_lab_test_master lab_test_master on lab_test_master.id = roltd.lab_test_id
        left join system_form_configuration sfc on sfc.form_id = lab_test_master.form_id
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
    limit #limit# offset #offset#
', true, 'ACTIVE', 'OPD Member Treatment History');

-- register_opd_patient

delete from query_master where code='register_opd_patient';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'register_opd_patient', 'memberId,registrationDate,healthInfrastructureId,loggedInUserId', '
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, health_infra_id, created_by, created_on, modified_by, modified_on)
    VALUES
    (#memberId#, ''#registrationDate#'', #healthInfrastructureId#, #loggedInUserId#, now(), #loggedInUserId#, now());
', false, 'ACTIVE', 'Register OPD Patient');

-- add column in rch_opd_member_registration

alter table rch_opd_member_registration
drop column if exists health_infra_id,
add column health_infra_id integer;

-- opd_search_by_member_id

delete from query_master where code='opd_search_by_member_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_member_id', 'uniqueHealthId,offSet,limit', '
    select
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.id as "memberId",
    imt_family.family_id as "familyId",
    imt_family.location_id as "locationId",
    imt_family.area_id as "areaId",
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
    where imt_member.unique_health_id in (''#uniqueHealthId#'')
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Member ID');


-- retrieve_opd_registered_patients

delete from query_master where code='retrieve_opd_registered_patients';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_registered_patients', 'userId', '
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
    where cast(romr.registration_date as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romr.registration_date
', true, 'ACTIVE', 'Retrieve OPD Registered Patients');


-- retrieve_opd_patients_for_medicines

delete from query_master where code='retrieve_opd_patients_for_medicines';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_patients_for_medicines', 'userId', '
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
    where cast(romm.medicines_given_on as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romm.medicines_given_on
', true, 'ACTIVE', 'Retrieve OPD Patients for Medicines');


-- opd_search_by_opd_member_registration_id

delete from query_master where code='opd_search_by_opd_member_registration_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_opd_member_registration_id', 'opdMemberRegistrationId,userId', '
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
    and cast(romr.registration_date as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
', true, 'ACTIVE', 'OPD Search By OPD Member Registration ID');


-- opd_search_by_opd_member_master_id

delete from query_master where code='opd_search_by_opd_member_master_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_opd_member_master_id', 'opdMemberMasterId,userId', '
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
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
', true, 'ACTIVE', 'OPD Search By OPD Member Master ID');

