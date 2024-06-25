CREATE TABLE if not exists rch_immunisation_master
(
    id bigserial,
    member_id bigint NOT NULL,
    member_type character varying(10),
    visit_type character varying(50),
    visit_id bigint,
    notification_id bigint,
    immunisation_given character varying(50),
    given_on timestamp without time zone NOT NULL,
    given_by bigint NOT NULL,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);