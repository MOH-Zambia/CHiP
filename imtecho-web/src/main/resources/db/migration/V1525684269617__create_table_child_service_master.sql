CREATE TABLE if not exists rch_child_service_master
(
    id bigserial,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    location_id bigint NOT NULL,
    location_hierarchy_id bigint NOT NULL,
    notification_id bigint,
    is_alive boolean,
    place_of_death char varying(100),
    weight real,
    ifa_syrup_given boolean,
    complementary_feeding_started boolean,
    is_treatement_done char varying(100),
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_child_service_death_reason_rel
(
    child_service_id bigint NOT NULL,
    child_death_reason bigint NOT NULL,
    PRIMARY KEY (child_service_id, child_death_reason),
    FOREIGN KEY (child_service_id)
        REFERENCES rch_child_service_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_child_service_diseases_rel
(
    child_service_id bigint NOT NULL,
    diseases bigint NOT NULL,
    PRIMARY KEY (child_service_id, diseases),
    FOREIGN KEY (child_service_id)
        REFERENCES rch_child_service_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);