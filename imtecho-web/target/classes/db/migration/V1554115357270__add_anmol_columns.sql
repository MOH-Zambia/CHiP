alter table rch_lmp_follow_up
add anmol_follow_up_status character varying(50),
add anmol_follow_up_wsdl_code text,
add anmol_follow_up_xml text;

alter table rch_pnc_mother_master
add anmol_registration_id character varying(255),
add anmol_pnc_wsdl_code text,
add anmol_pnc_xml text;

alter table rch_pnc_mother_master
add anmol_pnc_status character varying(50);

alter table rch_anc_master
add anmol_registration_id character varying(255),
add anmol_anc_wsdl_code text,
add anmol_anc_xml text;

alter table rch_anc_master
add anmol_anc_status character varying(50);

alter table rch_pnc_child_master
add anmol_child_registration_id character varying(255),
add anmol_pnc_wsdl_code text,
add anmol_pnc_xml text;

alter table rch_pnc_child_master
add anmol_pnc_status character varying(50);


alter table rch_child_service_master
add column anmol_child_tracking_reg_id character varying(255),
add column anmol_child_tracking_status character varying(50),
add column anmol_child_tracking_wsdl_code text,
add column anmol_child_tracking_xml text,
add column anmol_child_tracking_medical_reg_id character varying(255),
add column anmol_child_tracking_medical_status character varying(50),
add column anmol_child_tracking_medical_wsdl_code text,
add column anmol_child_tracking_medical_xml text;