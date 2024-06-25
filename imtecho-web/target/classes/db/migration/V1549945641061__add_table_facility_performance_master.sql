DROP TABLE IF EXISTS public.facility_performance_master;
CREATE TABLE public.facility_performance_master(
id bigserial,
health_infrastrucutre_id bigint, 
performance_date date,
no_of_opd_attended integer,
no_of_ipd_attended integer,
no_of_deliveres_conducted integer,
no_of_csection_conducted integer,
no_of_major_operation_conducted integer,
no_of_minor_operation_conducted integer,
no_of_laboratory_test_conducted integer,
created_by bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT facility_performance_master_pkey PRIMARY KEY (id)
);