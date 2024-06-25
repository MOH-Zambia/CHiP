alter table child_cmtc_nrc_admission_detail
drop column if exists hemoglobin,
drop column if exists ps_for_mp,
drop column if exists ps_for_mp_value,
drop column if exists monotoux_test,
drop column if exists xray_chest,
drop column if exists blood_group,
drop column if exists urine_rm,
drop column if exists urine_albumin;

drop table if exists child_cmtc_nrc_laboratory_detail;

create table child_cmtc_nrc_laboratory_detail
(
  id bigserial primary key,
  admission_id bigint,
  laboratory_date date,
  hemoglobin_checked boolean,
  hemoglobin real,
  ps_for_mp_checked boolean,
  ps_for_mp text,
  ps_for_mp_value text,
  monotoux_test_checked boolean,
  monotoux_test text,
  xray_chest_checked boolean,
  xray_chest real,
  urine_rm_checked boolean,
  urine_rm text,
  urine_albumin_checked boolean,
  urine_albumin text,
  blood_group text,
  test_output_state text,
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint
);

alter table child_cmtc_nrc_laboratory_detail
add unique (admission_id, laboratory_date);