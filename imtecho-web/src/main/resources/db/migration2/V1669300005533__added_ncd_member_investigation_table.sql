DROP TABLE IF EXISTS ncd_member_investigation_detail;
CREATE TABLE IF NOT EXISTS ncd_member_investigation_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    screening_date timestamp without time zone,
    report text,
    type character varying(50),
    health_infra_id integer,
    done_by character varying(50)
);