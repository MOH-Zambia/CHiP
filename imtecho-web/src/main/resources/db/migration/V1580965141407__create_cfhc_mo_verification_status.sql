DROP TABLE if exists cfhc_mo_verification_status;

CREATE TABLE if not exists cfhc_mo_verification_status
(
    id serial primary key,
    member_id integer,
    family_id text,
    location_id integer,
    relationship_with_hof_status boolean,
    fp_method_status boolean,
    chronic_disease_status boolean,
    contact_status boolean,
    dead_status boolean,
    comment text,
    state text,
    created_on timestamp without time zone,
    created_by integer,
    modified_on timestamp without time zone,
    modified_by integer

)