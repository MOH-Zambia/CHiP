-- for task https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2739

alter table npcb_member_examination_detail
drop column if exists re_pinhole,
add column re_pinhole real,
drop column if exists le_pinhole,
add column le_pinhole real,
drop column if exists re_glass,
add column re_glass real,
drop column if exists le_glass,
add column le_glass real;
