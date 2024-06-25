DROP TABLE IF EXISTS malaria_details;

CREATE TABLE if not exists malaria_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  active_malaria_symptoms text,
  rdt_test_status text,
  having_travel_history boolean,
  malaria_treatment_history boolean,
  is_treatment_being_given boolean,
  referral_place integer,
  malaria_type text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);

DROP TABLE IF EXISTS tuberculosis_screening_details;

CREATE TABLE if not exists tuberculosis_screening_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  tuberculosis_symptoms text,
  is_tb_testing_done boolean,
  tb_test_type text,
  is_tb_suspected boolean,
  referral_place integer,
  is_tb_cured boolean,
  is_patient_taking_medicines boolean,
  any_reaction_or_side_effect boolean,
  fu_referral_place integer,
  form_type text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);


DROP TABLE IF EXISTS covid_screening_details;

CREATE TABLE if not exists covid_screening_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  is_dose_one_taken boolean,
  dose_one_name text,
  dose_one_date timestamp,
  is_dose_two_taken boolean,
  dose_two_name text,
  dose_two_date timestamp,
  willing_for_booster_vaccine boolean,
  is_booster_dose_given boolean,
  booster_name text,
  booster_date timestamp,
  dose_one_schedule_date timestamp,
  dose_two_schedule_date timestamp,
  booster_dose_schedule_date timestamp,
  any_reactions boolean,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);

delete from form_master where code = 'CHIP_TB';

insert into form_master(created_by, created_on, modified_by, modified_on, code, name, state)
values (1, now(), 1, now(), 'CHIP_TB', 'CHIP TB', 'ACTIVE');

delete from form_master where code = 'ACTIVE_MALARIA';

insert into form_master(created_by, created_on, modified_by, modified_on, code, name, state)
values (1, now(), 1, now(), 'ACTIVE_MALARIA', 'ACTIVE MALARIA', 'ACTIVE');

INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'TB_FOLLOW_UP_VISIT','TB Follow Up Visit','MO',245,'ACTIVE');

insert into notification_type_role_rel(role_id, notification_type_id)
select 245, id from notification_type_master where code in
('TB_FOLLOW_UP_VISIT');

INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'ACTIVE_MALARIA_FOLLOW_UP_VISIT','Active Malaria Follow Up Visit','MO',245,'ACTIVE');

insert into notification_type_role_rel(role_id, notification_type_id)
select 245, id from notification_type_master where code in
('ACTIVE_MALARIA_FOLLOW_UP_VISIT');

alter table rch_preg_hiv_positive_master
add column if not exists family_id integer,
add column if not exists location_id integer;