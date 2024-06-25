update system_configuration set key_value = '100' where system_key = 'MOBILE_FORM_VERSION';


insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_RETINOPATHY_TEST', 'NCD_RETINOPATHY_TEST', now(), -1, now(), -1);


insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'NCD_MO_CONFIRMED' from mobile_form_details where form_name = 'NCD_RETINOPATHY_TEST';


insert into listvalue_field_form_relation (field, form_id)
select 'religionList', id
from mobile_form_details where form_name in ('NCD_RETINOPATHY_TEST');

insert into listvalue_field_form_relation (field, form_id)
select 'casteList', id
from mobile_form_details where form_name in ('NCD_RETINOPATHY_TEST');

Drop table if exists public.ncd_retinopathy_test_detail;
CREATE TABLE IF NOT EXISTS public.ncd_retinopathy_test_detail
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	family_id integer,
	location_id integer,
    service_date timestamp without time zone NOT NULL,
    on_diabetes_treatment boolean,
    diabetes_treatment text,
    past_eye_operation boolean,
    eye_operation_type text,
    vision_problem_flag boolean,
    vision_problem text,
    vision_problem_duration integer,
    absent_eyeball text,
    retinopathy_test_flag boolean,
    remidio_id text,
    right_eye_retinopathy_detected boolean,
    left_eye_retinopathy_detected boolean,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default"
);