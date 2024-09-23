ALTER TABLE gbv_visit_master
add COLUMN if not exists photo_doc_id  TEXT;

alter table gbv_visit_master
add column if not exists photo_unique_id text;

alter table gbv_visit_master
add column if not exists gbv_type text;

alter table gbv_visit_master
add column if not exists difficulty_type text;

alter table rch_lmp_follow_up
add column if not exists irregular_periods Boolean;