alter table gvk_emri_pregnant_member_responce 
drop column is_lmp_date_mentioned_correctly ,
drop column lmp_input_date ,
drop column phone_number_verification_status;


alter table gvk_emri_pregnant_member_responce 
add column mobile_number_belong_to text,
add column is_beneficiary_have_own_mobile_number boolean;

create table if not exists gvk_emri_pregnant_member_mobile_number_verification
(
  id bigserial NOT NULL ,
  member_id bigint,
  gvk_call_status varchar(255),
  is_pregnancy_verified boolean,
  schedule_date timestamp without time zone,
  location_id bigint,
  phone_number_status text,
  call_attempt int default 0,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT gvk_emri_pregnant_member_mobile_number_verification_pkey PRIMARY KEY (id)
);

