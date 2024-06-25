
-- retrieve_covid_19_travellers_count

delete from query_master where code='retrieve_covid_19_travellers_count';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_covid_19_travellers_count', 'locationId,isFromImmigration', '
    select
    count(*) as "totalCount",
    count(*) FILTER (WHERE location_id is null) as "pendingCount",
    count(*) FILTER (WHERE location_id is not null) as "completedCount",
    (select name from location_master where id = #locationId#) as "locationName"
    from covid_travellers_info cti
    where cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
    and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
', true, 'ACTIVE', 'Retrieve COVID 19 Travellers Count');


-- retrieve_pending_covid_19_travellers

--delete from query_master where code='retrieve_covid_19_travellers';
delete from query_master where code='retrieve_pending_covid_19_travellers';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_pending_covid_19_travellers', 'limit,offset,locationId,isFromImmigration', '
    select
    cti.*,
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "fullName",
    cast(concat(lm.name, '' ('', lm.english_name, '')'') as text) as "districtName",
    im.unique_health_id as "uniqueHealthId",
    im.family_id as "familyId",
    im.mobile_number as "mobileNumber",
    get_location_hierarchy(if.location_id) as "locationHierarchy"
    from covid_travellers_info cti
    left join imt_member im on im.id = cti.member_id
    left join imt_family if on im.family_id = if.family_id
    left join location_master lm on lm.id = cti.district_id
    where cti.location_id is null
    and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
    and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
    order by
        case
            when (cti.health_status is null or health_status = '''') then 3
            when (cti.health_status ilike ''%normal%'') then 2
            else 1
        end asc
    limit #limit# offset #offset#
', true, 'ACTIVE', 'Retrieve Pending COVID 19 Travellers');


-- retrieve_updated_covid_19_travellers

delete from query_master where code='retrieve_updated_covid_19_travellers';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_updated_covid_19_travellers', 'limit,offset,locationId,isFromImmigration', '
    select
    cti.*,
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "fullName",
    cast(concat(lm.name, '' ('', lm.english_name, '')'') as text) as "districtName",
    im.unique_health_id as "uniqueHealthId",
    im.family_id as "familyId",
    im.mobile_number as "mobileNumber",
    get_location_hierarchy(if.location_id) as "locationHierarchy"
    from covid_travellers_info cti
    left join imt_member im on im.id = cti.member_id
    left join imt_family if on im.family_id = if.family_id
    left join location_master lm on lm.id = cti.district_id
    where cti.location_id is not null
    and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
    and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
    order by
        case
            when (cti.health_status is null or health_status = '''') then 3
            when (cti.health_status ilike ''%normal%'') then 2
            else 1
        end asc
    limit #limit# offset #offset#
', true, 'ACTIVE', 'Retrieve Updated COVID 19 Travellers');

