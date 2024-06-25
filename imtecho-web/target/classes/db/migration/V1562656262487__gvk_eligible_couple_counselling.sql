update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,
                            "canGvkImmunisationVerification":true,
                            "canHighriskFollowupVerification":true,
                            "canPregnancyRegistrationsVerification":true,
                            "canHighriskFollowupVerificationFowFhw":false,
                            "canPregnancyRegistrationsPhoneNumberVerification":false,
                            "canMemberMigrationOutVerification":false,
                            "canMemberMigrationInVerification":false,
                            "canDuplicateMemberVerification":false,
                            "canPerformEligibleCoupleCounselling":false}'
        where navigation_state = 'techo.dashboard.gvkverification';


create table if not exists gvk_eligible_couple_counselling_info
(
  id bigserial NOT NULL,
  membe_id bigint,
  gvk_call_status varchar(255),
  number_of_male_children bigint,
  number_of_female_children bigint,
  youngest_child_age bigint,
  call_attempt bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_eligible_couple_counselling_pkey PRIMARY KEY (id)
);

create table if not exists gvk_eligible_couple_counselling_response
(
  id bigserial NOT NULL,
  manage_call_master_id bigint,
  member_id bigint,
  eligible_couple_counselling_id bigint,
  gvk_call_response_status varchar(255),
  ready_to_adopt_family_planning_method boolean,
  family_planning_method varchar(128),
  processing_time bigint,
  CONSTRAINT gvk_eligible_couple_counselling_response_pkey PRIMARY KEY (id)
);


CREATE TABLE if not exists gvk_manage_call_master
(
  id bigserial NOT NULL,
  user_id bigint,
  member_id bigint,
  mobile_number varchar(12),
  call_type varchar(255),
  call_response varchar(255),
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT gvk_manage_call_master_pkey PRIMARY KEY (id)
);

