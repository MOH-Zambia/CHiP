-- for feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3059

drop table if exists location_wards;
create table location_wards (
    id serial primary key,
    ward_name varchar(255),
    lgd_code varchar(255),
    location_id integer,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null,
    constraint unique_lgd_code UNIQUE (lgd_code)
);

drop table if exists location_wards_mapping;
create table location_wards_mapping (
    id serial primary key,
    ward_id integer,
    location_id integer
);