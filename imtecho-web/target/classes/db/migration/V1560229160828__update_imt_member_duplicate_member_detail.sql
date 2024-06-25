alter table imt_member_duplicate_member_detail 
add column gvk_call_status character varying(128) default 'com.argusoft.imtecho.gvk.call.to-be-processed',
add column call_attempt int default 0,
add column schedule_date timestamp without time zone default current_timestamp;

update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,
                            "canGvkImmunisationVerification":true,
                            "canHighriskFollowupVerification":true,
                            "canPregnancyRegistrationsVerification":true,
                            "canHighriskFollowupVerificationFowFhw":false,
                            "canPregnancyRegistrationsPhoneNumberVerification":false,
                            "canMemberMigrationOutVerification":false,
                            "canMemberMigrationInVerification":false,
                            "canDuplicateMemberVerification":false}'
        where navigation_state = 'techo.dashboard.gvkverification';


create table if not exists gvk_duplicate_member_verification_response
(
  id bigserial NOT NULL,
  duplicate_member_verification_id bigint,
  gvk_call_response_status varchar(255),
  processing_time bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_duplicate_member_verification_response_pkey PRIMARY KEY (id)
);

