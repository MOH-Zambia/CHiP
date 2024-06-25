drop table if exists child_cmtc_nrc_admission_illness_detail;

CREATE TABLE public.child_cmtc_nrc_admission_illness_detail
(
  admission_id bigint NOT NULL,
  illness text,
  CONSTRAINT child_cmtc_nrc_admission_illness_detail_pkey PRIMARY KEY (admission_id, illness),
  CONSTRAINT child_cmtc_nrc_admission_illness_detail_admission_id_fkey FOREIGN KEY (admission_id)
      REFERENCES public.child_cmtc_nrc_admission_detail (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

alter table child_cmtc_nrc_admission_detail
drop column if exists illness;

drop table if exists child_cmtc_nrc_discharge_illness_detail;

CREATE TABLE public.child_cmtc_nrc_discharge_illness_detail
(
  discharge_id bigint NOT NULL,
  illness text,
  CONSTRAINT child_cmtc_nrc_discharge_illness_detail_pkey PRIMARY KEY (discharge_id, illness),
  CONSTRAINT child_cmtc_nrc_discharge_illness_detail_discharge_id_fkey FOREIGN KEY (discharge_id)
      REFERENCES public.child_cmtc_nrc_discharge_detail (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

alter table child_cmtc_nrc_discharge_detail
drop column if exists illness;

drop table if exists child_cmtc_nrc_follow_up_illness_detail;

CREATE TABLE public.child_cmtc_nrc_follow_up_illness_detail
(
  follow_up_id bigint NOT NULL,
  illness text,
  CONSTRAINT child_cmtc_nrc_follow_up_illness_detail_pkey PRIMARY KEY (follow_up_id, illness),
  CONSTRAINT child_cmtc_nrc_follow_up_illness_detail_follow_up_id_fkey FOREIGN KEY (follow_up_id)
      REFERENCES public.child_cmtc_nrc_follow_up (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

alter table child_cmtc_nrc_follow_up
drop column if exists illness;

drop table if exists child_cmtc_nrc_illness_detail;