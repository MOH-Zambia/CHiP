DROP TABLE IF EXISTS mytecho_family;
CREATE TABLE mytecho_family(
id bigserial,
hof_id bigint,
address character varying(255),
created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT mytecho_family_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS mytecho_member;
CREATE TABLE mytecho_member(
id bigserial,
family_id bigint,
first_name text NOT NULL,
middle_name text,
last_name text NOT NULL,
mobile_number text NOT NULL,
gender character varying(1) NOT NULL,
dob date,
lmp_date date,
is_pregnant boolean,
created_by bigint NOT NULL,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT mytecho_member_pkey PRIMARY KEY (id)
);

