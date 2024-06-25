CREATE TABLE if not exists rch_vaccine_adverse_effect
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
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    adverse_effect character varying(15),
    vaccine_name character varying(50),
    batch_number character varying(50),
    expiry_date timestamp without time zone NOT NULL,
    manufacturer character varying(50),
    PRIMARY KEY (id)
);