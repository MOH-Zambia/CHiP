delete from mobile_feature_master where mobile_constant = 'NCD_MO_CONFIRMED';
insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values('NCD_MO_CONFIRMED', 'NCD MO Confirmed', 'NCD MO Confirmed', 'ACTIVE',  now(), -1, now(), -1);

insert into mobile_beans_feature_rel(feature,bean)
	values('NCD_MO_CONFIRMED', 'FamilyBean'),
	('FHW_NCD_WEEKLY_VISIT', 'FamilyBean');

Drop table if exists public.ncd_general_screening;
CREATE TABLE IF NOT EXISTS public.ncd_general_screening
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	family_id integer,
	location_id integer,
    service_date timestamp without time zone NOT NULL,
    duration_of_hypertension integer,
    duration_of_diabetes integer,
    stroke_history boolean,
    stroke_duration_years integer,
    stroke_duration_months integer,
    stroke_symptoms text,
    foot_problem_history boolean,
    foot_problem_cause text,
    amputated_body_part text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default"
);
insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_MO_CONFIRMED', 'NCD_MO_CONFIRMED', now(), -1, now(), -1);


insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'NCD_MO_CONFIRMED' from mobile_form_details where form_name = 'NCD_MO_CONFIRMED';

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_URINE_TEST', 'NCD_URINE_TEST', now(), -1, now(), -1);


insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'NCD_MO_CONFIRMED' from mobile_form_details where form_name = 'NCD_URINE_TEST';


insert into listvalue_field_form_relation (field, form_id)
select 'diseaseHistoryList', id
from mobile_form_details where form_name in ('NCD_MO_CONFIRMED', 'NCD_URINE_TEST');

insert into listvalue_field_form_relation (field, form_id)
select 'religionList', id
from mobile_form_details where form_name in ('NCD_MO_CONFIRMED', 'NCD_URINE_TEST');

insert into listvalue_field_form_relation (field, form_id)
select 'casteList', id
from mobile_form_details where form_name in ('NCD_MO_CONFIRMED', 'NCD_URINE_TEST');

Drop table if exists public.ncd_urine_test;
CREATE TABLE IF NOT EXISTS public.ncd_urine_test
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	family_id integer,
	location_id integer,
    service_date timestamp without time zone NOT NULL,
    urine_test_flag boolean,
    albumin text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default"
);

update system_configuration set key_value = '76' where system_key = 'MOBILE_FORM_VERSION';

