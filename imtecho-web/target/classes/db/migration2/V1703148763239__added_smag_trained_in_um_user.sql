alter table if exists um_role_master add column if not exists is_smag_trained_mandatory boolean;

alter table if exists um_user add column if not exists is_user_smag_trained boolean;