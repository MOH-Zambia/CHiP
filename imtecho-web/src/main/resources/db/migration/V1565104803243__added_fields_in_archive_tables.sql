alter table rch_lmp_follow_up_archive
drop column if exists other_death_reason,
add column other_death_reason text,
drop column if exists anmol_registration_id,
add column anmol_registration_id character varying(255),
drop column if exists anmol_upload_status_code,
add column anmol_upload_status_code text,
drop column if exists anmol_follow_up_status,
add column anmol_follow_up_status character varying(255),
drop column if exists anmol_follow_up_wsdl_code,
add column anmol_follow_up_wsdl_code text,
drop column if exists anmol_follow_up_date,
add column anmol_follow_up_date timestamp without time zone,
drop column if exists phone_number,
add column phone_number text;

alter table rch_immunisation_master_archive 
drop column if exists anmol_child_tracking_status,
add column anmol_child_tracking_status character varying(255),
drop column if exists anmol_child_tracking_wsdl_code,
add column anmol_child_tracking_wsdl_code text,
drop column if exists anmol_child_tracking_date,
add column anmol_child_tracking_date timestamp without time zone,
drop column if exists vitamin_a_no,
add column vitamin_a_no integer,
drop column if exists anmol_child_tracking_reg_id,
add column anmol_child_tracking_reg_id character varying(255);