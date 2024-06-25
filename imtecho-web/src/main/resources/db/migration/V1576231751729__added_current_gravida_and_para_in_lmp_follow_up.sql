alter table rch_lmp_follow_up
drop column if exists current_gravida,
add column current_gravida smallint,
drop column if exists current_para,
add column current_para smallint;