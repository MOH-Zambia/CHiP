CREATE TABLE  if not exists gvk_emri_pregnant_member_info
(
  id bigserial NOT NULL,
  member_id bigint,
  pregnancy_reg_id bigint,
  gvk_call_state varchar(255),
  schedule_date timestamp without time zone,
  call_attempt int default 0,
  location_id bigint,
  lmp_date date,
  reg_date timestamp without time zone,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_emri_pregnant_member_info_pkey PRIMARY KEY (id)
);

create table if not exists gvk_emri_pregnant_member_responce
(
  id bigserial NOT NULL ,
  gvk_emri_pregnant_usr_id bigint,
  member_id bigint,
  gvk_call_response_status varchar(255),
  is_pregnant boolean,
  is_lmp_date_mentioned_correctly boolean,
  lmp_input_date timestamp without time zone,
  processing_time bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_emri_pregnant_member_responce_pkey PRIMARY KEY (id)
);

update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,"canGvkImmunisationVerification":true,"canHighriskFollowupVerification":true,"canPregnancyRegistrationsVerification":true}'
        where navigation_state = 'techo.dashboard.gvkverification';

alter table gvk_immunisation_verification_response 
    add column processing_time bigint;