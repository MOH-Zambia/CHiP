DROP TABLE IF EXISTS public.child_cmtc_nrc_weight_detail;

CREATE TABLE public.child_cmtc_nrc_weight_detail
(
  id bigserial,
  admission_id bigint,
  weight_date timestamp without time zone,
  weight real,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone
);
