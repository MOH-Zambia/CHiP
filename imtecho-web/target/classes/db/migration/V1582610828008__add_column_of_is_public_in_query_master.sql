-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3124

alter table query_master
drop COLUMN IF EXISTS is_public,
add COLUMN is_public boolean DEFAULT true;
