drop table if exists gvk_anm_verification_info;

CREATE TABLE gvk_anm_verification_info
(
  id bigserial primary key,
  member_id bigint NOT NULL,
  anm_id bigint,
  asha_id bigint,
  location_id bigint NOT NULL,
  service_type character varying NOT NULL,
  reference_id bigint NOT NULL,
  schedule_date timestamp without time zone,
  call_attempt integer NOT NULL,
  gvk_call_status character varying,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint NOT NULL,
  modified_on timestamp without time zone NOT NULL,
  load_date timestamp without time zone
);

drop table if exists gvk_anm_verification_response;

CREATE TABLE gvk_anm_verification_response
(
  id bigserial primary key,
  request_id bigint NOT NULL,
  member_id bigint NOT NULL,
  location_id bigint NOT NULL,
  service_type character varying NOT NULL,
  gvk_call_response_status character varying NOT NULL,
  tt_injection_received_status character varying,
  delivery_status boolean,
  delivery_place_status character varying,
  child_service_vaccination_status boolean,
  is_beneficiary_called boolean,
  is_family_member_called boolean,
  called_person_name character varying,
  manage_call_master_id bigint NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint NOT NULL,
  modified_on timestamp without time zone NOT NULL,
  load_date timestamp without time zone,
  no_of_male_child integer,
  no_of_female_child integer,
  total_child integer
);

update menu_config
set feature_json = '{"canAbsentVerification":true,
"canFamilyVerification":true,
"canGvkImmunisationVerification":true,
"canHighriskFollowupVerification":true,
"canPregnancyRegistrationsVerification":true,
"canHighriskFollowupVerificationFowFhw":false,
"canPregnancyRegistrationsPhoneNumberVerification":false,
"canMemberMigrationOutVerification":false,
"canMemberMigrationInVerification":false,
"canDuplicateMemberVerification":false,
"canPerformEligibleCoupleCounselling":false,
"canAnmVerification":false
}'
where menu_name = 'Call Centre Verification';