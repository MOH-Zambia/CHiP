alter table rch_opd_member_master
drop column if exists instructions,
add column instructions text;