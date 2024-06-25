DROP TABLE IF EXISTS public.ncd_member_diabetes_detail;
CREATE TABLE public.ncd_member_diabetes_detail
(
  id bigserial,
  member_id bigint NOT NULL,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  screening_date timestamp without time zone,
  blood_sugar integer,
  earlier_diabetes_diagnosis boolean,
  currently_under_treatment boolean,
  refferal_done boolean,
  refferal_place text,
  remarks text,
  CONSTRAINT ncd_member_diabetes_detail_pkey PRIMARY KEY (id)
);