DROP TABLE IF EXISTS um_drtecho_user;
CREATE TABLE um_drtecho_user(
id bigserial,
user_id bigint,
registration_number text,
medical_council text,
health_facility_id bigint,
health_facility_pincode integer,
health_facility_reg_no text,
state text,
created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT drtecho_user_pkey PRIMARY KEY (id)
);