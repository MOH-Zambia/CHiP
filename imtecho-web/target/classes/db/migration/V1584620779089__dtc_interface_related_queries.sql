
-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3383

insert into menu_group(group_name, active, group_type)
select 'COVID-19', true, 'manage'
where not exists (select id from menu_group where group_name = 'COVID-19' and group_type = 'manage');

insert into menu_config(menu_name, menu_type, active, navigation_state, feature_json, group_id)
select 'DTC Interface', 'manage', TRUE, 'techo.manage.dtcInterface', '{}', id
from menu_group
where group_name = 'COVID-19' and group_type = 'manage' and
not exists (select id from menu_config where menu_name = 'DTC Interface' and menu_type = 'manage');

-- retrieve_covid_19_travellers

delete from query_master where code='retrieve_covid_19_travellers';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_covid_19_travellers', 'limit,offset,locationId', '
    select
    cti.*,
    cast(concat(lm.name, '' ('', lm.english_name, '')'') as text) as  "districtName"
    from covid_travellers_info cti
    left join location_master lm on lm.id = cti.district_id
    where cti.location_id is null
    and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
    limit #limit# offset #offset#
', true, 'ACTIVE', 'Retrieve COVID 19 Travellers');

--

delete from query_master where code='update_location_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_of_covid_19_traveller', 'id,locationId', '
    update covid_travellers_info
    set location_id = #locationId#
    where id = #id#
', false, 'ACTIVE', 'Update Location of COVID 19 Traveller');

--

CREATE TABLE if not exists covid_travellers_info (
    id serial primary key,
    name text,
    address text,
    pincode integer,
    location_id integer,
    member_id integer,
    mobile_number character varying(10),
    is_active boolean,
    flight_no text,
    age integer,
    gender varchar(50),
    country varchar(100),
    district_id integer,
    date_of_departure timestamp without time zone,
    date_of_receipt timestamp without time zone,
    health_status varchar(50),
    observation text,
    symptoms text,
    created_by int,
    created_on timestamp without time zone,
    modified_by int,
    modified_on timestamp without time zone
);