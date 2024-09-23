alter table if exists rch_preg_hiv_positive_master
drop column if exists is_art_done;

alter table if exists rch_preg_hiv_positive_master
add column if not exists is_on_art boolean;