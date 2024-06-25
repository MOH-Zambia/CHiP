alter table child_cmtc_nrc_screening_detail
drop column if exists referred_from,
drop column if exists referred_to,
drop column if exists referred_date,
drop column if exists is_archive,
add column referred_from bigint,
add column referred_to bigint,
add column referred_date timestamp without time zone,
add column is_archive boolean;