--DROP TABLE public.imt_member_duplicate_member_detail;

CREATE TABLE public.imt_member_duplicate_member_detail
(
  id bigserial,
  member1_id bigint,
  member2_id bigint,
  is_member1_valid boolean,
  is_member2_valid boolean,
  remarks text,
  is_adhar_number_match boolean,
  is_mobile_number_match boolean,
  is_name_dob_match boolean,
  is_lmp_name_match boolean,
  is_active boolean,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT imt_member_duplicate_member_detail_pkey PRIMARY KEY (id)
);

delete from system_configuration where  system_key = 'LAST_DUPLICATE_SCHEDULER_RUN';

INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('LAST_DUPLICATE_SCHEDULER_RUN', true, 0);
