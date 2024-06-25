alter table um_role_master
add column if not exists is_last_name_mandatory bool;

delete from listvalue_field_value_detail where field_key = 'health_infra_facilities';
delete from listvalue_field_master where field_key = 'health_infra_facilities';

insert into listvalue_field_master
(field_key,field,is_active,field_type,form)
values('health_infra_facilities','Health Infrastructure Facilities',true,'T','WEB');

alter table listvalue_field_value_detail
alter column code type text;

alter table health_infrastructure_details
add column if not exists has_ventilators bool,
add column if not exists has_defibrillators bool,
add column if not exists has_oxygen_cylinders bool;

alter table archive.health_infrastructure_details_history
add column if not exists has_ventilators bool,
add column if not exists has_defibrillators bool,
add column if not exists has_oxygen_cylinders bool;


INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'FRU', 'health_infra_facilities', 0, NULL, 'FRU');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Full Time Pediatrician', 'health_infra_facilities', 0, NULL, 'FULL_TIME_PEDIATRICIAN');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'CMTC', 'health_infra_facilities', 0, NULL, 'CMTC');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'NRC', 'health_infra_facilities', 0, NULL, 'NRC');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Full Time Gynecologist', 'health_infra_facilities', 0, NULL, 'FULL_TIME_GYNECOLOGIST');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'SNCU', 'health_infra_facilities', 0, NULL, 'SNCU');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Blood Bank', 'health_infra_facilities', 0, NULL, 'BLOOD_BANK');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'NCD', 'health_infra_facilities', 0, NULL, 'NCD');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'CP Confirmation Center', 'health_infra_facilities', 0, NULL, 'CP_CONFIRMATION_CENTER');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'HWC', 'health_infra_facilities', 0, NULL, 'HWC');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'No Reporting Unit', 'health_infra_facilities', 0, NULL, 'NO_REPORTING_UNIT');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Balsakha-1', 'health_infra_facilities', 0, NULL, 'BALSAKHA_1');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Covid Hospital', 'health_infra_facilities', 0, NULL, 'COVID_HOSPITAL');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Covid Lab', 'health_infra_facilities', 0, NULL, 'COVID_LAB');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Chiranjivi Yojana', 'health_infra_facilities', 0, NULL, 'CHIRANJIVI_YOJANA');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Balsakha-3', 'health_infra_facilities', 0, NULL, 'BALSAKHA_3');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'USG facility', 'health_infra_facilities', 0, NULL, 'USG');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Referral Facility', 'health_infra_facilities', 0, NULL, 'REFERRAL');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'MA Yojana', 'health_infra_facilities', 0, NULL, 'MA_YOJANA');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'PMJAY Facility', 'health_infra_facilities', 0, NULL, 'PMJAY');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'NPCB Referral Center', 'health_infra_facilities', 0, NULL, 'NPCB_REFERRAL');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'IDSP', 'health_infra_facilities', 0, NULL, 'IDSP');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Ventilators', 'health_infra_facilities', 0, NULL, 'VENTILATORS');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Defibrillators', 'health_infra_facilities', 0, NULL, 'DEFIBRILLATORS');
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, '-1', now(), 'Oxygen Cylinders', 'health_infra_facilities', 0, NULL, 'OXYGEN_CYLINDERS');

create table if not exists health_infrastructure_type_allowed_facilities(
	id serial primary key,
	health_infra_type_id integer,
	allowed_facilities text
);


update menu_config
set feature_json = cast(cast(feature_json as jsonb) || cast('{"canEditVentilators":false,"canEditDefibrillators":false,"canEditOxygenCylinders":false}' as jsonb) as text)
where menu_name = 'Health Facility Mapping';