alter table rch_anc_master
drop column if exists blood_transfusion,
drop column if exists iron_def_anemia_inj,
drop column if exists iron_def_anemia_inj_due_date,
add column blood_transfusion boolean,
add column iron_def_anemia_inj character varying,
add column iron_def_anemia_inj_due_date timestamp without time zone;

alter table rch_anc_master_archive
drop column if exists blood_transfusion,
drop column if exists iron_def_anemia_inj,
drop column if exists iron_def_anemia_inj_due_date,
add column blood_transfusion boolean,
add column iron_def_anemia_inj character varying,
add column iron_def_anemia_inj_due_date timestamp without time zone;