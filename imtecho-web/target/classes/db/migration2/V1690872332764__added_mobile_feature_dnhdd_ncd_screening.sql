
--new master tables
create TABLE ncd_cancer_screening_master
(
  id serial primary key,
  member_id integer,
  family_id integer,
  location_id integer,
  service_date timestamp without time zone,
  oral_table_id text,
  breast_table_id text,
  cervical_table_id text,
  created_by integer null,
  created_on timestamp without time zone NULL,
  modified_by integer NULL,
  modified_on timestamp without time zone NULL);

  create TABLE ncd_hypertension_diabetes_mental_health_master
  (
    id serial primary key,
    member_id integer,
    family_id integer,
    location_id integer,
    service_date timestamp without time zone,
    hypertension_table_id text,
    diabetes_table_id text,
    mentalHealth_table_id text,
    created_by integer null,
    created_on timestamp without time zone NULL,
    modified_by integer NULL,
    modified_on timestamp without time zone NULL);

--columns in hypertension
alter table ncd_member_hypertension_detail
drop column if exists hyper_dia_mental_master_id,
add column hyper_dia_mental_master_id integer;

alter table ncd_member_hypertension_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_hypertension_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_hypertension_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

--columns in diabetes
alter table ncd_member_diabetes_detail
drop column if exists hyper_dia_mental_master_id,
add column hyper_dia_mental_master_id integer;

alter table ncd_member_diabetes_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_diabetes_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_diabetes_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

--columns in mental health
alter table ncd_member_mental_health_detail
drop column if exists hyper_dia_mental_master_id,
add column hyper_dia_mental_master_id integer;

alter table ncd_member_mental_health_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_mental_health_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_mental_health_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

--columns in oral
alter table ncd_member_oral_detail
drop column if exists cancer_screening_master_id,
add column cancer_screening_master_id integer;

alter table ncd_member_oral_detail
drop column if exists diagnosed_earlier,
add column diagnosed_earlier boolean;

alter table ncd_member_oral_detail
drop column if exists currently_under_treatment,
add column currently_under_treatment boolean;

alter table ncd_member_oral_detail
drop column if exists current_treatment_place,
add column current_treatment_place text;

alter table ncd_member_oral_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_oral_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_oral_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

--columns in breast
alter table ncd_member_breast_detail
drop column if exists cancer_screening_master_id,
add column cancer_screening_master_id integer;

alter table ncd_member_breast_detail
drop column if exists diagnosed_earlier,
add column diagnosed_earlier boolean;

alter table ncd_member_breast_detail
drop column if exists currently_under_treatment,
add column currently_under_treatment boolean;

alter table ncd_member_breast_detail
drop column if exists current_treatment_place,
add column current_treatment_place text;

alter table ncd_member_breast_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_breast_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_breast_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

--columns in cervical
alter table ncd_member_cervical_detail
drop column if exists cancer_screening_master_id,
add column cancer_screening_master_id integer;

alter table ncd_member_cervical_detail
drop column if exists diagnosed_earlier,
add column diagnosed_earlier boolean;

alter table ncd_member_cervical_detail
drop column if exists currently_under_treatment,
add column currently_under_treatment boolean;

alter table ncd_member_cervical_detail
drop column if exists current_treatment_place,
add column current_treatment_place text;

alter table ncd_member_cervical_detail
drop column if exists govt_facility_id,
add column govt_facility_id integer;

alter table ncd_member_cervical_detail
drop column if exists private_facility,
add column private_facility text;

alter table ncd_member_cervical_detail
drop column if exists out_of_territory_facility,
add column out_of_territory_facility text;

alter table ncd_member_cervical_detail
drop column if exists future_screening_date,
add column future_screening_date timestamp without time zone;

update system_configuration set key_value = '89' where system_key = 'MOBILE_FORM_VERSION';




















