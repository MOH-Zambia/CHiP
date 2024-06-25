CREATE TABLE  if not exists gvk_high_risk_follow_up_usr_info
(
  id bigserial NOT NULL ,
  member_id bigint,
  unique_health_id text NOT NULL,
  gvk_call_state varchar(255),
  gvk_call_previous_state varchar(255),
  schedule_date timestamp without time zone,
  pickup_schedule_date timestamp without time zone,
  next_pickup_schedule_date timestamp without time zone,
  call_attempt int default 0,
  diseases varchar(255),
  call_response_message varchar(255),
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_high_risk_follow_up_usr_info_pkey PRIMARY KEY (id)
);

create table if not exists gvk_high_risk_follow_up_responce
(
  id bigserial NOT NULL ,
  gvk_high_risk_usr_id bigint,
  member_id bigint,
  unique_health_id text NOT NULL,   
  gvk_call_response_status varchar(255),
  is_high_risk_condition_confirmed boolean,
  is_conference_call_beneficiary boolean,
  is_beneficiary_willing_to_helped boolean,
  is_schedule_pending boolean,
  schedule_date timestamp without time zone,
  processing_time bigint,
  is_108_pickedup_beneficiary boolean,
  is_beneficiary_visited_phc boolean,
  is_beneficiary_received_blood_lastweek_anemia boolean,
  is_beneficiary_received_fcm_lastweek_anemia varchar(255),
  injection_count_anemia varchar(255),
  is_beneficiary_received_drugs_for_high_bp varchar(255),
  is_new_birth_child_admitted_to_hospital_for_low_birth_weight varchar(255),
  is_beneficiary_child_admitted_to_cmtc_sam varchar(255),
  is_beneficiary_droped_at_home_by_108 boolean,
  is_beneficiary_pickedup_date_for_next_schedule boolean,
  next_pickup_schedule_date timestamp without time zone,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_high_risk_follow_up_responce_pkey PRIMARY KEY (id)
);

update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,"canGvkImmunisationVerification":true,"canHighriskFollowupVerification":true}'
        where navigation_state = 'techo.dashboard.gvkverification';