DROP TABLE IF EXISTS malaria_non_index_case_details;
CREATE TABLE if not exists malaria_non_index_case_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  gps_location text,
  has_consent_sought boolean,
  reason_for_no_consent text,
  individuals_living integer,
  individuals_on_last_night integer,
  people_tested_in_household integer,
  people_rcd_positive integer,
  sprayable_surface text,
  non_sprayable_surface text,
  was_irs_conducted boolean,
  date_of_last_spray date,
  having_llin_in_house text,
  number_of_llins_hanging integer,
  sleep_under_llin boolean,
  took_dhap boolean,
  took_med_for_malaria_prevention boolean,
  received_any_other_prevention boolean,
  other_preventive_measure text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);




