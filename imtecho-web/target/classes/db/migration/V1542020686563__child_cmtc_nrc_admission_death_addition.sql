alter table child_cmtc_nrc_admission_detail
drop column if exists death_date,
drop column if exists death_reason,
drop column if exists other_death_reason,
drop column if exists death_place,
add column death_date timestamp without time zone,
add column death_reason text,
add column other_death_reason text,
add column death_place bigint;