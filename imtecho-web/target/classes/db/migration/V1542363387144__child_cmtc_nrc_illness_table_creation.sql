drop table if exists child_cmtc_nrc_illness_detail;

CREATE TABLE public.child_cmtc_nrc_illness_detail
(
  admission_id bigint NOT NULL,
  illness text,
  CONSTRAINT child_cmtc_nrc_illness_detail_pkey PRIMARY KEY (admission_id, illness),
  CONSTRAINT child_cmtc_nrc_illness_detail_admission_id_fkey FOREIGN KEY (admission_id)
      REFERENCES public.child_cmtc_nrc_admission_detail (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

alter table child_cmtc_nrc_admission_detail
drop column if exists illness;