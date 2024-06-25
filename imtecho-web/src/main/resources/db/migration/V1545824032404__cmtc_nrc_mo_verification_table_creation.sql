drop table if exists child_cmtc_nrc_mo_verification;

create table child_cmtc_nrc_mo_verification
(
  id bigserial primary key,
  child_id bigint,
  weight real,
  height integer,
  mid_upper_arm_circumference integer,
  sd_score text,
  bilateral_pitting_oedema text,
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint
);