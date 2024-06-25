DROP TABLE IF EXISTS ncd_visit_history;
CREATE TABLE IF NOT EXISTS ncd_visit_history(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    visit_date timestamp without time zone,
	reference_id integer,
	disease_code character varying(50),
	status character varying(50),
    visit_by character varying(50),
	flag boolean,
	master_id integer
);