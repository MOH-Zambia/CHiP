alter table rch_pnc_master
drop column if exists is_from_web, 
add column is_from_web boolean;