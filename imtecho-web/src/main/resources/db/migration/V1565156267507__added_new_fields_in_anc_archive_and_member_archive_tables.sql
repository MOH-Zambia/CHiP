alter table rch_anc_master_archive
drop column if exists other_death_reason,
add column other_death_reason text,
drop column if exists anmol_registration_id,
add column anmol_registration_id character varying(255),
drop column if exists anmol_anc_wsdl_code,
add column anmol_anc_wsdl_code text,
drop column if exists anmol_anc_status,
add column anmol_anc_status character varying(255),
drop column if exists anmol_anc_date,
add column anmol_anc_date timestamp without time zone,
drop column if exists blood_transfusion,
add column blood_transfusion boolean,
drop column if exists iron_def_anemia_inj,
add column iron_def_anemia_inj character varying(255),
drop column if exists iron_def_anemia_inj_due_date,
add column iron_def_anemia_inj_due_date timestamp without time zone;


alter table imt_member_archive 
drop column if exists fhsr_phone_verified,
add column fhsr_phone_verified boolean;