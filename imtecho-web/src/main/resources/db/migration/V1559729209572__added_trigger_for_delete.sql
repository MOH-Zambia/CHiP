CREATE TABLE public.imt_member_archive
(
  id bigint,
  unique_health_id text NOT NULL,
  family_id text,
  first_name text,
  middle_name text,
  last_name text,
  grandfather_name text,
  dob date,
  emamta_health_id text,
  family_head boolean,
  is_aadhar_verified boolean,
  is_mobile_verified boolean,
  is_native boolean,
  is_pregnant boolean,
  lmp date,
  family_planning_method text,
  gender text,
  account_number text,
  ifsc text,
  marital_status integer,
  mobile_number text,
  normal_cycle_days smallint,
  state text,
  education_status integer,
  is_report boolean,
  name_as_per_aadhar text,
  current_state bigint,
  merged_from_family_id character varying(50),
  agreed_to_share_aadhar boolean,
  aadhar_number_available boolean,
  aadhar_number_encrypted character varying(32),
  death_detail_id bigint,
  jsy_payment_given boolean,
  early_registration boolean,
  jsy_beneficiary boolean,
  haemoglobin real,
  weight real,
  edd timestamp without time zone,
  anc_visit_dates text,
  immunisation_given text,
  place_of_birth character varying(15),
  birth_weight real,
  complementary_feeding_started boolean,
  mother_id bigint,
  year_of_wedding smallint,
  last_method_of_contraception character varying(15),
  is_high_risk_case boolean,
  cur_preg_reg_det_id bigint,
  blood_group character varying(3),
  fp_insert_operate_date timestamp without time zone,
  menopause_arrived boolean,
  kpsy_beneficiary boolean,
  iay_beneficiary boolean,
  chiranjeevi_yojna_beneficiary boolean,
  sync_status text,
  is_iucd_removed boolean,
  iucd_removal_date timestamp without time zone,
  cur_preg_reg_date timestamp without time zone,
  basic_state text,
  eye_issue text,
  current_disease text,
  chronic_disease text,
  congenital_anomaly text,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  last_delivery_date timestamp without time zone,
  hysterectomy_done boolean,
  cbac_done boolean,
  ncd_screening_needed boolean,
  hypertension_screening_done boolean,
  oral_screening_done boolean,
  diabetes_screening_done boolean,
  breast_screening_done boolean,
  cervical_screening_done boolean,
  child_nrc_cmtc_status text,
  last_delivery_outcome text,
  remarks text,
  additional_info text,
  suspected_cp boolean,
  npcb_screening_date date
);


CREATE OR REPLACE FUNCTION imt_member_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.imt_member_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';

CREATE TRIGGER imt_member_delete_trigger AFTER DELETE ON imt_member
FOR EACH ROW EXECUTE PROCEDURE imt_member_delete_trigger_function();

-- FOR rch_pnc_master

CREATE TABLE public.rch_pnc_master_archive
(
  id bigint,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  notification_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  member_status character varying(15),
  pregnancy_reg_det_id bigint,
  pnc_no text,
  is_from_web boolean,
  service_date timestamp without time zone,
  delivery_place text,
  type_of_hospital bigint,
  health_infrastructure_id bigint,
  delivery_done_by text,
  delivery_person bigint,
  delivery_person_name text
);


CREATE OR REPLACE FUNCTION rch_pnc_master_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.rch_pnc_master_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rch_pnc_master_delete_trigger AFTER DELETE ON rch_pnc_master
FOR EACH ROW EXECUTE PROCEDURE rch_pnc_master_delete_trigger_function();

-- FOR anc master


CREATE TABLE public.rch_anc_master_archive
(
  id bigint,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  lmp timestamp without time zone,
  weight real,
  jsy_beneficiary boolean,
  kpsy_beneficiary boolean,
  iay_beneficiary boolean,
  chiranjeevi_yojna_beneficiary boolean,
  anc_place bigint,
  systolic_bp integer,
  diastolic_bp integer,
  member_height integer,
  foetal_height integer,
  foetal_heart_sound boolean,
  ifa_tablets_given integer,
  fa_tablets_given integer,
  calcium_tablets_given integer,
  hbsag_test character varying(30),
  blood_sugar_test character varying(30),
  urine_test_done boolean,
  albendazole_given boolean,
  referral_place bigint,
  dead_flag boolean,
  other_dangerous_sign character varying(500),
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  member_status character varying(100),
  edd timestamp without time zone,
  notification_id bigint,
  death_date timestamp without time zone,
  vdrl_test character varying(20),
  hiv_test character varying(20),
  place_of_death character varying(20),
  haemoglobin_count real,
  death_reason character varying(50),
  jsy_payment_done boolean,
  last_delivery_outcome character varying(50),
  expected_delivery_place character varying(50),
  family_planning_method character varying(50),
  foetal_position character varying(50),
  dangerous_sign_id character varying(50),
  other_previous_pregnancy_complication character varying(50),
  foetal_movement character varying(15),
  referral_done character varying(15),
  urine_albumin character varying(15),
  urine_sugar character varying(15),
  is_high_risk_case boolean,
  blood_group character varying(3),
  sugar_test_after_food_val integer,
  sugar_test_before_food_val integer,
  pregnancy_reg_det_id bigint,
  service_date timestamp without time zone,
  sickle_cell_test text,
  is_from_web boolean,
  delivery_place text,
  type_of_hospital bigint,
  health_infrastructure_id bigint,
  delivery_done_by text,
  delivery_person bigint,
  delivery_person_name text,
  anmol_registration_id character varying(255),
  anmol_anc_wsdl_code text,
  anmol_anc_status character varying(50),
  anmol_anc_date timestamp without time zone,
  anc_done_at text,
  other_death_reason text
);


