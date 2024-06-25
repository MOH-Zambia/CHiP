alter table child_cmtc_nrc_admission_detail
drop column if exists defaulter_date,
add column defaulter_date timestamp without time zone;