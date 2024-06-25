update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,"canGvkImmunisationVerification":true,"canHighriskFollowupVerification":true,"canPregnancyRegistrationsVerification":true,"canHighriskFollowupVerificationFowFhw":false,"canPregnancyRegistrationsPhoneNumberVerification":false}'
        where navigation_state = 'techo.dashboard.gvkverification';

create table if not exists gvk_emri_pregnant_member_mobile_number_verification_response
(
  id bigserial NOT NULL,
  preg_mem_phone_number_verification_id bigint,
  member_id bigint,
  gvk_call_response_status varchar(255),
  number_belong_to text,
  mobile_number varchar(12),
  phone_number_collection_pending boolean,
  is_fhw_called boolean,
  is_asha_called boolean,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_emri_pregnant_member_mobile_number_verification_response_pkey PRIMARY KEY (id)
);

