alter table um_role_master add column if not exists is_smag_trained_mandatory boolean;

alter table um_user add column if not exists is_user_smag_trained boolean;

Alter table rch_anc_master
add column if not exists transport_arranged boolean;