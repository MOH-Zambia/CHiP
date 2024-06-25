alter table rch_opd_member_registration
drop column if exists location_id,
add column location_id integer;

alter table rch_opd_member_master
drop column if exists location_id,
add column location_id integer;

--

DELETE FROM QUERY_MASTER WHERE CODE='register_opd_patient';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'register_opd_patient',
'memberId,registrationDate,healthInfrastructureId,loggedInUserId,referenceId,referenceType',
'
    with get_location_id as (
        select
        case
            when if.area_id is not null then if.area_id
            else if.location_id
        end as location_id
        from imt_family if
        inner join imt_member im on im.family_id = if.family_id
        where im.id = #memberId#
    )
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, health_infra_id, created_by, created_on, modified_by, modified_on, reference_id, reference_type, location_id)
    VALUES
    (#memberId#, ''#registrationDate#'', #healthInfrastructureId#, #loggedInUserId#, now(), #loggedInUserId#, now(), #referenceId#, ''#referenceType#'',
        (select location_id from get_location_id)
    );
',
'Register OPD Patient',
false, 'ACTIVE');

--

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
    romr.location_id as "locationId",
	hid.name as "healthInfraName",
	hid."type" as "healthInfraType"
	from rch_opd_member_registration romr
    inner join imt_member im on romr.member_id = im.id
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

-- migration

update rch_opd_member_registration romr
set location_id = (case
	when if.area_id is not null then if.area_id
	else if.location_id
end)
from imt_family if
inner join imt_member im on im.family_id = if.family_id
where im.id = romr.member_id;

update rch_opd_member_master romm
set location_id = (case
	when if.area_id is not null then if.area_id
	else if.location_id
end)
from imt_family if
inner join imt_member im on im.family_id = if.family_id
where im.id = romm.member_id;
