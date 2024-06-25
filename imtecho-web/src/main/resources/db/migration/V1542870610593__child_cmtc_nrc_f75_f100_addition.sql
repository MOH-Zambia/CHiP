alter table child_cmtc_nrc_weight_detail
drop column if exists f_75,
drop column if exists f_100,
drop column if exists epd,
add column f_75 boolean,
add column f_100 boolean,
add column epd boolean;