CREATE OR REPLACE FUNCTION rch_anc_master_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.rch_anc_master_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rch_anc_master_delete_trigger AFTER DELETE ON rch_anc_master
FOR EACH ROW EXECUTE PROCEDURE rch_anc_master_delete_trigger_function();

-- for rch_pregnancy_analytics_details


CREATE TABLE public.rch_pregnancy_registration_det_archive
(
  id bigint,
  mthr_reg_no text,
  member_id bigint,
  lmp_date date,
  edd date,
  reg_date timestamp without time zone,
  state text,
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  location_id bigint,
  family_id bigint,
  current_location_id bigint,
  delivery_date date,
  is_reg_date_verified boolean
);

CREATE OR REPLACE FUNCTION rch_pregnancy_registration_det_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.rch_pregnancy_registration_det_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rch_anc_mastech_pregnancy_registration_det_delete_trigger AFTER DELETE ON rch_pregnancy_registration_det
FOR EACH ROW EXECUTE PROCEDURE rch_pregnancy_registration_det_delete_trigger_function();

-- for lmp followup


CREATE TABLE public.rch_lmp_follow_up_archive
(
  id bigint,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  lmp timestamp without time zone,
  is_pregnant boolean,
  pregnancy_test_done boolean,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  register_now_for_pregnancy boolean,
  notification_id bigint,
  family_planning_method character varying(50),
  year smallint,
  fp_insert_operate_date timestamp without time zone,
  place_of_death character varying(20),
  member_status character varying(15),
  death_date timestamp without time zone,
  death_reason character varying(50),
  service_date timestamp without time zone,
  anmol_registration_id character varying(255),
  anmol_follow_up_status character varying(50),
  anmol_follow_up_wsdl_code text,
  anmol_follow_up_date timestamp without time zone,
  other_death_reason text
);


CREATE OR REPLACE FUNCTION rch_lmp_follow_up_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.rch_lmp_follow_up_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rch_lmp_follow_up_delete_trigger AFTER DELETE ON rch_lmp_follow_up
FOR EACH ROW EXECUTE PROCEDURE rch_lmp_follow_up_delete_trigger_function();

-- for rch_immunisation_master

CREATE TABLE public.rch_wpd_mother_master_archive
(
  id bigint,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude text,
  longitude text,
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  date_of_delivery timestamp without time zone,
  member_status text,
  is_preterm_birth boolean,
  delivery_place text,
  type_of_hospital bigint,
  delivery_done_by text,
  mother_alive boolean,
  type_of_delivery text,
  referral_place bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  discharge_date timestamp without time zone,
  breast_feeding_in_one_hour boolean,
  notification_id bigint,
  death_date timestamp without time zone,
  death_reason text,
  place_of_death text,
  cortico_steroid_given boolean,
  mtp_done_at bigint,
  mtp_performed_by text,
  has_delivery_happened boolean,
  other_danger_signs text,
  is_high_risk_case boolean,
  referral_done text,
  pregnancy_reg_det_id bigint,
  pregnancy_outcome text,
  is_discharged boolean,
  misoprostol_given boolean,
  free_drop_delivery text,
  delivery_person bigint,
  health_infrastructure_id bigint,
  state text,
  delivery_person_name text,
  is_from_web boolean,
  institutional_delivery_place text,
  other_death_reason text
);


CREATE OR REPLACE FUNCTION rch_wpd_mother_master_delete_trigger_function() RETURNS TRIGGER AS '
BEGIN

INSERT INTO public.rch_wpd_mother_master_archive
    SELECT OLD.*;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rrch_wpd_mother_master_delete_trigger AFTER DELETE ON rch_wpd_mother_master
FOR EACH ROW EXECUTE PROCEDURE rch_wpd_mother_master_delete_trigger_function();