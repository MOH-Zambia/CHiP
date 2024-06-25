drop table if exists drtecho_health_facility_reg;
create table drtecho_health_facility_reg (
id bigserial,
health_facility_name text,
health_facility_pincode integer,
health_facility_reg_no text,
state text,
location_id bigint,
health_infrastructure_id bigint,
created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT drtecho_health_facility_reg_pkey PRIMARY KEY (id)
);