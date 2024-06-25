-- for task https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3241

-- for table imt_family_verification

alter table imt_family_verification
drop COLUMN IF EXISTS verified_on,
add COLUMN verified_on timestamp without time zone;

alter table imt_family_verification
drop COLUMN IF EXISTS verification_state,
add COLUMN verification_state varchar(255);

-- for table cfhc_mo_verification_status

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS family_verification_id,
add COLUMN family_verification_id integer;

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS verification_body,
add COLUMN verification_body varchar(250);


alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS first_name_status,
add COLUMN first_name_status varchar(50);

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS middle_name_status,
add COLUMN middle_name_status varchar(50);

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS last_name_status,
add COLUMN last_name_status varchar(50);

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS dob_status,
add COLUMN dob_status varchar(50);

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS pregnancy_status,
add COLUMN pregnancy_status varchar(50);

alter table cfhc_mo_verification_status
drop COLUMN IF EXISTS migrated_status,
add COLUMN migrated_status varchar(50);

alter table cfhc_mo_verification_status
alter column relationship_with_hof_status type varchar(50);

alter table cfhc_mo_verification_status
alter column fp_method_status type varchar(50);

alter table cfhc_mo_verification_status
alter column contact_status type varchar(50);

alter table cfhc_mo_verification_status
alter column chronic_disease_status type varchar(50);

alter table cfhc_mo_verification_status
alter column dead_status type varchar(50);
