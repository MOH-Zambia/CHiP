alter table anmol_master
	add child_registration_date timestamp without time zone;

	alter table anmol_master
	add child_infant_registration_date timestamp without time zone;

	alter table rch_lmp_follow_up
	add anmol_follow_up_date timestamp without time zone;

	alter table rch_pnc_mother_master
	add anmol_pnc_date timestamp without time zone;

	alter table rch_anc_master
	add anmol_anc_date timestamp without time zone;

	alter table rch_pnc_child_master
	add anmol_pnc_date timestamp without time zone;

	alter table rch_child_service_master
	add anmol_child_tracking_date timestamp without time zone;

	alter table rch_child_service_master
	add anmol_child_tracking_medical_date timestamp without time zone;

    alter table anmol_master
	add column case_no INT;


	alter table anmol_master
	add column state character varying(100)