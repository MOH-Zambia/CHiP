alter table rch_lmp_follow_up 
drop column if exists phone_number,
add column phone_number text;