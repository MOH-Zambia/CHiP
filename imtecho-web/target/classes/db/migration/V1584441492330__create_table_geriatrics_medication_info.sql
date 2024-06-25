drop TABLE IF EXISTS geriatrics_medication_info;

create table geriatrics_medication_info (
    id serial primary key,
    under_regular_medications boolean,
    all_medicines_given varchar(20),
    service_date timestamp NOT NULL,

    member_id int NULL,
    family_id int NULL,
    latitude text NULL,
    longitude text NULL,
    mobile_start_date timestamp NULL,
    mobile_end_date timestamp NULL,
    location_id int NULL,
    location_hierarchy_id int NULL,
    notification_id int NULL,

    created_by integer NOT NULL,
    created_on timestamp NOT NULL,
    modified_by integer,
    modified_on timestamp
);