alter table if exists anganwadi_master
drop constraint if exists anganwadi_master_icds_code_key;

alter table if exists anganwadi_master
add column if not exists latitude text,
add column if not exists longitude text;