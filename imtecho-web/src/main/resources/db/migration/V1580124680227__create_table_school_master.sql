-- Add menu for feature of manage schools
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3036

drop table if exists school_master;
create table school_master (
    id serial primary key,
    name varchar(255),
    code varchar(255),
    grant_type integer,
    school_type integer,
    is_primary_school boolean,
    is_higher_secondary_school boolean,
    is_madresa boolean,
    is_gurukul boolean,
    no_of_teachers integer,
    principal_name varchar(255),
    contact_person_name varchar(255),
    contact_number varchar(21),
    child_male_1_to_5 integer,
    child_female_1_to_5 integer,
    child_male_6_to_8 integer,
    child_female_6_to_8 integer,
    child_male_9_to_10 integer,
    child_female_9_to_10 integer,
    child_male_11_to_12 integer,
    child_female_11_to_12 integer,
    rbsk_team_id varchar(255),
    location_id integer,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);
