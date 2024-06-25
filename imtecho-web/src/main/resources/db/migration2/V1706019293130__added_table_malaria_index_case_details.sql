DROP TABLE IF EXISTS malaria_index_case_details;
CREATE TABLE if not exists malaria_index_case_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  gps_location text,
  was_visit_conducted boolean,
  reason_for_no_visit text,
  individuals_living integer,
  sprayable_surface text,
  non_sprayable_surface text,
  was_irs_conducted boolean,
  date_of_last_spray date,
  having_llin boolean,
  are_llin_hanging boolean,
  number_of_llins_hanging integer,
  sleep_under_llin boolean,
  sleeping_in_sprayed_room boolean,
  days_passed_of_diagnosis integer,
  patient_adhered_to_treatment boolean,
  day_of_treatment text,
  where_evidence_is_seen text,
  temperature text,
  were_you_referred boolean,
  went_to_referral_place boolean,
  patient_showing_signs text,
  patient_experiencing_signs text,
  other_exp_signs text,
  was_dbs_collected boolean,
  blood_splot_value text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);





